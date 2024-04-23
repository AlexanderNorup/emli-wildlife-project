#!/bin/bash
JSONDATE="$(date +%Y-%m-%d) $(date +%H:%M:%S).$(date +%N | cut -b1-3)$(date +%:z)"

TIMEMS=$(echo $JSONDATE | awk -F'[ +]' '{print $2}' | awk -F'[:.]' '{print $1$2$3"_"$4}')
DATE=$(echo $JSONDATE | awk '{print $1}')
FILENAME=$TIMEMS.jpg
FOLDERNAME=/WildlifeCam/$DATE


if [ ! -d $FOLDERNAME ]; then
        mkdir $FOLDERNAME
        chmod 777 $FOLDERNAME
fi

rpicam-still -t 0.01 -o $FOLDERNAME\/$FILENAME

JSONFILENAME=$(echo $FILENAME | sed 's/jpg/json/g')

TRIGGER=${1:-"TIME"}

JSONDATA=$(./create_metadata.sh $FOLDERNAME $FILENAME "$TRIGGER" "$JSONDATE")
echo $JSONDATA > $FOLDERNAME/$JSONFILENAME

chmod 777 $FOLDERNAME/$FILENAME
chmod 777 $FOLDERNAME/$JSONFILENAME

./log_wildlife.sh "$TRIGGER triggered the wildlife cam"
