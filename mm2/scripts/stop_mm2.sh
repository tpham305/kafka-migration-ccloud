#!/bin/bash

mm2_process=$(kubectl exec -it connect-0 -- bash -c  "ps -ef | grep java | grep mm2.properties")
if [[ ! $mm2_process == *"org.apache.kafka.connect.mirror.MirrorMaker"* ]]; then
    echo "MirrorMaker process is not running"
    else
        mm2_process_id=$(kubectl exec -it connect-0 -- bash -c  "ps -ef | grep java | grep mm2.properties" | sed -e '$d' | awk '{print $2}')
        echo "Stopping MirrorMaker process $mm2_process_id"
        kubectl exec -it connect-0 -- bash -c "kill -15 $mm2_process_id"
        echo "done!"

fi
