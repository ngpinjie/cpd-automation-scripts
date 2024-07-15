#!/bin/bash

# Exporting DataStage type
export DATASTAGE_TYPE=datastage_ent

# Function to login to OCP
login_ocp() {
  echo "Logging in to OCP..."
  cpd-cli manage login-to-ocp \
    --username="${OCP_USERNAME}" \
    --password="${OCP_PASSWORD}" \
    --server="${OCP_URL}"
  
  if [ $? -ne 0 ]; then
    echo "Error logging in to OCP"
    exit 1
  fi
}

# Function to apply OLM
apply_olm() {
  local component=$1
  echo "Applying OLM for component: ${component}"
  cpd-cli manage apply-olm \
    --release="${VERSION}" \
    --cpd_operator_ns="${PROJECT_CPD_INST_OPERATORS}" \
    --components="${component}"
  
  if [ $? -ne 0 ]; then
    echo "Error applying OLM for component: ${component}"
    exit 1
  fi
}

# Function to apply CR
apply_cr() {
  local component=$1
  echo "Applying CR for component: ${component}"
  cpd-cli manage apply-cr \
    --components="${component}" \
    --release="${VERSION}" \
    --cpd_instance_ns="${PROJECT_CPD_INST_OPERANDS}" \
    --block_storage_class="${STG_CLASS_BLOCK}" \
    --file_storage_class="${STG_CLASS_FILE}" \
    --license_acceptance=true
  
  if [ $? -ne 0 ]; then
    echo "Error applying CR for component: ${component}"
    exit 1
  fi
}

# Ensure all required environment variables are set
REQUIRED_VARS=(OCP_USERNAME OCP_PASSWORD OCP_URL VERSION PROJECT_CPD_INST_OPERATORS PROJECT_CPD_INST_OPERANDS STG_CLASS_BLOCK STG_CLASS_FILE)

for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var}" ]; then
    echo "Error: Environment variable ${var} is not set"
    exit 1
  fi
done

# Ensure resources.txt exists
if [ ! -f resources.txt ]; then
  echo "Error: resources.txt not found"
  exit 1
fi

# Login to OCP
login_ocp

# Read components from resources.txt and install each one
while IFS= read -r component; do
  apply_olm "${component}"
  apply_cr "${component}"
done < resources.txt
