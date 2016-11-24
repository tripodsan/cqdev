#!/bin/sh

PFX="http://localhost:4502/libs/system"
KEYSTORE=$(cd $(dirname $0); pwd)/keystore.jks
echo "Enabling HTTPS with keystore: $KEYSTORE"

curl -q -u admin:admin -F"jcr:primaryType=nt:folder" -F"config/jcr:primaryType=nt:folder" $PFX

sed -e "s/_KEYSTORE_PATH_/${KEYSTORE//\//\\/}/g" $(dirname $0)/org.apache.felix.http.config | \
curl -u admin:admin -v -T - $PFX/config/org.apache.felix.http.config 
