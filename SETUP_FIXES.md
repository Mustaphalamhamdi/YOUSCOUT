# YouScout — Setup Fixes & Run Guide

> Documents every problem hit during first-run setup and the exact fix applied.
> Environment: Windows 11 + Docker Desktop (WSL2 backend) + Java 21 + Maven 3.9

---

## How to Run (Quick Reference)

### Step 1 — Start infrastructure
```bash
docker compose up -d
```
Wait ~30 seconds, then verify:
```bash
docker compose ps
```
All 4 containers should show **healthy**: `youscout-postgres`, `youscout-redis`, `youscout-kafka`, `youscout-minio`.

### Step 2 — Build all services
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

### Step 4 — Open Swagger UI
| Service | URL |
|---|---|
| Identity & Profile | http://localhost:8081/swagger-ui/index.html |
| Content | http://localhost:8082/swagger-ui/index.html |
| Discovery | http://localhost:8083/swagger-ui/index.html |

> **Note:** Use `/swagger-ui/index.html` not `/swagger-ui.html` — see Fix #6 below.

---

## Where Commands Run

| Environment | What runs there |
|---|---|
| **WSL2 (Ubuntu)** | All `mvn`, `docker`, `curl`, `ps`, `kill` commands — this is where Claude Code's bash tool executes |
| **Windows native** | The actual Spring Boot JVMs (`java.exe`) — Maven launches them as native Windows child processes |
| **Docker (inside WSL2)** | All 4 infrastructure containers (Postgres, Redis, Kafka, MinIO) |

> Important: killing a Maven process from WSL2 does not always kill its forked Windows JVM child. If a port stays occupied after stopping a service, open **Task Manager → Details** and kill `java.exe` manually.

---

## Fixes Applied

### Fix 1 — Kafka image removed from Docker Hub

**File:** `docker-compose.yml`

**Problem:** `bitnami/kafka:3.6` (and all `bitnami/*` images) were removed from Docker Hub by Broadcom/VMware. Docker pulled nothing and the entire `docker compose up` failed.

**Fix:** Replaced with the official Apache Kafka image. The env var prefix changed from `KAFKA_CFG_*` (Bitnami convention) to `KAFKA_*` (Apache convention), and the volume mount path changed.

```yaml
# Before
image: bitnami/kafka:3.6
environment:
  - KAFKA_CFG_NODE_ID=0
  - KAFKA_CFG_PROCESS_ROLES=controller,broker
  - KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093
  - KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092
  - KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
  - KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@kafka:9093
  - KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER
  - KAFKA_CFG_AUTO_CREATE_TOPICS_ENABLE=true
  - KAFKA_CFG_OFFSETS_TOPIC_REPLICATION_FACTOR=1
volumes:
  - kafka_data:/bitnami/kafka

# After
image: apache/kafka:3.7.1
environment:
  KAFKA_NODE_ID: 0
  KAFKA_PROCESS_ROLES: broker,controller
  KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093
  KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
  KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT
  KAFKA_CONTROLLER_QUORUM_VOTERS: 0@kafka:9093
  KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
  KAFKA_AUTO_CREATE_TOPICS_ENABLE: "true"
  KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
volumes:
  - kafka_data:/var/lib/kafka/data
```

---

### Fix 2 — `var` type inference failure in VideoPublishedConsumer

**File:** `discovery-service/src/main/java/com/youscout/discovery/adapter/in/messaging/VideoPublishedConsumer.java`

**Problem:** `objectMapper.convertValue(x, JavaType)` returns a raw `Object` from Java's type inference perspective when used with `var`. So `envelope` was typed as `Object` and calling `.getEventType()` / `.getPayload()` on it was a compile error.

```
[ERROR] cannot find symbol
  symbol:   method getEventType()
  location: variable envelope of type java.lang.Object
```

**Fix:** Replace `var` with an explicit generic type.

```java
// Before
var envelope = objectMapper.convertValue(rawEnvelope,
        objectMapper.getTypeFactory().constructParametricType(EventEnvelope.class, Map.class));

// After
EventEnvelope<Map<String, Object>> envelope = objectMapper.convertValue(rawEnvelope,
        objectMapper.getTypeFactory().constructParametricType(EventEnvelope.class, Map.class));
```

---

### Fix 3 — Missing `videoPublishedFilter` bean

