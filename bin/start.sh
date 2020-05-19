#!/bin/bash

# initial config
source ./conf/env
source ./utils/loader.sh
#source ./utils/topic.sh

export KAFKA_PORT=19092
export ZK_PORT=12181

# init node id from param
NODE_ID="2"
export NODE_ID

if [ -z "$NODE_ID" ]; then
  echo -e "\e[91mPlease enter node id (eg. 1, 2, 3)\e[0m"
  exit 1
fi

if [[ -z $(docker-compose -v | grep version) ]]; then
  echo -e "\e[91mPlease install docker-compose first!\e[0m"
  exit 1
fi

DATA_DIR=/data/kafka/data
if [ ! -d "$DATA_DIR" ]; then
  mkdir -p $DATA_DIR
fi

LOGS_DIR=/data/kafka/logs
if [ -d "$LOGS_DIR" ]; then
  mkdir -p $LOGS_DIR
fi

# init kafka ip
NODE_IP=NODE_IP_${NODE_ID}
export KAFKA_IP=${!NODE_IP}

docker-compose -f $(pwd)/compose/docker-compose.yml up -d && waiting "kafka" "running"

echo -e "\e[5mStarting...\e[0m"
if [ ! -z $(docker ps -f status=running -f label=kafka.id | awk 'NR == 2 {print $1}') ]; 
then 
  echo -e "- Kafka start \e[32msuccess.\e[0m"
  # if [ "$NODE_ID" = "1" ]; then
  #   cat $(pwd)/conf/topics | while read topic partitions factor; do
  #     createTopic "${!NODE_IP}:$ZK_PORT" $topic $partitions $factor
  #   done
  # fi
else
  echo -e "- Kafka start \e[91mfailure.\e[0m"
fi
