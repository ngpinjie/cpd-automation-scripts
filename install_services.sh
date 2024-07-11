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

# Installing Analytics Engine powered by Apache Spark
login_ocp
apply_olm "analyticsengine"
apply_cr "analyticsengine"

# Installing watsonx.data
login_ocp
apply_olm "watsonx_data"
apply_cr "watsonx_data"

# Installing Watson Studio
login_ocp
apply_olm "ws"
apply_cr "ws"

# Installing DataStage
login_ocp
apply_olm "datastage_ent"
apply_cr "${DATASTAGE_TYPE}"

# Installing WatsonPipeline
login_ocp
apply_olm "ws_pipelines"
apply_cr "ws_pipelines"

# Installing Watson Machine Learning
login_ocp
apply_olm "wml"
apply_cr "wml"

# Installing Db2 Data Management Console
login_ocp
apply_olm "dmc"
apply_cr "dmc"

# Installing Db2 Warehouse
login_ocp
apply_olm "db2wh"
apply_cr "db2wh"
