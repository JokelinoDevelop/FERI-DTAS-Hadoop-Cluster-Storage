#!/bin/bash
if [ ! -f /tmp/hadoop-hadoop/dfs/name/current/VERSION ]; then
    echo "NameNode not formatted. Formatting now..."
    hdfs namenode -format -force
else
    echo "NameNode already formatted. Skipping format."
fi

# Start NameNode
exec hdfs namenode