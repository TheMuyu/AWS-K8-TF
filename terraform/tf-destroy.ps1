# PowerShell script to destroy Terraform modules in the correct order
# Uses the dev environment tfvars file as default
# .\tf-destroy.ps1 -TFVARS "-var-file=apply-tfvars/prod.tfvars"

param (
  [string]$TFVARS = "-var-file=apply-tfvars/dev.tfvars"
)

function Try-Destroy($module, $retries = 3) {
  $attempt = 1
  while ($attempt -le $retries) {
    Write-Host "Destroying $module (Attempt $attempt of $retries)..."
    terraform destroy "-target=$module" $TFVARS.Split() -auto-approve
    if ($LASTEXITCODE -eq 0) {
      Write-Host "$module destroyed successfully.`n"
      break
    } else {
      Write-Host "Destroy failed for $module. Retrying in 10 seconds..."
      Start-Sleep -Seconds 10
      $attempt++
    }
  }

  if ($attempt -gt $retries) {
    Write-Warning "$module failed to destroy after $retries attempts."
  }
}

# Optional: Refresh state before destruction
Write-Host "Refreshing Terraform state to ensure sync with AWS..."
terraform refresh $TFVARS.Split()

# Destroy modules in reverse dependency order with retry
Try-Destroy "module.rds"
Try-Destroy "module.eks"
Try-Destroy "module.alb"
Try-Destroy "module.watch"
Try-Destroy "module.bastion"
Try-Destroy "module.state"
Try-Destroy "module.vpc"
