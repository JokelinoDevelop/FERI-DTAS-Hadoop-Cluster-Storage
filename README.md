# FERI-DTAS-Hadoop-Cluster-Storage

## Overview

- Local Hadoop cluster for the Data Technologies and Services course.
- Docker Compose spins up HDFS NameNode/DataNode
- Includes sample event dataset under `data/` and helper script `assignment.sh` for common jobs.
- The script init-namenode.sh is being run at the start of the namenode container to format the namenode if it has not been already formatted

## Prerequisites

- `docker` and `docker compose` installed and running.
- At least 8 GB RAM available for containers (adjust in `docker-compose.yml` if needed).

## Usage

- Start cluster: `docker compose up -d`
- Check container status: `docker compose ps`
- Submit sample job: `bash -lc tmp/assignment.sh` inside the namenode container
- Stop cluster: `docker compose down`

## Files

- `docker-compose.yml`: service definitions and shared volumes.
- `config/`: Hadoop XML configs mounted into containers.
- `data/`: datasets copied into HDFS on container startup.
- `assignment.sh`: helper script for formatting HDFS, copying data, and submitting MapReduce job.
