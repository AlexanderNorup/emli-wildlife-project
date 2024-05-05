#!/bin/bash

IMAGE_FOLDER="../drone-sync-service/synced_images"

echo "Starting cloud script. Assuming a valid internet connection"
while true; do
   ./annotation.sh $IMAGE_FOLDER
    
    sleep 10 
done