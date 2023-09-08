#!/bin/bash

mm2_process=$(kubectl exec -it connect-0 -- bash -c  "ps -ef | grep java | grep mm2.properties")
if [[ ! $mm2_process == *"org.apache.kafka.connect.mirror.MirrorMaker"* ]]; then
    echo "MirrorMaker process is not running"
    ./start_mm2.sh    
    else
        echo "MirrorMaker is already running!"
fi

