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

# Function to get CR status
get_cr_status() {
  local component=$1
  cpd-cli manage get-cr-status \
    --cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
    --components=${component}
}

# Installing Analytics Engine powered by Apache Spark
login_ocp
apply_olm "analyticsengine"
apply_cr "analyticsengine"
get_cr_status "analyticsengine"

# Installing watsonx.data
login_ocp
apply_olm "watsonx_data"
apply_cr "watsonx_data"
get_cr_status "watsonx_data"

# Installing Watson Studio
login_ocp
apply_olm "ws"
apply_cr "ws"
get_cr_status "ws"

# Installing DataStage
login_ocp
apply_olm "datastage_ent"
apply_cr "${DATASTAGE_TYPE}"
get_cr_status "${DATASTAGE_TYPE}"

# Installing WatsonPipeline
login_ocp
apply_olm "ws_pipelines"
apply_cr "ws_pipelines"
get_cr_status "ws_pipelines"
