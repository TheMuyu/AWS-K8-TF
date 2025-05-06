# PowerShell script to estimate AWS costs using Terraform and Infracost

# Exit on error
$ErrorActionPreference = "Stop"

# Define tfvars file
$tfvars = "apply-tfvars/dev.tfvars"

# Run Infracost against the plan
infracost breakdown --path . --terraform-var-file=$tfvars