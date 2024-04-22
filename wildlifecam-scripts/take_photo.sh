#!/bin/bash

DATE=$(date +%H%M%S)
MS=$(date +%N | cut -b1-3)
FILENAME=$DATE\_$MS.jpg

FOLDERNAME=$(date +%Y-%m-%d)

if [ ! -d $FOLDERNAME ]; then
	mkdir $FOLDERNAME
fi

rpicam-still -t 0.01 -o $FOLDERNAME\/$FILENAME

# creating metadata file

CREATEDATE=$(exiftool -T -createdate $FOLDERNAME/$FILENAME)
CREATESECONDS=$(echo $CREATEDATE | sed 's/:/-/;s/:/-/' | date +%s)
TRIGGER=${1:-"Time"}
SUBJECTDISTANCE=$(exiftool -T -subjectdistance $FOLDERNAME/$FILENAME)
EXPOSURETIME=$(exiftool -T -exposuretime $FOLDERNAME/$FILENAME)
ISO=$(exiftool -T -ISO $FOLDERNAME/$FILENAME)

JSONFILENAME=$(echo $FILENAME | sed 's/jpg/json/g')
JSON="{\"File Name\": \"$FILENAME\", \"Create Date\": \"$CREATEDATE\", \"Create Seconds Epoch\": $CREATESECONDS, \"Trigger\": \"$TRIGGER\", \"Subject Distance\": \"$SUBJECTDISTANCE\", \"Exposure Time\": \"$EXPOSURETIME\", \"ISO\": $ISO}"

echo $JSON > $FOLDERNAME/$JSONFILENAME

