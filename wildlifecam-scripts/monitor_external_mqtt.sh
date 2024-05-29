#!/bin/bash

MQTT_HOST=${1:-"localhost"}
MQTT_TOPIC=${2:-"external/take_picture"}
MQTT_USER=${3:-"camera"}
MQTT_PASSWORD=${4:-"zebra"}

while read msg
do
    ./take_photo.sh "external"
done < <(mosquitto_sub -h $MQTT_HOST -t $MQTT_TOPIC -u $MQTT_USER -P $MQTT_PASSWORD)