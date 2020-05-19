#!/bin/bash
source ./utils/loader.sh

function findContainerId () {
  echo $(docker ps -f status=running -f status=restarting -f label=$1.id | awk 'NR == 2 {print $1}')
}

function removeContainerByName () {
  CID=$(findContainerId $1)

  if [ ! -z $CID ];
  then
    echo "Remove $1"
    echo "---"
    docker stop $CID && \
    docker rm $CID &
    removing $1
    echo -e "\nRemove container $1 \e[32msuccess.\e[0m"
  else
    echo -e "\e[91m\nContainer $1 not found.\e[0m"
  fi
}

removeContainerByName "kafka"