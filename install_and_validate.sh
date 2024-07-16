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

# Function to apply cluster components
apply_cluster_components() {
  cpd-cli manage apply-cluster-components \
    --release=${VERSION} \
    --license_acceptance=true \
    --cert_manager_ns=${PROJECT_CERT_MANAGER} \
    --licensing_ns=${PROJECT_LICENSE_SERVICE}
}

# Function to authorize instance topology
authorize_instance_topology() {
  cpd-cli manage authorize-instance-topology \
    --cpd_operator_ns=${PROJECT_CPD_INST_OPERATORS} \
    --cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS}
}

# Function to setup instance topology
setup_instance_topology() {
  cpd-cli manage setup-instance-topology \
    --release=${VERSION} \
    --cpd_operator_ns=${PROJECT_CPD_INST_OPERATORS} \
    --cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
    --license_acceptance=true \
    --block_storage_class=${STG_CLASS_BLOCK}
}

# Function to apply entitlement
apply_entitlement() {
  local project_name=$1
  local entitlement=$2
  local production=$3
  local preview=$4
  cpd-cli manage apply-entitlement \
    --cpd_instance_ns=${project_name} \
    --entitlement=${entitlement} \
    --production=${production} \
    --preview=${preview}
}

# Function to get CR status
get_cr_status() {
  local component=$1
  cpd-cli manage get-cr-status \
    --cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
    --components=${component}
}

# Export necessary environment variables
export DATASTAGE_TYPE=datastage_ent

# Login to OCP
login_ocp

# Install Analytics Engine Powered by Apache Spark
apply_olm "analyticsengine"
apply_cr "analyticsengine"

# Install watsonx.data
apply_cluster_components
authorize_instance_topology
setup_instance_topology
export COMPONENTS="cpd_platform,watsonx_data"
apply_olm "${COMPONENTS}"
apply_cr "${COMPONENTS}"
apply_entitlement "${PROJECT_CPD_INST_OPERANDS}" "watsonx-data" "true" "false"

# Install Watson Studio
apply_olm "ws"
apply_cr "ws"

# Install DataStage
apply_olm "${DATASTAGE_TYPE}"
apply_cr "${DATASTAGE_TYPE}"

# Install IBM Watson Pipelines
apply_olm "ws_pipelines"
apply_cr "ws_pipelines"

# Install Watson Machine Learning
apply_olm "wml"
apply_cr "wml"

# Install Db2 Warehouse
apply_olm "db2wh"
apply_cr "db2wh"

# Install Db2 Data Management Console
apply_olm "dmc"
apply_cr "dmc"

# Validation of installations
get_cr_status "analyticsengine"
get_cr_status "cpd_platform"
get_cr_status "watsonx_data"
get_cr_status "ws"
get_cr_status "${DATASTAGE_TYPE}"
get_cr_status "ws_pipelines"
get_cr_status "wml"
get_cr_status "db2wh"
get_cr_status "dmc"

echo "Installation and validation complete."
