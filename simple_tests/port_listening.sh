#!/bin/bash

# Simple test for port listening
function usage() {
  echo "[port_listen_test]: Usage: ./port_listening.sh <port_to_test>"
  echo "[TESTER | port_listen_test |CRITICAL]: bad usage" >> "${TESTER_ERR_LOG_FILE}"
}

if [ "$#" -ne 1 ] || ! [[ "$1" =~ ^[0-9]+$  ]]; then
  usage
  return
fi

port=$1

echo "[TESTER| port_listen_test |INFO]: checking if OS contains netstat command" >> "${TESTER_EXEC_LOG_FILE}"
which netstat
if [ "$?" -ne 0 ]; then
  echo "[TESTER | port_listen_test |warning]: OS does not include netstat command" >> "${TESTER_ERR_LOG_FILE}"
else
  if sudo netstat -ntlp | grep ":$port " > /dev/null; then
    echo "[TESTER| port_listen_test |INFO]: OS is listening on port ${port}" >> "${TESTER_EXEC_LOG_FILE}"
  else
    echo "[TESTER | port_listen_test |CRITICAL]: No Listening on port ${port}" >> "${TESTER_ERR_LOG_FILE}"
    exit 1
  fi
  return
fi



echo "[TESTER| port_listen_test |INFO]: checking if OS contains lsof command" >> "${TESTER_EXEC_LOG_FILE}"
which lsof
if [ "$?" -ne 0 ]; then
  echo "[TESTER | port_listen_test |warning]: OS doe's not include lsof command" >> "${TESTER_ERR_LOG_FILE}"
  echo "[TESTER | port_listen_test |CRITICAL]: netstat and lsof are missing - make sure to install at least one of these to support the testing" >> "${TESTER_ERR_LOG_FILE}"
  exit 1
else
  if sudo lsof -i -P -n | grep LISTEN | grep ":$port " > /dev/null;then
      echo "[TESTER| port_listen_test |INFO]: OS is listening on port ${port}" >> "${TESTER_EXEC_LOG_FILE}"
  else
    echo "port does not listen"
    exit 1
  fi
  return
fi#