# Set variables
$organizationUrl = "https://dev.azure.com/MART" # Replace Mart with organization name
$projectName = "ProjectName" # Replace ProjectName with project name
$username = "you@corperate.com" # Replace email with your Az DO username
$personalAccessToken = "[[TOKEN]]" # Get the personal access token from Azure DevOps with read access to the workitems




# Set headers
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $personalAccessToken)))
$headers = @{
    "Authorization" = ("Basic {0}" -f $base64AuthInfo)
    "Accept"        = "application/json"
}

# Get a list of workitems for given username
$workItemsUrl = "$organizationUrl/$projectName/_apis/wit/wiql?api-version=6.0"

$wiql = @"
SELECT [System.Id], [System.Title], [System.State], [System.AssignedTo], [System.Tags], [System.WorkItemType]
FROM workitems
WHERE [System.TeamProject] = @project
AND [System.WorkItemType] = 'Task'
AND [System.State] <> 'Closed'
AND [System.State] <> 'Removed'
AND [System.State] <>  'Done'
AND [System.AssignedTo] = @me
ORDER BY [System.ChangedDate] desc
"@

$body = @{ query = $wiql } | ConvertTo-Json


$workItemsResponse = Invoke-RestMethod -Uri $workItemsUrl -Headers $headers -Method Post -Body $body -ContentType "application/json"

# use workitemsbatch api to get all SELECT values

$workItemsUrl = "$organizationUrl/$projectName/_apis/wit/workitemsbatch?api-version=6.0"

# get the ids from $workItemsResponse.workItems in a list max 200
$ids = $workItemsResponse.workItems.id | Select-Object -First 200

# body is the list of ids in the workitemsresponse workitems.id, and the fields to select in a fields array
$body = @{ ids = $ids; fields = "System.Id", "System.Title", "System.State", "System.AssignedTo", "System.Tags", "System.WorkItemType" } | ConvertTo-Json

$workItemsResponse2 = Invoke-RestMethod -Uri $workItemsUrl -Headers $headers -Method Post -Body $body -ContentType "application/json"

Write-Host "Workitems found '$($workItemsResponse.workItems.count)'"


# write the response to a JSON file
$workItemsResponse2 | ConvertTo-Json -Depth 100 | Out-File -FilePath "workitems.json" -Force




