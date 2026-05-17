-- Creates both databases at PostgreSQL startup
-- Each service owns its own database (ADR-001: per-context data ownership)
CREATE DATABASE identity_db;
CREATE DATABASE content_db;

GRANT ALL PRIVILEGES ON DATABASE identity_db TO youscout;
GRANT ALL PRIVILEGES ON DATABASE content_db TO youscout;
