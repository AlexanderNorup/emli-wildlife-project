#!/bin/bash

IMAGE_FOLDER="./test_images"

echo "Starting cloud script. Assuming a valid internet connection"
while true; do
   ./annotation.sh $IMAGE_FOLDER
    
    sleep 10 
done