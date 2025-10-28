#!/usr/bin/env bash
set -e

PROFILE="default"
STACK_NAME="my-infra-stack-dev"
TEMPLATE="templates/main.yaml"
S3_BUCKET="meu-bucket-artifacts"

aws cloudformation package \
  --template-file $TEMPLATE \
  --s3-bucket $S3_BUCKET \
  --output-template-file packaged.yaml \
  --profile $PROFILE

aws cloudformation deploy \
  --template-file packaged.yaml \
  --stack-name $STACK_NAME \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides Environment=dev \
  --profile $PROFILE
