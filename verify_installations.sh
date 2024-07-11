#!/bin/bash

# Function to get CR status
get_cr_status() {
  local component=$1
  cpd-cli manage get-cr-status \
    --cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
    --components=${component}
}

# Read components from resources.txt and verify the status of each one
while IFS= read -r component; do
  get_cr_status "${component}"
done < resources.txt
