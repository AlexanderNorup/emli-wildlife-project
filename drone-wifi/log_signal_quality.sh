#!/bin/bash

# Check if SQLite3 is installed
if ! command -v sqlite3 &> /dev/null; then
    echo "SQLite3 is not installed."
    exit 1
fi

# Check if the file /proc/net/wireless exists
if [ ! -f /proc/net/wireless ]; then
    echo "/proc/net/wireless not found."
    exit 1
fi

# Extract signal quality link and level
link=$(awk 'NR==3 {print $3}' /proc/net/wireless)
level=$(awk 'NR==3 {print $4}' /proc/net/wireless)

# Get current epoch time
epoch_time=$(date +%s)

# Define SQLite database and table
database=${1:-"wildlifecam"}
table=${2:-"signal_quality"}

# Create SQLite database if it doesn't exist
if [ ! -f "$database.db" ]; then
    sqlite3 "$database.db" "CREATE TABLE $table (id INTEGER PRIMARY KEY, link TEXT, level TEXT, epoch_time INTEGER);"
fi

# Insert data into SQLite database
sqlite3 "$database.db" "INSERT INTO $table (link, level, epoch_time) VALUES ('$link', $level, $epoch_time);"

# echo "Data inserted into SQLite database successfully."
# sqlite3 "$database.db" "select * from $table"
