#!/bin/bash

TIME=$(date +%H%M%S)
MS=$(date +%N | cut -b1-3)
DATE=$(date +%Y-%m-%d)
FILE1=$DATE\_$TIME\_$MS.jpg

FOLDERNAME=motions

if [ -d "$FOLDERNAME" ]; then
        rm -r "$FOLDERNAME"
fi

mkdir -p "$FOLDERNAME"

rpicam-still -t 0.01 -o $FOLDERNAME/$FILE1
TIME1=$(date +%s)

while true; do
        TIME2=$(date +%s)
        DIFF=$((TIME2-TIME1))
        if [ "$DIFF" -ge 1 ]; then
                JSONDATE="$DATE $(date +%H:%M:%S).$(date +%N | cut -b1-3)$(date +%:z)"

                TIMEMS=$(echo $JSONDATE | awk -F'[ +]' '{print $2}' | awk -F'[:.]' '{print $1$2$3"_"$4}')
                DATE=$(echo $JSONDATE | awk '{print $1}')
                FILE2=$DATE\_$TIMEMS.jpg

                rpicam-still -t 0.01 -o $FOLDERNAME/$FILE2

                python3 motion_detect.py $FOLDERNAME/$FILE1 $FOLDERNAME/$FILE2
                if [ $? -eq 1 ]; then
                        mkdir -p /WildlifeCam/$DATE

                        cp $FOLDERNAME/$FILE2 /WildlifeCam/$DATE/$TIMEMS.jpg
                        JSONDATA=$(./create_metadata.sh /WildlifeCam/$DATE $TIMEMS.jpg "Motion" "$JSONDA>
                        echo $JSONDATA > /WildlifeCam/$DATE/$TIMEMS.json

                        chmod 777 /WildlifeCam/$DATE/$TIMEMS.jpg
                        chmod 777 /WildlifeCam/$DATE/$TIMEMS.json
                        ./log_wildlife.sh "MOTION_DETECTED triggered the wildlife cam"
                fi

                rm $FOLDERNAME/$FILE1
                FILE1=$FILE2
                TIME1=$TIME2
        fi

done
