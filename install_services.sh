#!/bin/bash

# Function to login to OCP
login_ocp() {
  cpd-cli manage login-to-ocp \
    --username=${OCP_USERNAME} \
    --password=${OCP_PASSWORD} \
    --server=${OCP_URL}
}

# Function to apply OLM
apply_olm() {
  local component=$1
  cpd-cli manage apply-olm \
    --release=${VERSION} \
    --cpd_operator_ns=${PROJECT_CPD_INST_OPERATORS} \
    --components=${component}
}

# Function to apply CR
apply_cr() {
  local component=$1
  cpd-cli manage apply-cr \
    --components=${component} \
    --release=${VERSION} \
    --cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
    --block_storage_class=${STG_CLASS_BLOCK} \
    --file_storage_class=${STG_CLASS_FILE} \
    --license_acceptance=true
}

# Read components from resources.txt and install each one
login_ocp
while IFS= read -r component; do
  apply_olm "${component}"
  apply_cr "${component}"
done < resources.txt
