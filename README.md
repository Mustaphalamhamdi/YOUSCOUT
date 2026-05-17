# YOUSCOUT

## Useful Commands While Working

**Stop everything (keeps data):**

```bash
docker compose stop
```

**Start it back up:**

```bash
docker compose start
```

**Stop and remove containers (keeps data in volumes):**

```bash
docker compose down
```

**Nuke everything including data (for clean restart):**

```bash
docker compose down -v
```

**View logs for one service:**

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

**Watch Kafka events live (useful during the defense demo):**

```bash
docker exec -it youscout-kafka kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --topic youscout.video.events \
  --from-beginning
```

This last one is great for the defense — open it in a terminal window and the professor can see events flowing in real time when Bob uploads a video.

## Troubleshooting

**Port already in use (5432, 6379, 9092, 9000, 9001).**  
Something else is using one of those ports. Either stop that service, or change the port mapping in `docker-compose.yml` (e.g. `"5433:5432"` to expose Postgres on `5433` externally).

**Kafka keeps restarting.**  
Most common cause: not enough memory allocated to Docker. Open Docker Desktop → Settings → Resources → increase Memory to at least 4 GB. Then:

```bash
docker compose down && docker compose up -d
```

**MinIO bucket missing.**  
The `minio-init` container creates it. If it's missing, run:

```bash
docker compose run --rm minio-init
```

**"Cannot connect to the Docker daemon."**  
Docker Desktop isn't running. Start it.

**Postgres "database does not exist" later when services connect.**  
The init script only runs on the first startup with an empty volume. If you need to recreate the databases, nuke the volume:

```bash
docker compose down -v
docker compose up -d
```

**Apple Silicon (M1/M2/M3 Mac) image warnings.**  
Most of these images have native ARM64 builds and should work without changes. If Bitnami Kafka complains, add this under the `kafka` service in `docker-compose.yml`:

```yaml
platform: linux/amd64
```

This forces emulation but works reliably.

**Slow first start.**  
First run pulls images and Kafka takes ~30s to initialize KRaft mode. Subsequent starts are fast (~10s total).
