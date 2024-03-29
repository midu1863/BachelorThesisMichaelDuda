echo " " >> $1.queue
while :
do
    ./queueSize.sh | awk '/RuntimeCmd: egressEnqueueDepth\[1\]=/ { printf "%s ", strftime("%s"); print $NF }' >> $1.queue
    sleep 0.001
done


