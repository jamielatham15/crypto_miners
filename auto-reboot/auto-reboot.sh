#!/bin/bash
set -x

# schedule job in startup.sh. Run script every hour.

# take miner process name (provid in crontab command)
myPROCESS="${@}"

# find miner process id
myPID=`pgrep -x "${myPROCESS}" | tail -n 1`

## check if miner running and reboot if exited.

echo "" >> crash-log

if pgrep -x "${myPROCESS}" > /dev/null
then
    ## check if miner has hanged without exit, reboot if miner cpu usage < 1.0%

    # take 10 samples of cpu usage with an interval of 5 seconds
    myCPU=`for i in {1..10}; do
    top -b -p ${myPID} -n 1 | tail -n 1 | awk '{print $9}'; sleep 1;
    done`

    # find the average of cpu usage samples
    myCPU=`echo "${myCPU}" | awk '{ sum += $0 } END { if (NR > 0) print sum / NR }'` 

    # convert to floating point number
    myCPU=`bc -l <<< "${myCPU}"`
    
    echo "" >> crash-log

    if (( $(echo "$myCPU > 1.0" | bc -l) )) > /dev/null
        then
            date >> crash-log
            echo "${myPROCESS} is running with:" >> crash-log
            echo  "`ps -p ${myPID} -o %cpu,%mem,cmd`" >> crash-log 
        exit
    else
        date >> crash-log
        echo "Miner hanged with av. cpu usage of ${myCPU}, rebooting" >> crash-log
    reboot
    fi
else
    date >> crash-log
    echo "Miner crashed, rebooting" >> crash-log
    reboot
fi









