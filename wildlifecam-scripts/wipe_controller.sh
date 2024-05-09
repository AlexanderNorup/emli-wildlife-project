#!/bin/bash

DEVICE=${1:-"/dev/ttyACM0"}
MQTT_HOST=${2:-"localhost"}
MQTT_TOPIC=${3:-"rain_sensor"}
MQTT_USER=${4:-"camera"}
MQTT_PASSWORD=${5:-"zebra"}

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
