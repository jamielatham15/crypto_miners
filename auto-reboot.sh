#!/bin/bash

# schedule job in startup.sh. Run script every hour.

echo "" >> crash-log

# ewbf
#if pgrep -x "ewbfminer" > /dev/null
# claymore 
#if pgrep -x "ethdcrminer64" > /dev/null
then
    echo "No problems" >> crash-log
    date >> crash-log 
else
    echo "Miner crashed, rebooting" >> crash-log
    date >> crash-log
    reboot
fi
