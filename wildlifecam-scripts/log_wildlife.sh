#!/bin/bash

echo $1 | systemd-cat -t ${2:-"wildlifelogs"} -p info
