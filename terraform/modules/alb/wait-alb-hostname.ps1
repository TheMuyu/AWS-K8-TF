for ($i = 0; $i -lt 30; $i++) {
    $hostname = kubectl get ingress frontend-ingress -n frontend -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>$null
    if (![string]::IsNullOrEmpty($hostname)) {
      Set-Content -Path alb_hostname.txt -Value $hostname
      exit 0
    }
    Start-Sleep -Seconds 10
  }
  exit 1
  