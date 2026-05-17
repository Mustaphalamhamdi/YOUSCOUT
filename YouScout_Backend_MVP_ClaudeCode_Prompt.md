# ═══════════════════════════════════════════════════════════════════
# YOUSCOUT — BACKEND MVP BUILD PROMPT FOR CLAUDE CODE
# Single-prompt, end-to-end build of 3 Spring Boot microservices
# demonstrating Hexagonal Architecture, SOLID, CQRS, Event-Driven
# ═══════════════════════════════════════════════════════════════════
#
# HOW TO USE
# ----------
# 1. Open Claude Code in an EMPTY directory (e.g. ~/projects/youscout-backend).
# 2. Paste this entire prompt as your first message.
# 3. Claude Code will build everything, set up docker-compose, and tell
#    you how to run it. Total build time: 15-30 minutes depending on model.
#
# AFTER THE BUILD
# ---------------
# - Run `docker-compose up -d` to start infrastructure (Postgres, Redis, Kafka).
# - Run each service with `./mvnw spring-boot:run` from its directory.
# - Test endpoints with the provided cURL examples in README.md.
#
# ═══════════════════════════════════════════════════════════════════
#                  COPY EVERYTHING BELOW THIS LINE
# ═══════════════════════════════════════════════════════════════════

# Project: YouScout Backend MVP

You are building the **backend MVP for YouScout**, a football talent-discovery social platform. This MVP is the implementation portion of a Software Architecture final project (EFM) at ISMAGI (Morocco), and it must visibly demonstrate the architectural patterns documented in the architecture report: **Microservices · Event-Driven · Hexagonal Architecture · SOLID · CQRS · ADR-conformant**.

The audience for the code is an architecture professor who teaches from Richards/Ford's *Fundamentals of Software Architecture*. The code does not need to be production-grade — it needs to be **pedagogically clear**, **architecturally faithful**, and **runnable in one command**.

---

## Scope — Build Exactly This, Nothing More

Build **three Spring Boot microservices** + supporting infrastructure via docker-compose.

| Service | Bounded Contexts | Database | Role in Architecture |
|---|---|---|---|
| `identity-profile-service` | Identity, User Profile | PostgreSQL | Auth (JWT) + user CRUD. Write-side. |
| `content-service` | Content, Skill Taxonomy | PostgreSQL + MinIO (S3-compatible) | Video upload + metadata + skill tagging. Write-side. Publishes events. |
| `discovery-service` | Feed (read model) | Redis | CQRS read-side. Consumes events. Owns NO source data. Demonstrates CQRS pattern. |

