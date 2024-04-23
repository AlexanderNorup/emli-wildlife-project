#!/bin/bash
# Committer Information
git config user.name "Wildlife Drone"
git config user.email "wildlife@drone.com"

git switch annotation

# Navigate to the directory containing the images
cd "$(dirname "$0")/images" || exit

# Generate a unique commit message with timestamp
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
commit_message="Annotations - $timestamp"

# Function to process all JSON files in a directory and its subdirectories
process_json_files() {
    local directory="$1"
    # Iterate through each JSON file in the directory
    for json_file in "$directory"/*.json; do
        # Check if the file is actually a file (not a directory)
        if [ -f "$json_file" ]; then
            # Add the JSON file to Git
            git add "$json_file"
        fi
    done
}

# Iterate through each folder in the images directory
for folder in */; do
    # Check if the entry is actually a directory
    if [ -d "$folder" ]; then
        # Process JSON files in the directory and its subdirectories
        process_json_files "$folder"
    fi
done

# Commit the changes with the unique message
git commit -m "$commit_message"

# Push the changes to the remote repository
git push origin annotation

# Navigate back to the original directory
cd -
