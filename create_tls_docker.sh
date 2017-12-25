#!/bin/bash

# simple shell script to create tls certificates for docker node

# self signed ca cert and ca private key
cacert="$HOME/.ssh/docker-ca.pem"
cakey="$HOME/.ssh/docker-ca-priv-key.pem"

nodename=$1
[ -z "${nodename}" ] && echo "please specify node name" && exit  

# create cert
openssl genrsa -out ${nodename}-key.pem 2048
openssl req -subj "/CN=${nodename}" -new -key ${nodename}-key.pem -out ${nodename}.csr
openssl x509 -req -days 1825 -in ${nodename}.csr -CA ${cacert} -CAkey ${cakey} -CAcreateserial -out ${nodename}-cert.pem -extensions v3_req 
openssl rsa -in ${nodename}-key.pem -out ${nodename}-key.pem

# create zip with necessary files
cp ${cacert} ./ca.pem
zip ${nodename}.zip ca.pem ${nodename}-cert.pem ${nodename}-key.pem

# cleanup
rm ${nodename}.csr ${nodename}-cert.pem ${nodename}-key.pem ca.pem


