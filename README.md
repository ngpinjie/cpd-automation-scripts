# IBM Cloud Pak for Data Automation Scripts
This repository contains scripts for the automated installation and verification of IBM Cloud Pak for Data (CP4D) services on the OpenShift Container Platform (OCP). The scripts streamline the deployment process for various CP4D components and ensure their proper installation by checking their status.

## Prerequisites
- OpenShift Container Platform (OCP) cluster
- cpd-cli installed and configured
- Valid credentials and access to the OCP cluster
- Required environment variables set up

## Environment Variables
Ensure the following environment variables are set before running the scripts:
- `OCP_USERNAME`: Username for OCP login
- `OCP_PASSWORD`: Password for OCP login
- `OCP_URL`: OCP server URL
- `VERSION`: CP4D version to install
- `PROJECT_CPD_INST_OPERATORS`: Namespace for CP4D operators
- `PROJECT_CPD_INST_OPERANDS`: Namespace for CP4D operands
- `STG_CLASS_BLOCK`: Storage class for block storage
- `STG_CLASS_FILE`: Storage class for file storage
- `DATASTAGE_TYPE`: Type of DataStage to install (e.g., datastage_ent)

## Components Installed
- Analytics Engine powered by Apache Spark
- watsonx.data
- Watson Studio
- DataStage
- Watson Pipelines
- Watson Machine Learning
- Db2 Warehouse
- Db2 Data Management Console

## Environment Variables
Ensure the following environment variables are set before running the script: (Refer to Line 32 to 67 of https://github.com/ngpinjie/cpd-installation-scripts)
- `OCP_USERNAME`
- `OCP_PASSWORD`
- `OCP_URL`
- `VERSION`
- `PROJECT_CPD_INST_OPERATORS`
- `PROJECT_CPD_INST_OPERANDS`
- `STG_CLASS_BLOCK`
- `STG_CLASS_FILE`
- `DATASTAGE_TYPE`

## Usage
1. Clone the Repository
```
git clone https://github.com/ngpinjie/cpd-automation-scripts.git
cd cpd-automation-scripts
```
   
2. Make the script executable
```
chmod +x install_services.sh
chmod +x verify_installations.sh
```

3. Set Up Environment Variables
```
export OCP_USERNAME=<your_ocp_username>
export OCP_PASSWORD=<your_ocp_password>
export OCP_URL=<your_ocp_url>
export VERSION=<cpd_version>
export PROJECT_CPD_INST_OPERATORS=<cpd_operator_namespace>
export PROJECT_CPD_INST_OPERANDS=<cpd_operand_namespace>
export STG_CLASS_BLOCK=<block_storage_class>
export STG_CLASS_FILE=<file_storage_class>
export DATASTAGE_TYPE=<datastage_type>
```

4. Modify resources.txt
```
Edit the resources.txt file to include the components you want to install.
Each component should be on a new line.
```

5. Run the Installation Script
```
./install_services.sh
```

6. Verify the Installations
```
./verify_installations.sh
```

## Contributing
Feel free to open issues or submit pull requests with improvements and enhancements.
