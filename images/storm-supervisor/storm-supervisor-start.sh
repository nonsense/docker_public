#!/bin/bash


HOST=`hostname`
echo "127.0.0.1 $HOST" >> /etc/hosts

echo "ZOOKEEPER_IP=$ZOOKEEPER_IP"

echo "Fixing ZOOKEEPER_IP in server.properties"
sed -i "s/{{ZOOKEEPER_IP}}/${ZOOKEEPER_IP:-localhost}/g" /storm/conf/storm.yaml

echo "Starting storm supervisor"
/storm/bin/storm supervisor
