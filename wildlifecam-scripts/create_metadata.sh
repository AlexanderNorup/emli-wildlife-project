#!/bin/bash

# Param 1 = folder name
# Param 2 = file name
# Param 3 = trigger
# Param 4 = created date

CREATESECONDS=$(echo $4 | date +%s)
TRIGGER=$3
SUBJECTDISTANCE=$(exiftool -T -subjectdistance $1/$2)
EXPOSURETIME=$(exiftool -T -exposuretime $1/$2)
ISO=$(exiftool -T -ISO $1/$2)

JSONFILENAME=$(echo $2 | sed 's/jpg/json/g') # We can probably remove this
JSON="{\"File Name\": \"$2\", \"Create Date\": \"$4\", \"Create Seconds Epoch\": $CREATESECONDS, \"Trigg>
echo $JSON
