#!/bin/bash

# Set the committer information
git config user.name "Wildlife Drone"
git config user.email "wildlife@drone.com"

# Navigate to the directory containing the images
cd "$(dirname "$0")/images" || exit

# Generate a unique commit message with timestamp
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
commit_message="Annotations - $timestamp"

# Add all JSON files to Git
git add "*.json"

# Commit the changes with the unique message
git commit -m "$commit_message"

# Push the changes to the remote repository
git push origin annotate 

# Navigate back to the original directory
cd -
