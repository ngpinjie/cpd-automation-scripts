# IBM Cloud Pak for Data Automation Scripts
This repository contains two scripts for installing and verifying IBM Cloud Pak for Data (CP4D) services on OpenShift Container Platform (OCP). These scripts automate the installation of various CP4D components and verify their installation status.

# Environment Variables
Ensure the following environment variables are set before running the scripts:
- OCP_USERNAME: Username for OCP login
- OCP_PASSWORD: Password for OCP login
- OCP_URL: OCP server URL
- VERSION: CP4D version to install
- PROJECT_CPD_INST_OPERATORS: Namespace for CP4D operators
- PROJECT_CPD_INST_OPERANDS: Namespace for CP4D operands
- STG_CLASS_BLOCK: Storage class for block storage
- STG_CLASS_FILE: Storage class for file storage
- DATASTAGE_TYPE: Type of DataStage to install (e.g., datastage_ent)

## Components Installed
- Analytics Engine powered by Apache Spark
- watsonx.data
- Watson Studio
- DataStage
- Watson Pipelines
- Watson Machine Learning
- Db2 Warehouse
- Db2 Data Management Console

## Prerequisites
- Red Hat OpenShift Container Platform cluster
- IBM Cloud Pak for Data CLI (`cpd-cli`) installed

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
A. Important:
```
Ensure you have environment variables setup properly.
source ./cpd_vars.sh
```

1. Clone the repository:
```sh
git clone https://github.com/ngpinjie/cpd-automation-scripts.git
cd cpd-automation-scripts
```
   
2. Make the script executable:
```
chmod +x install_services.sh
```

3. Run the script:
```
./install_services.sh
```

## Contributing
Feel free to open issues or submit pull requests with improvements and enhancements.
