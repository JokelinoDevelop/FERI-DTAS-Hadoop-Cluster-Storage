#!/bin/bash

# === CONFIGURATION ===
HDFS_DIR="/mydata"
LOCAL_FOLDER="/data"
LOCAL_FOLDER_NAME=$(basename "$LOCAL_FOLDER")
HDFS_FOLDER="$HDFS_DIR/$LOCAL_FOLDER_NAME"

echo "=== Checking if HDFS is running ==="
hdfs dfsadmin -report > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "ERROR: HDFS is not running. Start your Hadoop cluster first."
    exit 1
fi

if [ ! -d "$LOCAL_FOLDER" ]; then
    echo "ERROR: Local folder $LOCAL_FOLDER does not exist inside the container."
    echo "       Make sure your docker-compose mount is configured correctly."
    exit 1
fi

echo "=== Creating HDFS target directory ==="
hdfs dfs -mkdir -p "$HDFS_DIR"

echo "=== Uploading folder to HDFS ==="
hdfs dfs -put -f "$LOCAL_FOLDER" "$HDFS_DIR/"
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to upload $LOCAL_FOLDER to HDFS."
    exit 1
fi

echo "=== Listing HDFS directory structure ==="
hdfs dfs -ls "$HDFS_DIR"
hdfs dfs -ls "$HDFS_FOLDER"

SAMPLE_LOCAL_FILE=$(find "$LOCAL_FOLDER" -maxdepth 1 -type f | head -n 1)
if [ -n "$SAMPLE_LOCAL_FILE" ]; then
    SAMPLE_FILENAME=$(basename "$SAMPLE_LOCAL_FILE")
    SAMPLE_HDFS_PATH="$HDFS_FOLDER/$SAMPLE_FILENAME"

    echo "=== Reading sample file from HDFS: $SAMPLE_FILENAME ==="

    hdfs dfs -cat "$SAMPLE_HDFS_PATH" 

    echo "=== First 5 lines ==="
    hdfs dfs -cat "$SAMPLE_HDFS_PATH" | head -n 5

    echo "--- Last 10 lines ---"
    hdfs dfs -cat "$SAMPLE_HDFS_PATH" | tail -n 10

    echo "=== Printing disk usage for sample file ==="
    hdfs dfs -du -h "$SAMPLE_HDFS_PATH"
else
    echo "NOTE: No regular files found in $LOCAL_FOLDER to preview."
fi

echo "=== Checking block size and replication ==="
echo "Block size:"
hdfs getconf -confKey dfs.blocksize

echo "Replication factor:"
hdfs getconf -confKey dfs.replication

echo "=== Cluster report ==="
hdfs dfsadmin -report

echo "=== DONE ==="