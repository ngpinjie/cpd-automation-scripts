#!/bin/bash

# Set environment variables
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

# Function to validate installation
validate_installation() {
  local component=$1
  echo "Validating installation for component: ${component}"
  cpd-cli manage get-cr-status \
    --cpd_instance_ns="${PROJECT_CPD_INST_OPERANDS}" \
    --components="${component}"
  
  if [ $? -ne 0 ]; then
    echo "Error validating installation for component: ${component}"
    exit 1
  fi
}

# Ensure all required environment variables are set
REQUIRED_VARS=(OCP_USERNAME OCP_PASSWORD OCP_URL VERSION PROJECT_CPD_INST_OPERATORS PROJECT_CPD_INST_OPERANDS STG_CLASS_BLOCK STG_CLASS_FILE PROJECT_CERT_MANAGER PROJECT_LICENSE_SERVICE)
for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var}" ]; then
    echo "Error: Environment variable ${var} is not set"
    exit 1
  fi
done

# Installing Analytics Engine Powered by Apache Spark
login_ocp
apply_olm "analyticsengine"
apply_cr "analyticsengine"
validate_installation "analyticsengine"

# Installing watsonx.data
login_ocp
cpd-cli manage apply-cluster-components \
  --release="${VERSION}" \
  --license_acceptance=true \
  --cert_manager_ns="${PROJECT_CERT_MANAGER}" \
  --licensing_ns="${PROJECT_LICENSE_SERVICE}"
  
cpd-cli manage authorize-instance-topology \
  --cpd_operator_ns="${PROJECT_CPD_INST_OPERATORS}" \
  --cpd_instance_ns="${PROJECT_CPD_INST_OPERANDS}"
  
cpd-cli manage setup-instance-topology \
  --release="${VERSION}" \
  --cpd_operator_ns="${PROJECT_CPD_INST_OPERATORS}" \
  --cpd_instance_ns="${PROJECT_CPD_INST_OPERANDS}" \
  --license_acceptance=true \
  --block_storage_class="${STG_CLASS_BLOCK}"

export COMPONENTS=cpd_platform,watsonx_data
apply_olm "${COMPONENTS}"
apply_cr "${COMPONENTS}"
cpd-cli manage apply-entitlement \
  --cpd_instance_ns="${PROJECT_CPD_INST_OPERANDS}" \
  --entitlement=watsonx-data \
  --production=true

validate_installation "cpd_platform"
validate_installation "watsonx_data"

# Installing Watson Studio
login_ocp
apply_olm "ws"
apply_cr "ws"
validate_installation "ws"

# Installing DataStage
login_ocp
apply_olm "${DATASTAGE_TYPE}"
apply_cr "${DATASTAGE_TYPE}"
validate_installation "${DATASTAGE_TYPE}"

# Installing IBM Watson Pipelines
login_ocp
apply_olm "ws_pipelines"
apply_cr "ws_pipelines"
validate_installation "ws_pipelines"

# Installing Watson Machine Learning
login_ocp
apply_olm "wml"
apply_cr "wml"
validate_installation "wml"

# Installing Db2 Warehouse
login_ocp
apply_olm "db2wh"
apply_cr "db2wh"
validate_installation "db2wh"

# Installing Db2 Data Management Console
login_ocp
apply_olm "dmc"
apply_cr "dmc"
validate_installation "dmc"
