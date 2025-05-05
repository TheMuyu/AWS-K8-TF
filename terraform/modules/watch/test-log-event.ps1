# Set your AWS region
$region = "eu-central-1"

# Variables
$logGroup = "/aws/eks/backend"
$logStream = "test-stream"

# Generate Unix timestamp in milliseconds
$timestamp = [Math]::Floor((Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalMilliseconds)

# Check if log stream exists; create if not
$existingStreams = aws logs describe-log-streams `
    --log-group-name $logGroup `
    --log-stream-name-prefix $logStream `
    --region $region | ConvertFrom-Json

if (-not ($existingStreams.logStreams | Where-Object { $_.logStreamName -eq $logStream })) {
    Write-Host "Creating log stream '$logStream' in group '$logGroup'"
    aws logs create-log-stream `
        --log-group-name $logGroup `
        --log-stream-name $logStream `
        --region $region
}

# Prepare log events JSON
$logEvents = @"
[
    {
        "timestamp": $timestamp,
        "message": "Hello from test log!"
    }
]
"@

# Put log event
aws logs put-log-events `
    --log-group-name $logGroup `
    --log-stream-name $logStream `
    --log-events "$logEvents" `
    --region $region
