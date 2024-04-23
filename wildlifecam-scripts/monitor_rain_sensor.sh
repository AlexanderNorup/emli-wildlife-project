#!/bin/bash
MQTT_HOST="localhost"
MQTT_TOPIC="rain_sensor"
MQTT_USER="camera"
MQTT_PASSWORD="zebra"
DEVICE="/dev/ttyACM0"

publish_message() {
    mosquitto_pub -h $MQTT_HOST -t $MQTT_TOPIC -m "raining" -u $MQTT_USER -P $MQTT_PASSWORD
}

# Loop and continuously read from /dev/ttyACM0
while true; do
    # Read JSON data from /dev/ttyACM0
    read WIPER_JSON <$DEVICE

    # If statement to check for json_error or angle_error
    if [[ "$WIPER_JSON" != *"json_error"* && "$WIPER_JSON" != *"angle_error"* ]]; then
        # Extract rain_detect from the JSON data
        RAIN_DETECTED=$(echo "$WIPER_JSON" | jq -r '.rain_detect')
    fi

    #echo $RAIN_DETECTED;

    # Check if RAIN_DETECTED is equal to 1 (it is raining)
    if [ "$RAIN_DETECTED" -eq 1 ]; then
       # echo "it's raining"
	# Publish MQTT message
        publish_message
	./log_wildlife.sh "Rain detected"
	sleep 10
    fi

    # Sleep for 1 second
    sleep 1
done