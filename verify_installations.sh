#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p ./logs

# Function to get CR status
get_cr_status() {
  local component=$1
  nohup cpd-cli manage get-cr-status \
    --cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
    --components=${component} > "./logs/${component}_status.log" 2>&1 &
}

# Read components from resources.txt and verify the status of each one
while IFS= read -r component; do
  get_cr_status "${component}"
done < resources.txt
