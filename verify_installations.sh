#!/bin/bash

# Function to get CR status
get_cr_status() {
  local component=$1
  cpd-cli manage get-cr-status \
    --cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
    --components=${component}
}

# Verify the status of Analytics Engine powered by Apache Spark
get_cr_status "analyticsengine"

# Verify the status of watsonx.data
get_cr_status "watsonx_data"

# Verify the status of Watson Studio
get_cr_status "ws"

# Verify the status of DataStage
get_cr_status "${DATASTAGE_TYPE}"

# Verify the status of WatsonPipeline
get_cr_status "ws_pipelines"

# Verify the status of Watson Machine Learning
get_cr_status "wml"

# Verify the status of Db2 Data Management Console
get_cr_status "dmc"

# Verify the status of Db2 Warehouse
get_cr_status "db2wh"
