#!/bin/bash

MQTT_HOST="localhost"
MQTT_TOPIC="rain_sensor"
MQTT_USER="camera"
MQTT_PASSWORD="zebra"
DEVICE="/dev/ttyACM0"

# Function to control wiper angle
control_wiper() {
    angle="$1"
    if [ -c $DEVICE ]; then
	echo "wiping"
        echo "{\"wiper_angle\": $angle}" > $DEVICE
    fi
    echo "wiping potentially done"
}

while read msg
do
    ./log_wildlife.sh "Beginning wipe of lens"
    control_wiper 180
    echo "wipe 180"
    sleep 2
    control_wiper 0
    echo "wipe 0"
    sleep 2
    control_wiper 180
    echo "wipe 180"
    sleep 2
    control_wiper 0
    echo "wipe 0"
    ./log_wildlife.sh "Wiping of lens done"
done < <(mosquitto_sub -h $MQTT_HOST -t $MQTT_TOPIC -u $MQTT_USER -P $MQTT_PASSWORD)
