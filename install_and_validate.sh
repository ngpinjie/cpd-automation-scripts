#!/bin/bash

# Function to log in to the cluster
login_to_cluster() {
  cpd-cli manage login-to-ocp \
  --username=${OCP_USERNAME} \
  --password=${OCP_PASSWORD} \
  --server=${OCP_URL}
}

# Function to install an operator
install_operator() {
  local components=$1
  cpd-cli manage apply-olm \
  --release=${VERSION} \
  --cpd_operator_ns=${PROJECT_CPD_INST_OPERATORS} \
  --components=${components}
}

# Function to install a service
install_service() {
  local components=$1
  cpd-cli manage apply-cr \
  --components=${components} \
  --release=${VERSION} \
  --cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
  --license_acceptance=true
}

# Login to the cluster
login_to_cluster

# Install Analytics Engine Powered by Apache Spark
install_operator analyticsengine
install_service analyticsengine

# Install watsonx.data
cpd-cli manage apply-cluster-components \
--release=${VERSION} \
--license_acceptance=true \
--cert_manager_ns=${PROJECT_CERT_MANAGER} \
--licensing_ns=${PROJECT_LICENSE_SERVICE}

cpd-cli manage authorize-instance-topology \
--cpd_operator_ns=${PROJECT_CPD_INST_OPERATORS} \
--cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS}

cpd-cli manage setup-instance-topology \
--release=${VERSION} \
--cpd_operator_ns=${PROJECT_CPD_INST_OPERATORS} \
--cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
--license_acceptance=true \
--block_storage_class=${STG_CLASS_BLOCK}

export COMPONENTS=cpd_platform,watsonx_data

install_operator ${COMPONENTS}
cpd-cli manage apply-cr \
--release=${VERSION} \
--cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
--components=${COMPONENTS} \
--block_storage_class=${STG_CLASS_BLOCK} \
--file_storage_class=${STG_CLASS_FILE} \
--license_acceptance=true

cpd-cli manage apply-entitlement \
--cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
--entitlement=watsonx-data \
--production=true \
--preview=false

# Install Watson Studio
install_operator ws
install_service ws

# Install DataStage
export DATASTAGE_TYPE=datastage_ent
install_operator ${DATASTAGE_TYPE}
install_service ${DATASTAGE_TYPE}

# Install IBM Watson Pipelines
install_operator ws_pipelines
install_service ws_pipelines

# Install Watson Machine Learning
install_operator wml
install_service wml

# Install Db2 Warehouse
install_operator db2wh
install_service db2wh

# Install Db2 Data Management Console
install_operator dmc
install_service dmc

# Validate the installation
validate_component() {
  local component=$1
  cpd-cli manage get-cr-status \
  --cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
  --components=${component}
}

validate_component analyticsengine
validate_component cpd_platform
validate_component watsonx_data
validate_component ws
validate_component ${DATASTAGE_TYPE}
validate_component ws_pipelines
validate_component wml
validate_component db2wh
validate_component dmc
