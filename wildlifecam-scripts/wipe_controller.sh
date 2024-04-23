#!/bin/bash

MQTT_HOST="localhost"
MQTT_TOPIC="rain_sensor"
MQTT_USER="camera"
MQTT_PASSWORD="zebra"
DEVICE="/dev/ttyACM0"

# Function to control wiper angle
control_wiper() {
    angle="$1"
    echo "{\"wiper_angle\": $angle}" > $DEVICE
}

while read msg
do
    ./log_wildlife.sh "Beginning wipe of lens"
    control_wiper 180
    sleep 1
    control_wiper 0
    sleep 1
    control_wiper 180
    sleep 1
    control_wiper 0
    ./log_wildlife.sh "Wiping of lens done"
done < <(mosquitto_sub -h $MQTT_HOST -t $MQTT_TOPIC -u $MQTT_USER -P $MQTT_PASSWORD)