**File:** `discovery-service/src/main/java/com/youscout/discovery/adapter/in/messaging/VideoPublishedConsumer.java`

**Problem:** The `@KafkaListener` annotation referenced `filter = "videoPublishedFilter"` but no Spring bean with that name was defined anywhere in the project. Application failed to start.

```
No bean named 'videoPublishedFilter' available
```

**Fix:** Remove the `filter` attribute. The consumer already filters manually with an `if` check inside the method body, so the filter bean was redundant.

```java
// Before
@KafkaListener(topics = "youscout.video.events", groupId = "discovery-service",
        filter = "videoPublishedFilter")

// After
@KafkaListener(topics = "youscout.video.events", groupId = "discovery-service")
```

---

### Fix 4 — Services connecting to the wrong PostgreSQL

**Files:** `docker-compose.yml`, `identity-profile-service/src/main/resources/application.yml`, `content-service/src/main/resources/application.yml`

**Problem:** A local PostgreSQL installation on Windows was already bound to port `5432`. The Spring Boot services (running as native Windows processes) connected to that local instance instead of the Docker one, getting:

```
FATAL: password authentication failed for user "youscout"
```

The Docker containers themselves could reach the Docker PostgreSQL fine (different network path), which made this hard to spot.

**Fix:** Remap Docker's PostgreSQL to an unused port (`5433`) and update the JDBC URL defaults.

```yaml
# docker-compose.yml — before
ports:
  - '5432:5432'

# docker-compose.yml — after
ports:
  - '5433:5432'
```

```yaml
# application.yml (identity-profile-service) — before
url: ${DB_URL:jdbc:postgresql://localhost:5432/identity_db}

# after
url: ${DB_URL:jdbc:postgresql://localhost:5433/identity_db}
```

```yaml
# application.yml (content-service) — before
url: ${DB_URL:jdbc:postgresql://localhost:5432/content_db}

# after
url: ${DB_URL:jdbc:postgresql://localhost:5433/content_db}
```

---

### Fix 5 — Missing Hibernate dialect in content-service

**File:** `content-service/src/main/resources/application.yml`

**Problem:** `content-service` had no `hibernate.dialect` set. With Hibernate 6.5.2, a failed DB connection during startup causes a NullPointerException inside Hibernate's isolation delegate (a known bug in that version), which then surfaces as the misleading error:

```
Unable to determine Dialect without JDBC metadata
```

`identity-profile-service` already had the dialect set and didn't hit this confusing error path.

**Fix:** Add the dialect explicitly.

```yaml
# Before
jpa:
  hibernate:
    ddl-auto: update
  show-sql: false

# After
jpa:
  hibernate:
    ddl-auto: update
  show-sql: false
  properties:
    hibernate:
      dialect: org.hibernate.dialect.PostgreSQLDialect
```

---

### Fix 6 — Swagger UI returning HTTP 403

**Files:** `*/adapter/out/security/*SecurityConfig.java` (all 3 services)

**Problem:** All security configs had `"/swagger-ui/**"` in `permitAll()`. SpringDoc is configured with `springdoc.swagger-ui.path: /swagger-ui.html`, which means the browser first hits `/swagger-ui.html`. That path does **not** match the `"/swagger-ui/**"` pattern (it's a file at root, not under the directory), so Spring Security blocked it with 403 before SpringDoc's redirect could fire.

**Fix:** Add `/swagger-ui.html` explicitly to the permitted matchers.

```java
// Before
.requestMatchers("/api/v1/auth/**", "/swagger-ui/**", "/v3/api-docs/**", "/actuator/**")

// After
.requestMatchers("/api/v1/auth/**", "/swagger-ui.html", "/swagger-ui/**", "/v3/api-docs/**", "/actuator/**")
```

> **Workaround (no restart needed):** Access `/swagger-ui/index.html` directly — that path already matched `/swagger-ui/**` and returns 200 on the currently running services.

---

## Infrastructure Port Reference

| Service | Host Port | Notes |
|---|---|---|
| PostgreSQL | **5433** | Changed from default 5432 to avoid conflict with local Windows install |
| Redis | 6379 | Default |
| Kafka | 9092 | KRaft mode, no ZooKeeper |
| MinIO API | 9000 | S3-compatible |
| MinIO Console | 9001 | Web UI |
| Identity Service | 8081 | |
| Content Service | 8082 | |
| Discovery Service | 8083 | |
