#!/bin/bash

echo 'starting MM2'
kubectl exec -it connect-0 -- bash -c "export KAFKA_LOG4J_OPTS='-Dlog4j.configuration=file:/opt/confluentinc/etc/connect/log4j.properties -javaagent:/usr/share/java/cp-base-new/jmx_prometheus_javaagent-0.14.0.jar=7788:/mnt/config/mm2/mm2-jmx-exporter.yaml' && /usr/bin/connect-mirror-maker /mnt/secrets/mm2-config/mm2.properties > /var/log/kafka/mm2.log"
echo 'done!'