Plus shared infrastructure via `docker-compose.yml`:
- PostgreSQL 16 (one instance, two databases: `identity_db`, `content_db`)
- Redis 7 (for Discovery's feed projection)
- Kafka 3.x (single broker, KRaft mode — no Zookeeper)
- MinIO (S3-compatible local object storage)

**Do NOT build:** Social/Engagement service, Communication service, Moderation service, API Gateway, BFF, Talent Scoring, search index. These are out of MVP scope. We have only the vertical slice that proves the architecture: **auth → upload → event → CQRS projection → feed read**.

---

## Required Technology Stack

- **Language:** Java 21 (Spring Boot 3.3+)
- **Build:** Maven (each service has its own `pom.xml` and Maven wrapper)
- **Frameworks per service:**
  - Spring Boot Web (REST)
  - Spring Data JPA (where DB is Postgres)
  - Spring Kafka (producer + consumer)
  - Spring Security (in identity service: JWT issuance + verification)
  - Spring Data Redis (in discovery service)
  - Lombok (reduce boilerplate)
  - MapStruct (DTO ↔ domain mapping)
  - SpringDoc OpenAPI (auto-generated Swagger UI at `/swagger-ui.html`)
- **Testing:** JUnit 5 + Mockito + Testcontainers (where useful)
- **Container:** Each service has a `Dockerfile` (multi-stage Java build)
- **Orchestration:** Top-level `docker-compose.yml` brings up infrastructure (NOT the services themselves — services are run via `mvn spring-boot:run` during development so the professor can see logs cleanly)

---

## Repository Layout

Build this exact tree at the working directory root:

```
youscout-backend/
├── README.md                          # Run instructions + architecture map + cURL examples
├── docker-compose.yml                 # Postgres, Redis, Kafka, MinIO
├── ARCHITECTURE.md                    # Maps every code element to its ADR
├── shared-events/                     # Shared event schema library (versioned)
│   ├── pom.xml
│   └── src/main/java/com/youscout/events/
│       ├── VideoUploadedEvent.java
│       ├── VideoPublishedEvent.java
│       ├── UserFollowedEvent.java
│       └── EventEnvelope.java         # Wraps every event with correlation ID + version
├── identity-profile-service/
│   ├── pom.xml
│   ├── Dockerfile
│   ├── mvnw
│   ├── mvnw.cmd
│   └── src/main/java/com/youscout/identity/
│       ├── IdentityProfileApplication.java
│       ├── domain/                    # ── HEXAGONAL CORE — no framework imports ──
│       │   ├── model/
│       │   │   ├── User.java
│       │   │   ├── UserId.java
│       │   │   ├── Email.java
│       │   │   └── PasswordHash.java
│       │   ├── port/
│       │   │   ├── in/                # Inbound ports (use cases)
│       │   │   │   ├── RegisterUserUseCase.java
│       │   │   │   ├── AuthenticateUserUseCase.java
│       │   │   │   └── GetProfileUseCase.java
│       │   │   └── out/               # Outbound ports (driven adapters)
│       │   │       ├── UserRepository.java
│       │   │       └── PasswordHasher.java
│       │   └── service/               # Application services orchestrate use cases
│       │       ├── RegisterUserService.java
│       │       ├── AuthenticateUserService.java
│       │       └── GetProfileService.java
│       └── adapter/                   # ── ADAPTERS — framework lives here ──
│           ├── in/
│           │   └── web/
│           │       ├── UserController.java
│           │       ├── dto/
│           │       │   ├── RegisterRequest.java
│           │       │   ├── LoginRequest.java
│           │       │   ├── AuthResponse.java
│           │       │   └── UserDto.java
│           │       └── mapper/UserWebMapper.java
│           └── out/
│               ├── persistence/
│               │   ├── UserJpaEntity.java
│               │   ├── UserJpaRepository.java
│               │   ├── UserPersistenceAdapter.java
│               │   └── mapper/UserPersistenceMapper.java
│               └── security/
│                   ├── BCryptPasswordHasherAdapter.java
│                   ├── JwtTokenProvider.java
│                   └── SecurityConfig.java
├── content-service/
│   ├── pom.xml
│   ├── Dockerfile
│   ├── mvnw
│   ├── mvnw.cmd
│   └── src/main/java/com/youscout/content/
│       ├── ContentApplication.java
│       ├── domain/
│       │   ├── model/
│       │   │   ├── Video.java
│       │   │   ├── VideoId.java
│       │   │   ├── VideoStatus.java        # enum: UPLOADING, PUBLISHED, DELETED
│       │   │   ├── Skill.java
│       │   │   └── SkillTaxonomyVersion.java
│       │   ├── port/
│       │   │   ├── in/
│       │   │   │   ├── PublishVideoUseCase.java
│       │   │   │   ├── DeleteVideoUseCase.java
│       │   │   │   ├── TagVideoUseCase.java
│       │   │   │   └── GetVideoUseCase.java
│       │   │   └── out/
│       │   │       ├── VideoRepository.java
│       │   │       ├── MediaStore.java               # S3-like blob store
│       │   │       ├── EventPublisher.java
│       │   │       └── SkillTaxonomyProvider.java
│       │   └── service/
│       │       ├── PublishVideoService.java
│       │       ├── DeleteVideoService.java
│       │       ├── TagVideoService.java
│       │       └── GetVideoService.java
│       └── adapter/
│           ├── in/
│           │   └── web/
│           │       ├── VideoController.java
│           │       ├── dto/
│           │       │   ├── PublishVideoRequest.java
│           │       │   ├── VideoDto.java
│           │       │   └── TagVideoRequest.java
│           │       └── mapper/VideoWebMapper.java
│           └── out/
│               ├── persistence/
│               │   ├── VideoJpaEntity.java
│               │   ├── VideoJpaRepository.java
│               │   ├── VideoPersistenceAdapter.java
│               │   └── mapper/VideoPersistenceMapper.java
│               ├── storage/
│               │   └── MinioMediaStoreAdapter.java       # implements MediaStore port
│               ├── messaging/
│               │   └── KafkaEventPublisherAdapter.java   # implements EventPublisher port
│               └── taxonomy/
│                   └── InMemorySkillTaxonomyAdapter.java # static taxonomy for MVP
└── discovery-service/
    ├── pom.xml
    ├── Dockerfile
    ├── mvnw
    ├── mvnw.cmd
    └── src/main/java/com/youscout/discovery/
        ├── DiscoveryApplication.java
        ├── domain/
        │   ├── model/
        │   │   ├── FeedItem.java
        │   │   ├── FeedTimeline.java          # Aggregate: ordered list per user
        │   │   └── UserId.java
        │   ├── port/
        │   │   ├── in/
        │   │   │   ├── GetFeedUseCase.java
        │   │   │   └── ProjectEventUseCase.java   # Inbound port for event consumers
        │   │   └── out/
        │   │       └── FeedReadStore.java
        │   └── service/
        │       ├── GetFeedService.java
        │       └── ProjectEventService.java       # The CQRS projection logic
        └── adapter/
            ├── in/
            │   ├── web/
            │   │   ├── FeedController.java
            │   │   └── dto/FeedItemDto.java
            │   └── messaging/
            │       ├── VideoPublishedConsumer.java
            │       └── UserFollowedConsumer.java
            └── out/
                └── persistence/
                    └── RedisFeedReadStoreAdapter.java   # implements FeedReadStore port
```

Every service follows the **exact same hexagonal layout**: `domain/{model,port/in,port/out,service}` + `adapter/{in/web, in/messaging, out/persistence, out/storage, out/messaging, ...}`. **The domain package has zero imports from Spring, JPA, Kafka, Jackson, or any framework. Only inbound and outbound adapters import frameworks.** This is the SOLID DIP rule enforced architecturally. If you find yourself importing `org.springframework.*` inside `domain/`, you are doing it wrong — refactor.

---

## Architectural Patterns to Demonstrate (Each Must Be Visible in Code)

### 1. Hexagonal Architecture (ADR-002)
- **Domain core has no framework dependencies.** Pure Java. POJOs, value objects, domain services.
- **Inbound ports are interfaces** that describe what the service does — `PublishVideoUseCase`, `GetFeedUseCase`. They live in `domain/port/in/`.
- **Outbound ports are interfaces** that describe what the service needs — `VideoRepository`, `MediaStore`, `EventPublisher`. They live in `domain/port/out/`.
- **Application services** in `domain/service/` implement the inbound ports and orchestrate calls to outbound ports.
- **Adapters** implement outbound ports OR invoke inbound ports. They live in `adapter/`. Adapters import frameworks freely.
- **Dependency direction is always inward.** Adapters → ports → domain. Never the reverse.

### 2. SOLID — All Five (DP-03)
- **SRP:** Every class has one reason to change. The `UserController` only handles HTTP. The `UserPersistenceAdapter` only handles JPA. The `RegisterUserService` only orchestrates user registration.
- **OCP:** New skills can be added to the taxonomy without modifying core video logic. New event types can be added without modifying existing consumers (each consumer handles its own event type).
- **LSP:** Any implementation of `VideoRepository` (JPA, in-memory, mock) must be substitutable without breaking the domain service. Tests use in-memory implementations.
- **ISP:** Ports are small and role-specific. `PasswordHasher` has only `hash` and `verify`. `MediaStore` has only `store`, `retrieve`, `delete`. No fat interfaces.
- **DIP:** **The most important.** Domain services depend on port interfaces (abstractions), never on concrete adapters. Adapters depend on the domain. Spring's constructor injection wires concrete adapters into domain services at runtime — but the *compile-time* dependency direction is always inward.

### 3. CQRS (ADR-003)
- **Content Service is write-side.** It owns the source of truth (PostgreSQL). It publishes events when state changes.
- **Discovery Service is read-side.** It owns NO source data. It consumes events from Kafka, projects them into a Redis read model, and serves feed queries from that read model.
- A user posting a video triggers: `Content writes to Postgres → Content publishes VideoPublishedEvent to Kafka → Discovery consumes the event → Discovery updates the user's followers' feed timelines in Redis → Followers can now GET /feed and see the new video.`
- **This entire flow must work end-to-end in the MVP.** It is the architectural climax of the demo.

### 4. Event-Driven Integration (ADR-001 + AD-02)
- **All inter-service communication is async via Kafka.** No service calls another service synchronously. Period.
- Events have a versioned schema (in the `shared-events` Maven module) and are wrapped in an `EventEnvelope` that includes: `eventId` (UUID), `correlationId` (UUID), `eventType` (string), `version` (semver), `occurredAt` (ISO-8601 UTC), `payload` (the event-specific data).
- Topics: `youscout.video.events`, `youscout.user.events`.
- Partition key: `userId` for user-scoped events, `videoId` for video-scoped events.
- Consumers are **idempotent** — receiving the same event twice produces the same result.

### 5. Architecture Decisions Visible in Code (Phase 3 §6)
- **AD-01 Data ownership:** Each service has its own database connection string in `application.yml`. No cross-service DB access. Discovery has Redis ONLY (no Postgres) — it physically cannot read Content's data except via events.
- **AD-02 Async by default:** No `RestTemplate` or `WebClient` between services. Only Kafka.
- **AD-03 Idempotency + correlation IDs:** Every write endpoint accepts an optional `Idempotency-Key` header. Every event carries a `correlationId`.
- **AD-04 Actuator endpoints:** Every service exposes `/actuator/health`, `/actuator/info`, `/actuator/prometheus`.
- **AD-05 Hexagonal:** Already covered.
- **AD-08 Versioned events:** Event schemas are versioned. The `EventEnvelope.version` field carries semver. Consumers handle their own version evolution (for MVP, version `1.0.0` is fine across the board).

### 6. Design Patterns from the Course (Sessions 9-11)
Visibly use at least these GoF / enterprise patterns and add code comments noting which pattern is used:
- **Strategy** (e.g., `PasswordHasher` interface with `BCryptPasswordHasherAdapter` — easy to swap)
- **Adapter** (literally every adapter class — this is the Adapter pattern from GoF made architectural)
- **Factory** (factory methods for creating domain objects, e.g., `User.register(...)`, `Video.upload(...)`)
- **DTO** (web layer DTOs separate from domain models — MapStruct handles conversion)
- **Repository** (the outbound ports `UserRepository`, `VideoRepository` ARE the Repository pattern by Evans)
- **Domain Event** (the events published by Content are Domain Events in Evans' sense)
- **CQRS** (already covered)

Add `// PATTERN: Strategy` or `// PATTERN: Adapter` style comments above relevant class declarations so the professor can spot them during code review.

---

## Configuration & Environment

### docker-compose.yml (at root)

Provide all infrastructure on standard ports:

- Postgres → `localhost:5432`, user `youscout` / password `youscout`, with init script creating two databases: `identity_db` and `content_db`
- Redis → `localhost:6379`, no password
- Kafka → `localhost:9092` (KRaft single-broker, no Zookeeper), with auto-create-topics enabled
- MinIO → `localhost:9000` (API) and `localhost:9001` (web console), user `minioadmin` / password `minioadmin`, with bucket `youscout-videos` pre-created via an init container

Use named volumes for persistence. Use `healthcheck` blocks so services wait for dependencies properly when used.

### Per-Service Configuration (`application.yml`)

Each service has its own `application.yml`:

- **identity-profile-service** → port `8081`
  - JWT secret: `youscout-mvp-dev-secret-not-for-production` (configurable via env)
  - JWT expiry: 1 hour
  - Postgres URL: `jdbc:postgresql://localhost:5432/identity_db`
  - No Kafka usage in MVP (could be added later — Identity does not publish events in the MVP since Profile updates aren't critical to the demo flow)
- **content-service** → port `8082`
  - Postgres URL: `jdbc:postgresql://localhost:5432/content_db`
  - MinIO endpoint: `http://localhost:9000`, bucket: `youscout-videos`
  - Kafka bootstrap: `localhost:9092`
  - Produces topic: `youscout.video.events`
- **discovery-service** → port `8083`
  - Redis: `localhost:6379`
  - Kafka bootstrap: `localhost:9092`
  - Consumes topics: `youscout.video.events`, `youscout.user.events`
  - Consumer group: `discovery-service`

All sensitive values come from env vars with sensible defaults for local development.

---

## REST Endpoints (Minimum Set for the Demo)

### identity-profile-service (port 8081)
- `POST /api/v1/auth/register` — body `{email, password, displayName}` → returns user + JWT
- `POST /api/v1/auth/login` — body `{email, password}` → returns JWT
- `GET /api/v1/profile/me` — header `Authorization: Bearer <jwt>` → returns own profile
- `PUT /api/v1/profile/me` — update own profile (displayName, bio, position, foot, etc.)
- `GET /api/v1/users/{userId}` — get any user's public profile

### content-service (port 8082)
- `POST /api/v1/videos` — multipart upload: video file + `{description, hashtags, skills[]}` → uploads to MinIO, persists metadata, publishes `VideoPublishedEvent`, returns video DTO. **JWT-protected.**
- `GET /api/v1/videos/{videoId}` — get video metadata
- `DELETE /api/v1/videos/{videoId}` — soft-delete (status → DELETED), publishes `VideoDeletedEvent`. **JWT-protected.**
- `GET /api/v1/videos/{videoId}/stream` — returns a presigned MinIO URL for streaming (5-minute TTL)
- `GET /api/v1/skills` — list available skills from the in-memory taxonomy

### discovery-service (port 8083)
- `GET /api/v1/feed` — header `Authorization: Bearer <jwt>` → returns the authenticated user's feed (list of feed items with video metadata). Reads from Redis. **JWT-protected.**
- `POST /api/v1/internal/follow` — body `{followerId, followeeId}` — for testing; publishes `UserFollowedEvent` (in real architecture, this would come from a Social service, but for MVP we add a minimal endpoint here to trigger the event so the demo works)

All endpoints documented automatically via SpringDoc OpenAPI at `/swagger-ui.html` per service.

---

## JWT — How It Works Across Services

- Identity issues JWTs signed with HMAC-SHA256 using the shared secret.
- Other services have Spring Security configured to verify the JWT using the same secret.
- The JWT payload contains: `sub` (userId UUID), `email`, `iat`, `exp`.
- Protected endpoints extract the `userId` from the JWT principal and authorize accordingly.
- For MVP, the shared secret is in environment variables — same value in all three services.

---

## The End-to-End Demo Flow

The professor will run this flow during the defense. The README must explain it clearly.

```
1. docker-compose up -d
   (waits for infrastructure to come up — show health endpoints)

2. Start the 3 services in 3 separate terminals:
   cd identity-profile-service && ./mvnw spring-boot:run
   cd content-service && ./mvnw spring-boot:run
   cd discovery-service && ./mvnw spring-boot:run

3. Register two users (Alice and Bob):
   curl -X POST http://localhost:8081/api/v1/auth/register \
     -H "Content-Type: application/json" \
     -d '{"email":"alice@youscout.dev","password":"password123","displayName":"Alice"}'
   # → returns JWT_ALICE

   curl -X POST http://localhost:8081/api/v1/auth/register \
     -H "Content-Type: application/json" \
     -d '{"email":"bob@youscout.dev","password":"password123","displayName":"Bob"}'
   # → returns JWT_BOB + userId_BOB

4. Alice follows Bob (triggers UserFollowedEvent → consumed by Discovery):
   curl -X POST http://localhost:8083/api/v1/internal/follow \
     -H "Content-Type: application/json" \
     -d '{"followerId":"<alice_uuid>","followeeId":"<bob_uuid>"}'

5. Bob uploads a video (triggers VideoPublishedEvent → consumed by Discovery):
   curl -X POST http://localhost:8082/api/v1/videos \
     -H "Authorization: Bearer $JWT_BOB" \
     -F "file=@sample.mp4" \
     -F "description=Look at this skill move!" \
     -F "skills=dribbling,vision"

6. Alice fetches her feed (reads from Redis projection):
   curl http://localhost:8083/api/v1/feed \
     -H "Authorization: Bearer $JWT_ALICE"
   # → returns list containing Bob's video
```

**This single flow exercises every architectural decision in the report.** The professor can see auth, hexagonal services, event publishing, Kafka in action, CQRS projection, JWT cross-service auth, and the database-per-service rule. Everything that matters, in 6 cURL commands.

---

## Testing

Provide minimum but visible test coverage:

- **Unit tests in `domain/service/`** — test application services with mocked outbound ports. These run in milliseconds and prove the hexagonal isolation.
- **One integration test per service** — uses Testcontainers to spin up Postgres or Redis or Kafka as appropriate, hits an endpoint, asserts the result.
- Tests do not need to be comprehensive. They need to **demonstrate that the architecture is testable** — which is the SOLID/Hexagonal payoff.

---

## README.md Contents

The README is what the professor will read first. It must contain:

1. **Project overview** — one paragraph: "MVP backend for YouScout. Three Spring Boot microservices demonstrating Hexagonal Architecture, SOLID, CQRS, Event-Driven communication via Kafka."
2. **Architecture map** — table mapping services to bounded contexts, with a small ASCII diagram showing service ↔ Kafka ↔ service flow.
3. **Prerequisites** — Java 21, Docker, Docker Compose, Maven (or use included wrapper).
4. **Run instructions** — exact commands from §"End-to-End Demo Flow" above.
5. **API documentation** — links to each service's Swagger UI.
6. **Architectural patterns demonstrated** — bullet list mapping code locations to patterns:
   - "Hexagonal: see `*/domain/` and `*/adapter/` packages"
   - "CQRS: Content (write) → Kafka → Discovery (read projection in Redis)"
   - "SOLID DIP: domain services depend on port interfaces, not adapters"
   - etc.
7. **ADR mapping** — table mapping ADR-001 through ADR-010 to where each shows up in the code.
8. **Limitations of the MVP** — honest statement of what's not built and why (3 services not 6, no real video transcoding, single Kafka broker, etc.).
9. **Cleanup** — `docker-compose down -v` to wipe everything.

---

## ARCHITECTURE.md Contents

Separate from the README, this file is for the professor's deeper inspection. Contains:

1. **The hexagonal pattern, explained with a code snippet** from `RegisterUserService` showing: service constructor takes port interfaces, methods orchestrate calls to ports, no framework imports.
2. **The CQRS flow, explained with code snippets** from `KafkaEventPublisherAdapter` (write side) and `VideoPublishedConsumer` + `ProjectEventService` (read side).
3. **The SOLID checklist** — for each principle, point to a specific class that demonstrates it.
4. **A note on what production would add** — service mesh, distributed tracing, schema registry for Kafka, etc. Honest acknowledgment that MVP simplifies these.

---

## Critical Build Rules

These are non-negotiable for the build to be defense-quality:

1. **Do not import any framework class inside `domain/` packages.** Compile-fail before letting Spring leak into the domain. If you need framework features (e.g., `@Transactional`), put them on the **adapter** classes or on **application service** classes that orchestrate use cases — but the domain models and ports stay pure Java.

2. **Every controller method must delegate to an inbound port (use case interface), not contain business logic itself.** Controllers translate HTTP ↔ DTO ↔ port input. That's it.

3. **Every JPA entity is separate from the domain model.** `UserJpaEntity` is annotated with `@Entity`. `User` is a domain model with no JPA annotations. `UserPersistenceMapper` (MapStruct) converts between them.

4. **No `@Autowired` field injection.** Use constructor injection everywhere (Lombok's `@RequiredArgsConstructor` is fine).

5. **No business logic in adapters.** Adapters are mechanical translation. All decisions, validation, and state changes happen in the domain.

6. **Add `// PATTERN: <pattern-name>` comments** at every place where a recognizable design pattern is used.

7. **Every service compiles, runs, and passes its tests.** Before declaring "done," verify with `./mvnw clean verify` in each service.

8. **One docker-compose up brings up all infrastructure.** No manual steps to create databases, buckets, or topics. Init containers handle them.

9. **The end-to-end demo flow (6 cURL commands) must work.** This is the acceptance test for the build.

---

## What to Skip (Out of MVP Scope — Do NOT Build)

- Real video transcoding (we store the raw file in MinIO; the professor understands AWS MediaConvert would do this in production)
- API Gateway / BFF (mobile client talks to services directly for the MVP)
- Social/Engagement service (likes, comments, ratings)
- Communication service (messaging, notifications)
- Moderation service
- Talent Scoring service
- Search index (Elasticsearch)
- Kubernetes manifests (we explain in the slides how this would deploy to EKS; we don't build the manifests in the MVP)
- Monitoring stack (Prometheus/Grafana/Loki — we expose `/actuator/prometheus` and stop there)
- OAuth2/OIDC federated providers (Google, Facebook) — username/password is sufficient for MVP
- Multi-region deployment
- GDPR right-to-erasure flow
- Parental consent flow

If you start building any of these, stop and finish the core scope first. Scope discipline is part of what's being graded.

---

## Execution Plan — Do This in Order

Build the project in this order. Verify each step works before moving on.

1. **Project skeleton** — root directory, README stubs, docker-compose.yml, shared-events module, three service directories with `pom.xml` and Maven wrappers. Verify `docker-compose up -d` brings up Postgres, Redis, Kafka, MinIO and they all pass healthchecks.

2. **shared-events module** — `EventEnvelope`, `VideoPublishedEvent`, `VideoDeletedEvent`, `UserFollowedEvent`. Pure Java POJOs + Jackson annotations. Built as a Maven dependency that the other services consume.

3. **identity-profile-service** — full hexagonal layout, JPA persistence, JWT issuance, BCrypt password hashing. Endpoints: register, login, get profile, update profile. Verify with cURL.

4. **content-service** — full hexagonal layout, JPA for metadata, MinIO for blob storage, Kafka producer for events. Endpoints: upload video, get video, delete video, list skills. Verify event publishing with `kafka-console-consumer`.

5. **discovery-service** — full hexagonal layout, Redis for feed projection, Kafka consumers for VideoPublishedEvent and UserFollowedEvent. Implements the CQRS read side. Endpoint: get feed. Verify by running the full demo flow.

6. **README.md and ARCHITECTURE.md** — populate fully.

7. **Final smoke test** — run the 6 cURL commands end-to-end. Confirm Alice sees Bob's video in her feed.

---

## Stop Conditions

Stop and ask me before continuing if:
- A dependency conflict requires changing the technology stack (e.g., a Spring Boot version incompatibility).
- The scope appears to require more than ~6 hours of model time to complete — propose a smaller scope.
- A pattern decision is ambiguous (e.g., where exactly to put validation).

Otherwise, proceed end to end. Do not stop to ask trivial questions. Make sensible choices and document them in ARCHITECTURE.md.

---

## Begin

Start by creating the directory structure and the `docker-compose.yml`. Verify infrastructure comes up. Then build the shared-events module, then identity-profile-service, then content-service, then discovery-service, then documentation. Run the end-to-end demo flow as the final verification.

When complete, report:
- ✅ Files created (top-level summary)
- ✅ Infrastructure verified (containers running)
- ✅ Services built and tested (`mvn clean verify` results)
- ✅ End-to-end demo flow verified (the 6 cURL commands worked)
- 📋 Any deviations from this spec and why
- 📋 Known limitations or TODOs

# ═══════════════════════════════════════════════════════════════════
#                  END OF PROMPT
# ═══════════════════════════════════════════════════════════════════
