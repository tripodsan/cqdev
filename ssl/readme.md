Enable SSL in AEM with _trusted_ self signed certificate
========================================================

1. Create root key

    ```
    openssl genrsa -out rootCA.key 2048
    ```

2. Create root cert:

    ```
    openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 3650 -out rootCA.pem
    ```
 
3. Create key and keystore

    ```
    keytool -genkeypair -keyalg RSA -validity 3650 -alias localhost \
        -keystore keystore.jks -keypass password -storepass password \
        -dname "CN=localhost, O=Company, L=San Francisco, S=CA, C=US"
    ```

4. Create csr

    ```
    keytool -certreq -alias localhost -file localhost.csr -keystore keystore.jks -storepass password
    ```

5. Sign csr

    ```
    openssl x509 -req -in localhost.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out localhost.crt -days 3650 -sha256
    ```

6. Import root CA

    ```
    keytool -importcert -trustcacerts -file rootCA.pem -alias root -keystore keystore.jks -storepass password
    ```

7. Import localhost cert

    ```
    keytool -importcert -trustcacerts -file localhost.crt -alias localhost -keystore keystore.jks -storepass password
    ```

8. Import root ca in osx keychain:

    ![OSX Keychain](keychain.png)

9. Update OSGi config

    see: https://docs.adobe.com/docs/en/aem/6-2/deploy/configuring/config-ssl.html#Enable SSL on the Author Instance

    or execute `install-config.sh` script.

10. Connect to test:

    https://localhost:8443/

    ![It works](https.png)
