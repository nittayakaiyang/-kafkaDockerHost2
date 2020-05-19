#!/bin/bash

function createTopic()
{

  ZOOKEEPER=$1
  TOPIC=$2
  PARTITIONS=$3
  REP_FACTOR=$4

  CID=$(docker ps -f status=running -f label=kafka.id | awk 'NR == 2 {print $1}')

  if [ -z $PARTITIONS ]; then
    PARTITIONS=8
  fi
  
  if [ -z $REP_FACTOR ]; then
    REP_FACTOR=3
  fi

  if [ ! -z $CID ] && [ ! -z $ZOOKEEPER ] && [ ! -z $TOPIC ]; then
    docker exec -it $CID kafka-topics --zookeeper $ZOOKEEPER \
                                      --create \
                                      --topic $TOPIC \
                                      --replication-factor $REP_FACTOR --partitions $PARTITIONS
  fi

}

function removeTopic () {
  ZOOKEEPER=$1
  TOPIC=$2

  if [ ! -z $CID ] && [ ! -z $ZOOKEEPER ] && [ ! -z $TOPIC ]; then
    docker exec -it $CID kafka-topics --zookeeper $ZOOKEEPER \
                                      --delete \
                                      --topic $TOPIC
  fi
}

