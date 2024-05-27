#!/bin/bash
PATH_TO_IMAGES=${1:-"../drone-sync-service/synced_images"}

# Set the committer information
git config --local user.name "Wildlife Drone"
git config --local user.email "wildlife@example.com"

# Navigate to the directory containing the images
cd $PATH_TO_IMAGES || exit

# Generate a unique commit message with timestamp
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
commit_message="Annotations - $timestamp"

# Sync git repository
git pull

# TODO: Add handler here if "git pull" fails due to conflicts.

# Add all JSON files to Git
git add "*.json"

# Commit the changes with the unique message
git commit -m "$commit_message"

# Push the changes to the remote repository
git push

# Navigate back to the original directory
cd -
