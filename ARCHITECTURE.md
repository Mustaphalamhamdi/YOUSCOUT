# YouScout — Architecture Reference

This document maps every code element to an architectural decision. Written for Dr. Driss ALLAKI, ISMAGI.

---

## 1. Hexagonal Architecture (ADR-002)

The pattern is visible in every service's package structure:

```
com.youscout.{service}/
├── domain/              ← Pure Java. Zero Spring/JPA/Kafka imports.
│   ├── model/           ← Entities and value objects
│   ├── port/
│   │   ├── in/          ← Inbound ports (use case interfaces)
│   │   └── out/         ← Outbound ports (driven adapter interfaces)
│   └── service/         ← Application services implement inbound ports
└── adapter/             ← Framework lives here only
    ├── in/
    │   ├── web/         ← Spring MVC controllers (HTTP → use case)
    │   └── messaging/   ← Kafka consumers (message → use case)
    └── out/
        ├── persistence/ ← JPA adapters (implement repository ports)
        ├── storage/     ← MinIO adapter (implements MediaStore port)
        ├── messaging/   ← Kafka producer (implements EventPublisher port)
        └── security/    ← JWT adapter (implements TokenIssuer port)
```

### Code Proof — RegisterUserService

```java
// domain/service/RegisterUserService.java
// Note: only domain and port imports — zero Spring framework imports in parameters/fields
@Service
@RequiredArgsConstructor
public class RegisterUserService implements RegisterUserUseCase {

    private final UserRepository userRepository;   // ← interface (domain port)
    private final PasswordHasher passwordHasher;   // ← interface (domain port)
    private final TokenIssuer tokenIssuer;         // ← interface (domain port)

    // Spring DI injects concrete adapters at runtime.
    // Compile-time dependency is to interfaces — this IS the Dependency Inversion Principle.
}
```

**DIP in action:** At compile time, `RegisterUserService` depends on `UserRepository` (interface). At runtime, Spring injects `UserPersistenceAdapter` (JPA implementation). Swapping PostgreSQL for MongoDB requires only replacing the adapter.

---

## 2. CQRS (ADR-003)

### Write Side — content-service

```
POST /api/v1/videos
  → VideoController (adapter/in/web)
  → PublishVideoUseCase (domain/port/in)
  → PublishVideoService (domain/service)
  → MediaStore.store() → MinioMediaStoreAdapter (MinIO)
  → VideoRepository.save() → VideoPersistenceAdapter (PostgreSQL)
  → EventPublisher.publishVideoPublished() → KafkaEventPublisherAdapter
      → Kafka topic: youscout.video.events
```

### Read Side — discovery-service

```
Kafka consumer: VideoPublishedConsumer (adapter/in/messaging)
  → ProjectEventUseCase (domain/port/in)
  → ProjectEventService (domain/service)
  → FeedReadStore.addToFeed() → RedisFeedReadStoreAdapter (Redis)

GET /api/v1/feed
  → FeedController (adapter/in/web)
  → GetFeedUseCase (domain/port/in)
  → GetFeedService (domain/service)
  → FeedReadStore.getFeed() → RedisFeedReadStoreAdapter
  ← Returns from Redis — NEVER queries content_db
```

**The Discovery service has zero database connections to PostgreSQL.** Its `application.yml` contains no JDBC URL. It physically cannot read Content's data except via events. This is AD-01 data ownership enforced at the infrastructure level.

---

## 3. SOLID Principles

| Principle | Class | How |
|---|---|---|
| **SRP** | `UserController` | Only handles HTTP ↔ DTO translation |
| **SRP** | `UserPersistenceAdapter` | Only handles JPA persistence |
| **SRP** | `RegisterUserService` | Only orchestrates user registration |
| **OCP** | `InMemorySkillTaxonomyAdapter` | New skills added here, domain untouched |
| **OCP** | Kafka consumers | New event types → new consumer class, existing untouched |
| **LSP** | All `*Repository` implementations | Substitutable for their port interface |
| **ISP** | `PasswordHasher` | Only `hash` + `verify` — nothing more |
| **ISP** | `MediaStore` | Only `store` + `presignedUrl` + `delete` |
| **DIP** | `RegisterUserService` | Depends on `UserRepository` interface, not `UserPersistenceAdapter` |

---

## 4. Design Patterns

| Pattern | File |
|---|---|
| Factory Method | `User.register(...)`, `Video.upload(...)` |
| Strategy | `PasswordHasher` + `BCryptPasswordHasherAdapter` |
| Adapter (GoF) | Every `*Adapter.java` in `adapter/out/` |
| Repository (Evans) | `UserRepository`, `VideoRepository`, `FeedReadStore` interfaces |
| Domain Event | `VideoPublishedEvent`, `UserFollowedEvent` in shared-events |
| DTO | `RegisterRequest`, `AuthResponse`, `UserDto` in `adapter/in/web/dto/` |
| CQRS | content-service (write) ↔ discovery-service (read projection) |

---

## 5. What Production Would Add

| Gap | Production Solution |
|---|---|
| Single JWT secret | JWK Set endpoint — each service fetches public key |
| Single Kafka broker | Confluent Cloud, 3 brokers, replication factor 3 |
| No schema registry | Confluent Schema Registry + Avro for event versioning |
| MinIO local | AWS S3 + CloudFront CDN |
| No distributed tracing | OpenTelemetry + Jaeger / Grafana Tempo |
| No API Gateway | Kong or AWS API Gateway |
| Manual DB schema | Flyway migrations, not `ddl-auto: update` |
| Kubernetes | Helm charts on AWS EKS, HPA for auto-scaling |
