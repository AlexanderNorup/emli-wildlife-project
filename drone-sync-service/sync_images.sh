#!/bin/bash

#Constants
outputDirectory="synced_images"
droneName="Drone-1337"
cameraHost="192.168.10.1"
apiKey="zebra"

function waitForConnection {
    while curl -s -f $cameraHost > /dev/null ; [ $? -ne 0 ] ; do
        echo "Waiting for server..."
        sleep 1
    done
    echo "Server reached!"
}

function startDownload {
    failed=false
    for file in $(curl -s -H "Accept: text/plain" $cameraHost/images?unacknowledged=true); do
        echo "Preparing to download file $file"
        folderForFile=$(echo $file | tr "_" "\n" | head -1) # Get the folder-name from the first part of the file-id
        fullOutputPath=$outputDirectory/$folderForFile

        mkdir -p $fullOutputPath; # Ensure folder exists

        curl $cameraHost/images/$file | tar -xC $fullOutputPath;

        if [ $? -ne 0 ]; then
            echo "Download of $file failed. Aborting downloads..";
            failed=true
            break;
        fi

        #Send ACK
        curl -f -X POST -H "Accept: text/plain" -H "X-API-KEY: $apiKey" -d $droneName $cameraHost/images/$file/ack > /dev/null
        if [ $? -ne 0 ]; then
            echo "Ack of file $file failed. Aborting downloads..";
            failed=true
            break;
        fi

        echo "Downloaded and acknowledged $file"
    done

    if [ $failed == true ]; then
        echo "Download was prematurely aborted!"
    else
        echo "All files downloaded"
    fi
}

function setTime {
    curl -f -X POST -H "Accept: text/plain" -H "X-API-KEY: $apiKey" -d $(date '+%Y-%m-%dT%H:%M:%S%z') $cameraHost/time > /dev/null

    if [ $? -ne 0 ]; then
        echo "Could not set time on the wild-life cam..";
        return 1
    fi
    echo "Time set successfully!"
    return 0
}

while true; do
    waitForConnection
    if setTime; then
        startDownload
    fi
    
    sleep 10 
done


