#!/bin/bash


export AWS_PROFILE=privat
export AWS_DEFAULT_REGION=eu-central-1


echo "$(date) : delete ec2 stack"
aws cloudformation delete-stack --stack-name docker-ec2
aws cloudformation wait stack-delete-complete --stack-name docker-ec2

echo "$(date) : delete vpc stack"
aws cloudformation delete-stack --stack-name docker-vpc
aws cloudformation wait stack-delete-complete --stack-name docker-vpc

echo "$(date) : delete s3 stack manually !!!"
