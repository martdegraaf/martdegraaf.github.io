# Read configuration file
Get-Content "CloneAllRepos.config" | foreach-object -begin {$h=@{}} -process { 
    $k = [regex]::split($_,'='); 
    if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { 
        $h.Add($k[0], $k[1]) 
    } 
}
#AzDO config
$url = $h.Get_Item("Url")
# LocalGitConfig
$gitPath = $h.Get_Item("GitPath")
$orgName = $h.Get_Item("OrgName")
$pruneLocalBranches = $h.Get_Item("PruneLocalBranches") -eq "true"
$gitEmail = $h.Get_Item("GitEmail")

# Get the access token from current az login session
# see https://learn.microsoft.com/en-us/azure/devops/integrate/get-started/authentication/service-principal-managed-identity?toc=%2Fazure%2Fdevops%2Forganizations%2Fsecurity%2Ftoc.json&view=azure-devops#q-can-i-use-a-service-principal-or-managed-identity-with-azure-cli
$accessToken = az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query "accessToken" --output tsv
if ($null -eq $accessToken) {
    exit 1
}

$headers = @{
    "Authorization" = ("Bearer {0}" -f $accessToken)
    "Accept" = "application/json"
}

# Retrieve list of all repositories
$resp = Invoke-WebRequest -Headers $headers -Uri ("{0}/_apis/git/repositories?api-version=1.0" -f $url)
$json = convertFrom-JSON $resp.Content

# Clone or pull all repositories
$initpath =  ("{0}{1}" -f  $gitPath,$orgName)

foreach ($entry in $json.value) { 
    set-location $initpath
    $name = $entry.name 
    Write-Host $name -ForegroundColor Green

    if($entry.isDisabled){
        Write-Host "Skipping disabled repo: '$name'" -ForegroundColor Yellow
        continue;
    }

    $url = $entry.remoteUrl #-replace "://", ("://{0}@" -f $gitcred)
    if(!(Test-Path -Path $name)) {
        git clone $url
    } else {
        Write-Host "Directory '$name' exists lets pull"
        set-location $name
        git pull
        $defaultBranch = git symbolic-ref --short HEAD

        if($pruneLocalBranches){
            Write-Host "Pruning local branches $name" -ForegroundColor Yellow
            $branches = git branch -vv | Where-Object { $_ -notmatch "::" } | ForEach-Object { ($_ -split '\s+')[1] }

            foreach ($branch in $branches) {
                if ($branch -eq $defaultBranch) {
                    Write-Host "Skipping default branch '$branch'."
                    continue
                }
                if ((git branch -vv | Where-Object { $_ -match "$branch\s+\[origin\/" })) {
                    Write-Host "Skipping branch '$branch' as it has a remote reference."
                }
                else {
                    git branch -D $branch
                    Write-Host "Deleted local branch '$branch'." -ForegroundColor Green
                }
            }
        }
        if($gitEmail){
            git config user.email "$gitEmail"
        }
    }
}