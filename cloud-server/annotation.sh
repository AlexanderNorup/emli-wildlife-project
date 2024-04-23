#!/bin/bash

# Ollava endpoint
ENDPOINT="http://localhost:11434/api/generate"

# Folder containing images and sidecar files
PATH_TO_IMAGES="./images"

# Function to check if the annotation object already exists in the JSON file
annotation_exists() {
    local json_file="$1"
    jq -e '.Annotation' "$json_file" > /dev/null
}

# Process all images in a directory
process_images_in_directory() {
    local directory="$1"
    # Iterate through each file in the directory
    for image_file in "$directory"/*; do
        # Check if the file is actually a file (and not a directory)
        if [ -f "$image_file" ]; then
            # Check if the file is an image (not json)
            file --mime-type "$image_file" | grep -q "image/"
            if [ $? -eq 0 ]; then

                # Get the filename without extension
                filename=$(basename "${image_file%.*}")
                # Check if the image has already been annotated
                json_file="$directory/$filename.json"

                if annotation_exists "$json_file"; then
                    echo "Skipping already annotated image: $image_file"
                    continue
                fi

                # Encode the image to base64
                image_base64=$(base64 -i $image_file)
                echo "Annotating image: $image_file"

                # Construct the JSON payload with the base64-encoded image
                JSON_PAYLOAD="{\"model\": \"llava:7b\", \"prompt\": \"What is in this picture?\", \"stream\": false, \"images\": [\"$image_base64\"]}"
                echo $JSON_PAYLOAD > "payload.json"
                response_file="${ANNOTATION_DIRECTORY}/$(basename "${image_file%.*}").json"
                # Send the request using curl
                curl_response=$(curl -f -s -X POST -H "Content-Type: application/json" --data-binary @payload.json "$ENDPOINT")
                if [ $? -ne 0 ]; then
                    echo "Annotation of $image_file failed. Aborting...";
                    continue;
                fi
                
                # Extract model and reponse from curl command
                model=$(echo "$curl_response" | jq -r '.model')
                description=$(echo "$curl_response" | jq -r '.response')
                
                # Create annotation JSON object
                annotation="{\"Annotation\": {\"Source\": \"$model\", \"Description\": \"$description\"}}"
                
                # Append the annotation object to the existing JSON file
                jq ". + $annotation" "$json_file" > "$json_file.tmp" && mv "$json_file.tmp" "$json_file"
            fi
        fi
    done
}

# Iterating through each directory in the images folder
for directory in $PATH_TO_IMAGES/*; do
    # Check if the entry is actually a directory
    if [ -d "$directory" ]; then
        # Process images in the directory
        process_images_in_directory "$directory"
    fi
done

echo "Finished annotating all image. Pushing to GitHub..."
./upload.sh