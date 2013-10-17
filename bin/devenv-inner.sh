#/bin/bash
set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPS=${APPS:-/mnt/apps}

killz(){
	echo "Killing all docker containers:"
	docker ps
	docker ps | tail -n +2 |cut -d ' ' -f 1 | xargs docker kill
}

stop(){
	echo "Stopping all docker containers:"
	docker ps
	docker ps | tail -n +2 |cut -d ' ' -f 1 | xargs docker stop
}

start(){
	mkdir -p $APPS/zookeeper/data
	mkdir -p $APPS/zookeeper/logs
	ZOOKEEPER=$(docker run \
		-d \
		-p 2181:2181 \
		-v $APPS/zookeeper/logs:/logs \
		server:4444/zookeeper)
	echo "Started ZOOKEEPER in container $ZOOKEEPER"

	mkdir -p $APPS/redis/data
	mkdir -p $APPS/redis/logs
	REDIS=$(docker run \
		-p 6379:6379 \
		-v $APPS/redis/data:/data \
		-v $APPS/redis/logs:/logs \
		-d \
		server:4444/redis)
	echo "Started REDIS in container $REDIS"

	mkdir -p $APPS/cassandra/data
	mkdir -p $APPS/cassandra/logs
	CASSANDRA=$(docker run \
		-p 7000:7000 \
		-p 7001:7001 \
		-p 7199:7199 \
		-p 9160:9160 \
		-p 9042:9042 \
		-v $APPS/cassandra/data:/data \
		-v $APPS/cassandra/logs:/logs \
		-d \
		server:4444/cassandra)
	echo "Started CASSANDRA in container $CASSANDRA"

	mkdir -p $APPS/elasticsearch/data
	mkdir -p $APPS/elasticsearch/logs
	ELASTICSEARCH=$(docker run \
		-p 9200:9200 \
		-p 9300:9300 \
		-v $APPS/elasticsearch/data:/data \
		-v $APPS/elasticsearch/logs:/logs \
		-d \
		server:4444/elasticsearch)
	echo "Started ELASTICSEARCH in container $ELASTICSEARCH"

	mkdir -p $APPS/mongo/data
	mkdir -p $APPS/mongo/logs
	MONGO=$(docker run \
		-p 27017:27017 \
		-p 28017:28017 \
		-v $APPS/mongo/data:/data \
		-v $APPS/mongo/logs:/logs \
		-d \
		server:4444/mongo)
	echo "Started MONGO in container $MONGO"

	mkdir -p $APPS/kafka/data
	mkdir -p $APPS/kafka/logs
	KAFKA=$(docker run \
		-d \
		-p 9092:9092 \
		-v $APPS/kafka/data:/data \
		-v $APPS/kafka/logs:/logs \
		-e ZOOKEEPER_IP=192.168.1.1 \
		server:4444/kafka)
	echo "Started KAFKA in container $KAFKA"

	sleep 1

	echo "Wiring containers together..."
	echo "ZOOKEEPER as 192.168.1.1"
	$DIR/pipework br1 $ZOOKEEPER 192.168.1.1
	echo "KAFKA as 192.168.1.2"
	$DIR/pipework br1 $KAFKA 192.168.1.2
}

update(){
	apt-get update
	apt-get install -y lxc-docker

	docker pull server:4444/zookeeper
	docker pull server:4444/redis
	docker pull server:4444/cassandra
	docker pull server:4444/elasticsearch
	docker pull server:4444/mongo
	docker pull server:4444/kafka
}

case "$1" in
	restart)
		killz
		start
		;;
	start)
		start
		;;
	stop)
		stop
		;;
	kill)
		killz
		;;
	update)
		update
		;;
	status)
		docker ps
		;;
	*)
		echo $"Usage: $0 {start|stop|kill|update|restart|status|ssh}"
		RETVAL=1
esac
