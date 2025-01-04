#!/bin/bash

# Ensure required environment variables are set
if [[ -z "$AMI_ID" || -z "$KEY_PAIR_NAME" || -z "$INSTANCE_TYPE" || -z "$SSH_INGRESS_IP" ]]; then
  echo "Error: One or more required environment variables are not set."
  echo "Ensure AMI_ID, KEY_PAIR_NAME, INSTANCE_TYPE, and SSH_INGRESS_IP are exported."
  exit 1
fi

# Deploy the CloudFormation stack
aws cloudformation create-stack \
  --profile $AWS_PROFILE \
  --region $AWS_REGION \
  --stack-name MyEC2Stack \
  --template-body file://ec2-linux-template.yaml \
  --parameters \
      ParameterKey=AMIId,ParameterValue="$AMI_ID" \
      ParameterKey=KeyPairName,ParameterValue="$KEY_PAIR_NAME" \
      ParameterKey=InstanceType,ParameterValue="$INSTANCE_TYPE" \
      ParameterKey=SSHIngressIP,ParameterValue="$SSH_INGRESS_IP"

# Output success message
if [[ $? -eq 0 ]]; then
  echo "CloudFormation stack creation initiated successfully."
else
  echo "Error: Failed to create the CloudFormation stack."
fi
