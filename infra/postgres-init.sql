-- Create the two databases used by Identity and Content services
CREATE DATABASE identity_db;
CREATE DATABASE content_db;

-- Grant privileges to the youscout user (already created via POSTGRES_USER)
GRANT ALL PRIVILEGES ON DATABASE identity_db TO youscout;
GRANT ALL PRIVILEGES ON DATABASE content_db TO youscout;