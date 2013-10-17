#!/bin/bash

echo "Fixing hostname"
HOST=`hostname`
echo "127.0.0.1 $HOST" >> /etc/hosts

echo "ZOOKEEPER_IP=$ZOOKEEPER_IP"

echo "Fixing ZOOKEEPER_IP in server.properties"
sed -i "s/{{ZOOKEEPER_IP}}/${ZOOKEEPER_IP:-localhost}/g" /kafka/config/server.properties

echo "Starting kafka"
/kafka/bin/kafka-server-start.sh /kafka/config/server.properties > /logs/kafka.log 2>&1
