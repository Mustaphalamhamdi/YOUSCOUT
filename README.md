# YouScout Backend MVP

MVP backend for YouScout — a football talent-discovery social platform. Three Spring Boot microservices demonstrating **Hexagonal Architecture, SOLID, CQRS, and Event-Driven communication via Kafka**. Built as an EFM final project for the Software Architecture & Design Patterns module at ISMAGI.

---

## Architecture Map

```
                   ┌─────────────────────────────────────────┐
                   │           Kafka (youscout.video.events)  │
                   └────────────────────┬────────────────────┘
                                        │  VideoPublishedEvent
       ┌────────────────────┐           │  VideoDeletedEvent
       │  identity-profile  │           ▼
       │  service :8081     │    ┌──────────────────┐
       │                    │    │ discovery-service │
       │  Write-side Auth   │    │ :8083             │
       │  JWT issuance      │    │                   │
       └────────────────────┘    │ CQRS Read Side    │
                                 │ Redis projection  │
       ┌────────────────────┐    └──────────────────┘
       │  content-service   │           ▲
       │  :8082             │           │ UserFollowedEvent
       │                    │    ┌──────────────────┐
       │  Write-side video  │    │ youscout.user    │
       │  MinIO + Kafka pub │    │ .events (Kafka)  │
       └────────────────────┘    └──────────────────┘
```

| Service | Bounded Context | Database | Role |
|---|---|---|---|
| `identity-profile-service` | Identity, Profile | PostgreSQL `identity_db` | Auth + user CRUD (write-side) |
| `content-service` | Content, Skill Taxonomy | PostgreSQL `content_db` + MinIO | Video upload + event publishing (write-side) |
| `discovery-service` | Feed | Redis | CQRS read-side — owns NO source data |

---

## Prerequisites

- Java 21
- Maven 3.9+
- Docker + Docker Compose

---

## Run Instructions

### Step 1 — Start infrastructure

```bash
docker-compose up -d
```

Wait for all containers to be healthy (~30s). Verify:
```bash
docker-compose ps
```

### Step 2 — Build (once, from root)

```bash
mvn install -DskipTests
```

### Step 3 — Start the 3 services (3 separate terminals)

```bash
# Terminal 1
cd identity-profile-service && mvn spring-boot:run

# Terminal 2
cd content-service && mvn spring-boot:run

# Terminal 3
cd discovery-service && mvn spring-boot:run
```

### Swagger UIs

- Identity: http://localhost:8081/swagger-ui.html
- Content:  http://localhost:8082/swagger-ui.html
- Discovery: http://localhost:8083/swagger-ui.html

---

## End-to-End Demo Flow (6 cURL commands)

```bash
# 1. Register Alice
curl -s -X POST http://localhost:8081/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"alice@youscout.dev","password":"password123","displayName":"Alice"}' \
  | jq .
# → copy token → JWT_ALICE; copy userId → ALICE_ID

# 2. Register Bob
curl -s -X POST http://localhost:8081/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"bob@youscout.dev","password":"password123","displayName":"Bob"}' \
  | jq .
# → copy token → JWT_BOB; copy userId → BOB_ID

# 3. Alice follows Bob (Discovery service records follow in Redis)
curl -s -X POST http://localhost:8083/api/v1/internal/follow \
  -H "Content-Type: application/json" \
  -d "{\"followerId\":\"$ALICE_ID\",\"followeeId\":\"$BOB_ID\"}"

# 4. Bob uploads a video (Content service → MinIO + Kafka VideoPublishedEvent)
curl -s -X POST http://localhost:8082/api/v1/videos \
  -H "Authorization: Bearer $JWT_BOB" \
  -F "file=@sample.mp4" \
  -F "description=Look at this skill move!" \
  -F "skills=DRIBBLING" \
  -F "skills=VISION"
# → copy videoId → VIDEO_ID

# 5. Alice fetches her feed (reads from Redis projection — NOT from Content DB)
curl -s http://localhost:8083/api/v1/feed \
  -H "Authorization: Bearer $JWT_ALICE" \
  | jq .
# → Bob's video appears in Alice's feed

# 6. Get a presigned stream URL (5-minute TTL, served via MinIO CDN)
curl -s http://localhost:8082/api/v1/videos/$VIDEO_ID/stream | jq .
```

