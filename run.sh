#!/usr/bin/env bash
set -e
cd /root/task
echo "Starting docker containers..."
docker-compose up -d

# Wait for PostgreSQL
until docker exec utkrusht_postgres pg_isready -U utkrushtuser -d utkrushtdb ; do
    echo "Waiting for Postgres..."
    sleep 2
done

# Wait for FastAPI
ATTEMPTS=0
until curl -s http://localhost:8000/health >/dev/null; do
    ATTEMPTS=$((ATTEMPTS+1))
    if [ $ATTEMPTS -gt 20 ]; then
        echo "FastAPI did not start in time. Exiting."
        exit 1
    fi
    echo "Waiting for FastAPI..."
    sleep 2
done

echo "All services started! API at http://<DROPLET_IP>:8000"
