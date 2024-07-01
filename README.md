# cpd-automation-scripts
Shell scripts for automating the installation of IBM Cloud Pak for Data components on OpenShift

# IBM Cloud Pak for Data Automation Scripts

This repository contains shell scripts to automate the installation of various IBM Cloud Pak for Data components on a Red Hat OpenShift cluster.

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
1. Clone the repository:
```sh
git clone https://github.com/your_username/ibm-cloudpak-automation.git
cd ibm-cloudpak-automation
```
   
2. Make the script executable:
```
chmod +x install_cpd_components.sh
```

3. Run the script:
```
./install_cpd_components.sh
```

## Contributing
Feel free to open issues or submit pull requests with improvements and enhancements.
