#!/bin/bash

function waiting () {
  msg='Waiting'
  while [ -z $(docker ps -f status=$2 -f label=$1.id | awk 'NR == 2 {print $1}') ]
  do
    msg+='.'
    echo -ne "\e[5m$msg\r\e[0m"
    sleep 1
  done
}

function removing () {
  msg='Removing'
  while [ ! -z $(docker ps -f status=running -f label=$1.id | awk 'NR == 2 {print $1}') ]
  do
    msg+='.'
    echo -ne "\e[5m$msg\r\e[0m"
    sleep 1
  done
}