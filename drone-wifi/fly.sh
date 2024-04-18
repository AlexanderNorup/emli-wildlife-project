#!/bin/bash

SSID=${1:-"wildlife-cam"}

# Function to check WiFi connection
check_connection() {
    CURRENT_WIFI=`nmcli dev status | grep wlp4s0 | awk '{print $4}'` # This is very slow to realise the connection has ended
    if [[ "$CURRENT_WIFI" == "$SSID" ]]; then
        return 0 # true
    else
        return 1 # false
    fi
}

# Function to connect to WiFi
connect_wifi() {
    nmcli con up "$SSID" # This works only when the connection has already been established
			 # When the connection is not possible, it does take a while to give an error
    return $?
}

# Main loop
while true; do
    echo "Searching for WiFi network: $SSID..."

    until check_connection; do
        connect_wifi
        if [ $? -eq 0 ]; then
            echo "Connected to WiFi network: $SSID"
        else
            echo "Failed to connect to WiFi network: $SSID. Retrying..."
        fi
    done

    # Connected, do something every 2 seconds
    while check_connection; do
        echo "Connected to WiFi network: $SSID"
        sleep 2
    done

    echo "Disconnected from WiFi network: $SSID"
done
