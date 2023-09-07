### Setting up CFK Connect Cluster
Overview: below steps are used to setup Connect Cluster using CFK, and run MM2 executable from connect pod(s).
The instructions use namespace `confluent`, replace it with your namespace

#### Pre-requisites
1. Prepare a Kubernetes cluster for CFK Connect Deployment
If you are K8S cluster admin, you have all the permissions. No extra steps are required.
If you are using a user with limited access, you need to get K8S cluser admin to install Confluent CRDS / grant permissions in advance before the deployment.
Refer to https://docs.confluent.io/operator/2.4/co-prepare.html 

2. Create a namespace for CFK and set it as default namespace
```
kubectl create namespace <confluent-namespace>
kubectl config set-context --current --namespace=<confluent-namespace>
```

#### Deploy Confluent for Kubernetes (CFK)
To deploy CFK, use 1 of the 2 options below

Deploy CFK from Confluent Helm Repo
1. Setup the Helm chart
`helm repo add confluentinc https://packages.confluent.io/helm`
`helm repo update`

2. Install CFK using Helm
`helm upgrade --install operator confluentinc/confluent-for-kubernetes --namespace confluent`

Deploy CFK using download bundle
1. Download CFK bundle
curl -O https://confluent-for-kubernetes.s3-us-west-1.amazonaws.com/confluent-for-kubernetes-2.4.4.tar.gz
2. From helm subdirectory of the download bundle, install CFK
```
cd confluent-for-kubernetes-<version>/helm 
helm upgrade --install confluent-operator \
  ./confluent-for-kubernetes \
  --namespace confluent
```

After installing CFK

3. Check that CFK pod comes up and is running
`kubectl get pods --namespace confluent`

#### Set working directory
```
export WORKDIR=<path to kafka-migration-cc/mm2>
cd $WORKDIR
```
#### Deploy configuration secrets
##### for mm2.properties config
```
kubectl -n confluent create secret generic mm2-config \
--from-file=mm2.properties=$WORKDIR/mm2.properties \
--save-config --dry-run=client -o yaml | kubectl apply -f -
```
##### for source cluster truststore
This is required for MM2 to connect to source cluster with SSL enabled, else you will get SSLHandshake Error.
Truststore password is set in mm2.properties `source.ssl.truststore.password` 
```
kubectl -n confluent create secret generic source-tls \
    --from-file=truststore.jks=$WORKDIR/certs/src-truststore.jks \
    --save-config --dry-run=client -o yaml | kubectl apply -f -
```
#### Deploy Kafka Connect
1. Deploy Connect cluster
```
kubectl -n confluent apply -f kafka-connect.yaml
```
2. Check connect pod is up and running
```
kubectl get po -n confluent -w
```
3. If it failed, troubleshoot by check 
```
kubectl get events -n confluent 
kubectl logs -f connect-0
```

### Run MM2 Executable on Connect Cluster
1. Once connect pod is in running status, run MirrorMaker2 executable
```
kubectl exec -it connect-0 -- bash -c "export KAFKA_LOG4J_OPTS=-Dlog4j.configuration=file:/opt/confluentinc/etc/connect/log4j.properties && /usr/bin/connect-mirror-maker /mnt/secrets/mm2-config/mm2.properties > /var/log/kafka/mm2.log"

or
scripts/start_mm2.sh
```
2. Check MM2 process is running 
```
kubectl exec -it connect-0 -- bash -c  "ps -ef | grep java" 
```
There should be 2 java processs running, 1 of them is MirrorMaker2 with mm2.properties at the end
3. Check for any error from MM2
```
kubectl exec -it connect-0 -- bash -c "tail -f /var/log/kafka/mm2.log"
```
4. Configure Autostart for MM2
If connect pod is restarted, MM2 process doesn't autorestart.
You can set cron job for `scripts/autostart_mm2.sh` to run every X mins to detect and autorestart

#### Appendix
How to create truststore.jks from ca-bundle

`keytool -import -trustcacerts -file ca-bundle.crt -alias CARoot -keystore truststore.jks -storepass <pass>`
