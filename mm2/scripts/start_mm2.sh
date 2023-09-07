#!/bin/bash

echo 'starting MM2'
kubectl exec -it connect-0 -- bash -c "export KAFKA_LOG4J_OPTS=-Dlog4j.configuration=file:/opt/confluentinc/etc/connect/log4j.properties && /usr/bin/connect-mirror-maker /mnt/secrets/mm2-config/mm2.properties > /var/log/kafka/mm2.log"
echo 'done!'

