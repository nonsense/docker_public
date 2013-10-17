#!/bin/bash

echo "Cassandra node configuration:"
echo $CASS_SEEDS
echo $CASS_TOKEN
echo $CASS_LOCAL_IP

HOST=`hostname`
echo "127.0.0.1 $HOST" >> /etc/hosts

/opt/cassandra/bin/cassandra -f

