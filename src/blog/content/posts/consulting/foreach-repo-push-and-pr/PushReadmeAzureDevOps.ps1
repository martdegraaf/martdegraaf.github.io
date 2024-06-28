# Prompt the user to login and get the access token
# see https://learn.microsoft.com/en-us/azure/devops/integrate/get-started/authentication/service-principal-managed-identity?toc=%2Fazure%2Fdevops%2Forganizations%2Fsecurity%2Ftoc.json&view=azure-devops#q-can-i-use-a-service-principal-or-managed-identity-with-azure-cli
$accessToken = az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query "accessToken" --output tsv
if ($null -eq $accessToken) {
    exit 1
}
$orgUrl = "https://dev.azure.com/MARTORG"
$project = "MARTPROJECT"

$repositoryId = "YOURREPO"
$readmeFilePath = "README.md"

$headers = @{
    "Authorization" = ("Bearer {0}" -f $accessToken)
    "Accept"        = "application/json"
    "Content-Type" = "application/json"
}

# Convert the README file to base64
$readmeContent = Get-Content -Path $readmeFilePath -Raw
$readmeBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($readmeContent))
Write-Host "README file content: $readmeContent"

# get current commit object id
$commitUrl = "$orgUrl/$project/_apis/git/repositories/$repositoryId/refs/heads/main?api-version=6.0"
$commitResponse = Invoke-RestMethod -Uri $commitUrl -Headers $headers -Method Get
Write-Host $commitResponse.Value
$commitObjectId = $commitResponse.Value.objectId

Write-Host "Current commit object id: $commitObjectId"

# Create the request body
$changes = @(
                @{
                    changeType = "edit"
                    item = @{
                        path = "README.md"
                    }
                    newContent = @{
                        content = $readmeBase64
                        contentType = "base64encoded"
                    }
                }
            )
$requestBody = @{
    refUpdates = @(
        @{
            name = "refs/heads/add-readme"
            oldObjectId = $commitObjectId
        }
    )
    commits = @(
        @{
            comment = "Adding README file"
            changes = $changes
        }
    )
} | ConvertTo-Json -Depth 6

# Set the API endpoint
$apiUrl = "$orgUrl/$project/_apis/git/repositories/$repositoryId/pushes?api-version=6.0"

# Send the API request
$response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body $requestBody

# Check the response
if ($response.pushId) {
    Write-Host "README file pushed successfully."
} else {
    Write-Host "Failed to push README file. Error: $($response.message)"
}

# create a pull request for myfirstbranch
$pullRequestUrl = "$orgUrl/$project/_apis/git/repositories/$repositoryId/pullrequests?api-version=6.0"
$pullRequestBody = @{
    sourceRefName = "refs/heads/add-readme"
    targetRefName = "refs/heads/main"
    title = "Add README file"
    description = "Adding README file"
} | ConvertTo-Json -Depth 6

$pullResponse = Invoke-RestMethod -Uri $pullRequestUrl -Method Post -Headers $headers -Body $pullRequestBody

if ($pullResponse.pullRequestId) {
    Write-Host "Pull request created successfully."
} else {
    Write-Host "Failed to create pull request. Error: $($pullResponse.message)"
}