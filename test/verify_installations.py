import os
import subprocess

def get_cr_status(component):
    project_cpd_inst_operands = os.getenv('PROJECT_CPD_INST_OPERANDS')
    result = subprocess.run([
        'cpd-cli', 'manage', 'get-cr-status',
        '--cpd_instance_ns', project_cpd_inst_operands,
        '--components', component
    ], capture_output=True, text=True)
    print(result.stdout)

# Verify the status of Analytics Engine powered by Apache Spark
get_cr_status("analyticsengine")

# Verify the status of watsonx.data
get_cr_status("watsonx_data")

# Verify the status of Watson Studio
get_cr_status("ws")

# Verify the status of DataStage
get_cr_status(os.getenv('DATASTAGE_TYPE'))

# Verify the status of WatsonPipeline
get_cr_status("ws_pipelines")

# Verify the status of Watson Machine Learning
get_cr_status("wml")

# Verify the status of Db2 Data Management Console
get_cr_status("dmc")

# Verify the status of Db2 Warehouse
get_cr_status("db2wh")
