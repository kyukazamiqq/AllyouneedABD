#!/bin/bash

DOCKER_COMPOSE_FILE="docker-compose-spark3.0.2.yml"
SCRIPT_PATH=$(cd `dirname $0`; pwd)

# Gunakan tanda kutip double (") untuk membungkus path file
COMPOSE_CMD="docker compose -f \"${SCRIPT_PATH}/${DOCKER_COMPOSE_FILE}\""

echo "Menghentikan kontainer lama..."
eval $COMPOSE_CMD down

echo "Menarik image terbaru..."
eval $COMPOSE_CMD pull
sleep 5

echo "Menjalankan kontainer..."
eval $COMPOSE_CMD up -d
sleep 15

# Menjalankan perintah di dalam kontainer
echo "Konfigurasi HDFS dan Spark..."
docker exec -it namenode hdfs dfs -mkdir -p /user/spark/applicationHistory
docker cp "${SCRIPT_PATH}/scripts/spark-hive-site.xml" spark-master:/spark/conf/hive-site.xml
docker cp "${SCRIPT_PATH}/scripts/spark-defaults.conf" spark-master:/spark/conf/spark-defaults.conf

# Menjalankan History Server
docker exec -d spark-master /spark/bin/spark-class org.apache.spark.deploy.history.HistoryServer

echo "Selesai!"