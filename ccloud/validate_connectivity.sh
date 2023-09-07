#!/bin/bash

# Check if bootstrap server is provided as an argument
if [ $# -ne 1 ]; then
    echo -e "Usage: $0 <ccloud-bootstrap-server-hostname> without port
        If ccloud bootstrap server is BOOTSTRAP:9092, enter BOOTSTRAP"
    exit 1
fi

BOOTSTRAP="$1"

## this should return below result
## -----BEGIN CERTIFICATE----- Verify return code: 0 (ok)

result="$(openssl s_client -connect $BOOTSTRAP:9092 -servername $BOOTSTRAP -verify_hostname $BOOTSTRAP </dev/null 2>/dev/null | grep -E 'Verify return code|BEGIN CERTIFICATE' | xargs)"

if [[ $result == *"Verify return code: 0 (ok)"* ]]; then
    echo "Connectivity is successful!"
  else
    echo -e "Failed to connect to  $BOOTSTRAP:9092. Try copy paste below command directly \n 
            openssl s_client -connect $BOOTSTRAP:9092 -servername $BOOTSTRAP -verify_hostname $BOOTSTRAP"
fi


