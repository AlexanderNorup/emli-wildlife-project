#!/bin/bash

# Param 1 = folder name
# Param 2 = file name
# Param 3 = trigger
# Param 4 = created date

CREATESECONDS=$(echo $4 | date +%s)
SUBJECTDISTANCE=$(exiftool -T -subjectdistance $1/$2)
EXPOSURETIME=$(exiftool -T -exposuretime $1/$2)
ISO=$(exiftool -T -ISO $1/$2)

JSON="{\"File Name\": \"$2\", \"Create Date\": \"$4\", \"Create Seconds Epoch\": $CREATESECONDS, \"Trigger\": \"$3\", \"Subject Distance\": \"$SUBJECTDISTANCE\", \"Exposure Time\": \"$EXPOSURETIME\", \"ISO\": $ISO}"

echo $JSON
