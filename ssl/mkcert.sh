#!/bin/sh
# openssl genrsa -out rootCA.key 2048

# openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 3650 -out rootCA.pem

keytool -genkeypair -keyalg RSA -validity 3650 -alias localhost \
    -keystore keystore.jks -keypass password -storepass password \
	-dname "CN=localhost.tripod.ch, O=Adobe, L=San Francisco, S=CA, C=US"

keytool -certreq -alias localhost -file localhost.csr -keystore keystore.jks -storepass password

openssl x509 -req -in localhost.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out localhost.crt -days 3650 -sha256

keytool -importcert -trustcacerts -file rootCA.pem -alias root -keystore keystore.jks -storepass password

keytool -importcert -trustcacerts -file localhost.crt -alias localhost -keystore keystore.jks -storepass password

