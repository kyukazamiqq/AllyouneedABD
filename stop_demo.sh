#!/bin/bash

# Configuration
DOCKER_COMPOSE_FILE="docker-compose-spark3.0.2.yml"
SCRIPT_PATH=$(cd "$(dirname "$0")"; pwd)

# Execute
echo "Shutting down Spark cluster..."
docker compose -f "${SCRIPT_PATH}/${DOCKER_COMPOSE_FILE}" down