**This flow exercises every architectural decision:**
- Register → JWT issuance (identity-profile-service, BCrypt, hexagonal)
- Follow → Redis projection update (discovery-service, CQRS write)
- Upload → MinIO store + Kafka publish (content-service, event-driven, hexagonal)
- Feed → Redis read (discovery-service, CQRS read — never touches Content DB)
- Stream → presigned URL (MinIO storage port, OCP)

---

## Architectural Patterns in Code

| Pattern | Location |
|---|---|
| **Hexagonal Architecture** | `*/domain/{model,port,service}` + `*/adapter/{in,out}` |
| **CQRS** | content-service (write) → Kafka → discovery-service (Redis read) |
| **Repository (Evans DDD)** | `*/domain/port/out/VideoRepository.java` + persistence adapters |
| **Factory Method** | `User.register(...)`, `Video.upload(...)` |
| **Strategy** | `PasswordHasher` interface + `BCryptPasswordHasherAdapter` |
| **Adapter (GoF)** | Every `adapter/out/*Adapter.java` class |
| **Domain Event** | `VideoPublishedEvent`, `UserFollowedEvent` in `shared-events` |
| **DTO** | `adapter/in/web/dto/` separated from domain models |

---

## ADR Mapping

| ADR | Code Location |
|---|---|
| ADR-001: Event-Driven async | `KafkaEventPublisherAdapter`, Kafka consumers |
| ADR-002: Hexagonal | Every `domain/port/` interface + `adapter/` implementation |
| ADR-003: CQRS | `ProjectEventService`, `RedisFeedReadStoreAdapter`, `GetFeedService` |
| ADR-005: Data ownership | Separate `identity_db` / `content_db`; discovery owns only Redis |
| ADR-008: Versioned events | `EventEnvelope.version` in shared-events |

---

## Cleanup

```bash
docker-compose down -v   # removes containers AND volumes
```

---

## Useful Commands

**Stop everything (keeps data):**
```bash
docker compose stop
```

**Start it back up:**
```bash
docker compose start
```

**View logs for a service:**
```bash
docker compose logs -f kafka
docker compose logs -f postgres
```

**Open a Postgres shell:**
```bash
docker exec -it youscout-postgres psql -U youscout -d identity_db
```

**Open a Redis shell:**
```bash
docker exec -it youscout-redis redis-cli
```

**Watch Kafka events live (great for the defense demo):**
```bash
docker exec -it youscout-kafka kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --topic youscout.video.events \
  --from-beginning
```

---

## Troubleshooting

**Port already in use (5432, 6379, 9092, 9000, 9001).**
Stop the conflicting service, or change the port mapping in `docker-compose.yml` (e.g. `"5433:5432"`).

**Kafka keeps restarting.**
Usually not enough memory. Open Docker Desktop → Settings → Resources → set Memory to at least 4 GB, then:
```bash
docker compose down && docker compose up -d
```

**MinIO bucket missing.**
The `minio-init` container creates it on first start. If it's missing, run:
```bash
docker compose run --rm minio-init
```

**Postgres "database does not exist" when services connect.**
The init script only runs on the first startup with an empty volume. Recreate the volume:
```bash
docker compose down -v
docker compose up -d
```

---

## Known Limitations (MVP)

- No real video transcoding (raw file stored in MinIO)
- Single Kafka broker (no replication)
- Shared JWT secret across services (would use JWKs in production)
- No API Gateway / BFF (mobile calls services directly)
- No Kubernetes manifests (Railway/EKS deployment described in slides)
- No GDPR erasure flow, no parental consent flow
