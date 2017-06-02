#!/bin/bash

ADMIN_PASSWORD=${ADMIN_PASSWORD:=admin123}

RESPONSE=$(curl -d "body=message" http://admin:${ADMIN_PASSWORD}@localhost:8161/api/message/TEST?type=queue&JMSTimeToLive=1000)
HEALTHY='Message sent'

if [ "$RESPONSE" == "$HEALTHY" ]
then
  echo OK
  exit 0
else
  echo "Something went wrong"
  exit 1
fi
