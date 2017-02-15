#!/bin/bash

RESPONSE=$(curl -d "body=message" http://admin:admin123@localhost:8161/api/message/TEST?type=queue)
HEALTHY='Message sent'

if [ "$RESPONSE" == "$HEALTHY" ]
then
  echo OK
  exit 0
else
  echo "Something went wrong"
  exit 1
fi
