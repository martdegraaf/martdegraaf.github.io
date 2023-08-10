# Set variables
$organizationUrl = "https://dev.azure.com/MART" # Replace Mart with organization name
$projectName = "ProjectName" # Replace ProjectName with project name
$username = "you@corperate.com" # Replace email with your Az DO username
$personalAccessToken = "[[TOKEN]]" # Get the personal access token from Azure DevOps

$dayTolerance = 14

# Set headers
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $personalAccessToken)))
$headers = @{
    "Authorization" = ("Basic {0}" -f $base64AuthInfo)
    "Accept"        = "application/json"
}

# Get a list of repositories in the project
$reposUrl = "$organizationUrl/$projectName/_apis/git/repositories?api-version=6.0"
$reposResponse = Invoke-RestMethod -Uri $reposUrl -Headers $headers -Method Get

Write-Host "Repos found '$reposResponse.count'"

#create dictionary openBranchesPerUser
$openBranchesPerUser = @{}

foreach ($repo in $reposResponse.value) {
    $repoName = $repo.name
    
    if ($repo.isDisabled) {
        Write-Host "Skipping disabled repo: '$repoName'" -foregroundcolor Gray
        continue;
    }
    
    Write-Host "Checking '$repoName':" -foregroundcolor yellow
	
    $branchesUrl = "$organizationUrl/$projectName/_apis/git/repositories/$repoName/refs?filter=heads&api-version=6.0"
    $branchesResponse = Invoke-RestMethod -Uri $branchesUrl -Headers $headers -Method Get
    foreach ($branch in $branchesResponse.value) {
        $branchName = $branch.name
        $BranchNameTrimmed = $branchName.replace('refs/heads/', '')
        if ($BranchNameTrimmed -eq 'master') {
            continue;
        }
        if ($BranchNameTrimmed -eq 'main') {
            continue;
        }
        $encodedBranchName = [System.Uri]::EscapeDataString($branchName)
        $pushesUrl = "$organizationUrl/$projectName/_apis/git/repositories/$repoName/pushes?searchCriteria.includeRefUpdates&searchCriteria.refName=$encodedBranchName&api-version=6.0"
        ## Write-Host "$branchName - $pushesUrl"
        $pushesResponse = Invoke-RestMethod -Uri $pushesUrl -Headers $headers -Method Get
        # get first push in the list
        $push = $pushesResponse.value[0];
        $firstPush = $pushesResponse.value[-1];

        #Convert $lastPush.date to DateTime object
        $lastPushDate = [DateTime]::Parse($firstPush.date);
        # if the last push date is older than today minus the dayTolerance, skip the branch
        if ($lastPushDate -gt (Get-Date).AddDays(-$dayTolerance)) {
            Write-Host "Skipping '$repoName' - '$branchName' - last push date '$($lastPush.date)'  compare date '$((Get-Date).AddDays(-$dayTolerance))' '$($push.pushedBy.uniqueName)'"  -foregroundcolor Red
            continue;
        }
        else {
            Write-Host "Checking '$repoName' - '$branchName' - last push date '$($lastPush.date)' compare date '$((Get-Date).AddDays(-$dayTolerance))' '$($push.pushedBy.uniqueName)' "
        }

        $pushedBy = $firstPush.pushedBy.uniqueName
        # Add to openBranchesPerUser dictionary with the user name as key and a object as value including branch name, repositoy and respository url
        if ($openBranchesPerUser.ContainsKey($pushedBy)) {
            $openBranchesPerUser[$pushedBy] += [PSCustomObject]@{
                Repository    = $repoName
                RepositoryUrl = $repo.webUrl + "/branches?_a=all"
                Branch        = $branchName
                firstPushDate = $firstPush.date
                lastPushDate  = $push.date
                lastPusher    = $push.pushedBy.uniqueName
            }
        }
        else {
            $openBranchesPerUser.Add($pushedBy, @([PSCustomObject]@{
                        Repository    = $repoName
                        RepositoryUrl = $repo.webUrl + "/branches?_a=all"
                        Branch        = $branchName
                        firstPushDate = $firstPush.date
                        lastPushDate  = $push.date
                    }))
        }
    }
}

# Write openBranchesPer user as a table, exclude RepositoryUrl
$openBranchesPerUser.GetEnumerator() | ForEach-Object {
    Write-Host "User: $($_.Key)" -ForegroundColor Green
    $_.Value | Format-Table -Property Repository, Branch, firstPushDate, lastPushDate, lastPusher -AutoSize
}

# Write openBranchesPerUser to a JSON file
$openBranchesPerUser | ConvertTo-Json | Out-File -FilePath "openBranchesPerUser.json" -Encoding ascii
