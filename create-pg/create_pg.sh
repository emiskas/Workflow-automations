#!/bin/bash
# Bash script to create a PostgreSQL database and user for Django

# Fail on error
set -e

# === CONFIG ===
DB_NAME=$1
DB_USER=$2
DB_PASS=$3

# check args
if [ $# -ne 3 ]; then
    echo "Usage: $0 <db_name> <db_user> <db_password>"
    exit 1
fi

# Install PostgreSQL if not installed
if ! command -v psql > /dev/null; then
    echo "PostgreSQL not found, installing..."
    apt update && apt install -y postgresql postgresql-contrib
fi

# Create DB + user
sudo -u postgres psql <<EOF
DO
\$do\$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = '${DB_USER}') THEN
      CREATE ROLE ${DB_USER} LOGIN PASSWORD '${DB_PASS}';
   END IF;
END
\$do\$;

CREATE DATABASE ${DB_NAME} OWNER ${DB_USER};
GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_USER};
EOF

echo "Database '${DB_NAME}' and user '${DB_USER}' created successfully."
