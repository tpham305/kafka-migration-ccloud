FROM confluentinc/cp-server-connect:7.4.0
ENV KAFKA_LOG4J_OPTS "-Dlog4j.configuration=file:/opt/confluentinc/etc/connect/log4j.properties"
USER 1001
CMD /usr/bin/connect-mirror-maker /mnt/secrets/mm2-config/mm2.properties  > /var/log/kafka/mirrormaker.log & 