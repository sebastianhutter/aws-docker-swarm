#!/bin/bash

export AWS_PROFILE=privat
export AWS_DEFAULT_REGION=eu-central-1

echo "$(date) : render templates"
j2 docker-vpc.yaml.j2 > docker-vpc.cf
j2 docker-ec2.yaml.j2 > docker-ec2.cf
j2 docker-s3.yaml.j2 > docker-s3.cf


echo "$(date) : deploy vpc stack"
aws cloudformation deploy --stack-name docker-vpc --template-file docker-vpc.cf --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM
echo "$(date) : deploy s3 stack"
aws cloudformation deploy --stack-name docker-s3 --template-file docker-s3.cf --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM
echo "$(date) : deploy ec2 stack"
aws cloudformation deploy --stack-name docker-ec2 --template-file docker-ec2.cf --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM

echo "$(date) : get assigned public ip"
publicip=$(aws cloudformation describe-stacks --stack-name docker-ec2 | jq -r -c '[ .Stacks[0].Outputs[] | select( .OutputKey | contains("PublicEip"))  ][0].OutputValue')
echo "$(date) : public ip is: ${publicip}, make sure to adapt dns records etc"
