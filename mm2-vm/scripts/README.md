### consumer-offset-validation.sh
This script list all consumer groups from source cluster and compare each offset sync with Confluent Cloud

#### How to use
1.  You need to have all the environment info required

Example env.properties
```
export OSK_BOOTSTRAP_SERVERS=kafka.source.svc.cluster.local:9071
export OSK_COMMAND_CONFIG=/tmp/mm2-vm/config/source.properties
export CCLOUD_BOOTSTRAP_SERVERS=pkc-ldvj1.ap-southeast-2.aws.confluent.cloud:9092
export CCLOUD_COMMAND_CONFIG=/tmp/mm2-vm/config/ccloud.properties
```
2. Set environment variables
```
source <env.properties>
```

3. Run the script 
```
./consumer-offset-validation.sh --osk-bootstrap-server $OSK_BOOTSTRAP_SERVERS --osk-command-config $OSK_COMMAND_CONFIG --ccloud-bootstrap-server $CCLOUD_BOOTSTRAP_SERVERS  --ccloud-command-config $CCLOUD_COMMAND_CONFIG
```
Sample response

`============================================================================

This script validates that consumer offsets are successfully synced over the cluster link from the source to destination

`============================================================================

=============================== PARAMETERS =================================

OSK Bootstrap Servers are: kafka.source.svc.cluster.local:9071
OSK Command Config File path is: /tmp/mm2-vm/config/source.properties
CCloud Bootstrap Servers are: pkc-ldvj1.ap-southeast-2.aws.confluent.cloud:9092
CCloud Command Config File path is: /tmp/mm2-vm/config/ccloud.properties
`============================================================================

=============================== OSK CONSUMERS ==============================

Gathering list of consumer groups from OSK cluster
Output written to 08-09-23-04:59:03osk_consumer_groups.txt

`============================================================================

=================================== DIFF ===================================

Comparing consumer group data between the OSK and CCloud clusters to validate the syncing
Output written to 08-09-23-04:59:09_diff.txt


Consumer group 'demo1_group_2' has no active members.
Consumer group 'demo1_group_2' has no active members.

Consumer group 'demo1_group' has no active members.
Consumer group 'demo1_group' has no active members.


#### Common Issue
Kafka Consumer Group Timeout Error. 

Refer to https://docs.confluent.io/cloud/current/monitoring/monitor-lag.html#known-kafka-consumer-groups-issues
