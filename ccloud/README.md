### Script: validate_connectivity.sh
This script validates the connectivity from the instance where the script is hosted (within your VPC, VNet) to Confluent Cloud.
The script executes command  `openssl s_client -connect <host>:<port>`

If openssl is not available, consider using netcat `nc -zv <bootstrap-host> 9092 ` or telnet `telnet <bootstrap-host> 9092`

How to use
1. Set envrionment variable for cluster bootstrap url without the port
```
export BOOTSTRAP=<bootstrap-host>
```
e.g with bootstrap server lkc-222v1o-4kgzg.centralus.azure.glb.confluent.cloud:9092

``` 
export BOOTSTRAP=lkc-222v1o-4kgzg.centralus.azure.glb.confluent.cloud
```
2.  Test connectivity
``` 
./validate_connectity.sh $BOOTSTRAP
```