#!/bin/bash

# Ollava endpoint
ENDPOINT="http://localhost:11434/api/generate"

# Function to process images in a directory
process_images_in_directory() {
    local directory="$1"
    # Iterate through each file in the directory
    for image_file in "$directory"/*; do
        # Check if the file is actually a file (not a directory)
        if [ -f "$image_file" ]; then
            # Check if the file is an image
            file --mime-type "$image_file" | grep -q "image/"
            if [ $? -eq 0 ]; then
                # Encode the image to base64
                image_base64=$(base64 -i $image_file)
                # Construct the JSON payload with the base64-encoded image
                JSON_PAYLOAD="{\"model\": \"llava:7b\", \"prompt\": \"What is in this picture?\", \"stream\": false, \"images\": [\"$image_base64\"]}"
                echo $JSON_PAYLOAD > "payload.json"
                echo "Processing image: $image_file"
                # Send the request using curl
                curl -f -X POST -H "Content-Type: application/json" --data-binary @payload.json "$ENDPOINT"
                if [ $? -ne 0 ]; then
                    echo "Annotation of $image_file failed. Aborting..";
                    continue;
                fi
            else
                echo "Skipping non-image file: $image_file"
            fi
        fi
    done
}

# Iterate through each directory in the images folder
for directory in ./images/*; do
    # Check if the entry is actually a directory
    if [ -d "$directory" ]; then
        # Process images in the directory
        process_images_in_directory "$directory"
    fi
done

