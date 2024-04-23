#!/bin/bash

MQTT_HOST="localhost"
MQTT_TOPIC="external/take_picture"
MQTT_USER="camera"
MQTT_PASSWORD="zebra"

while read msg
do
    ./take_photo.sh "external"
done < <(mosquitto_sub -h $MQTT_HOST -t $MQTT_TOPIC -u $MQTT_USER -P $MQTT_PASSWORD)