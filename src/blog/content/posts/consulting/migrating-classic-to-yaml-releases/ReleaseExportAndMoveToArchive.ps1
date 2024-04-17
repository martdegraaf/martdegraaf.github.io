# Description: This script moves a release definition to a target folder in Azure DevOps
# it depends on you being signed in in the Azure cli, that can be done by `az login`
# Usage: ReleaseExportAndMoveToArchive.ps1 -releaseDefinitionName "MartService Release" -serviceName "MartService"
param (
    [Parameter(Mandatory=$true)]
    [string]$releaseDefinitionName,
    [Parameter(Mandatory=$true)]
    [string]$serviceName
)

# Prompt the user to login and get the access token
# see https://learn.microsoft.com/en-us/azure/devops/integrate/get-started/authentication/service-principal-managed-identity?toc=%2Fazure%2Fdevops%2Forganizations%2Fsecurity%2Ftoc.json&view=azure-devops#q-can-i-use-a-service-principal-or-managed-identity-with-azure-cli
$accessToken = az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query "accessToken" --output tsv
if ($accessToken -eq $null) {
    exit 1
}
$orgUrl = "https://vsrm.dev.azure.com/MartOrg"
$project = "MartProject"
$targetFolderId = "/Archive"

$headers = @{
    "Authorization" = ("Bearer {0}" -f $accessToken)
    "Accept"        = "application/json"
}

# Get the release definitions matching the given name
$uri = "$orgUrl/$project/_apis/release/definitions?api-version=7.0"
$definitionsResponse = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ContentType "application/json"

Write-Host "Found $($definitionsResponse.count) release definitions"
$definition = $definitionsResponse.value | Where-Object { $_.name -eq $releaseDefinitionName }

# Move the release definition to the target folder
$definition.id = $definition.id -replace ":", "%3A"  # Escape the colon in the definition ID
$uri = "$($definition.url)?api-version=7.0"
Write-Host "$uri"
# get the current release definition
$pipeline = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ContentType "application/json"
$pipeline.path = "$targetFolderId"

$json = @($pipeline) | ConvertTo-Json -Depth 99

# create serviceName folder
New-Item -ItemType Directory -Force -Path "tmp\$($serviceName.ToLower())"

Function ConvertTo-Yaml {
    param (
        [Parameter(Mandatory=$true)]
        [object]$object,
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    $yaml = 'variables:'
    foreach ($variable in $object.PsObject.Properties) {
        $yaml += "`n  $($variable.Name): $($variable.Value.Value)"
    }
    Write-Host $yaml
    $yaml | Out-File -FilePath $Path
}

# write a function to check if a pipeline use json stringify contains a text.
Function CheckPipelineContainsText {
    param (
        [Parameter(Mandatory=$true)]
        [string]$pipelineJson,
        [Parameter(Mandatory=$true)]
        [string]$text
    )
    #write $pipelineString to tmp/pipeline.json
    $pipelineJson | Out-File -FilePath "tmp\pipeline.json"
    return $pipelineJson.Contains($text)
}



ConvertTo-Yaml $pipeline.variables "tmp\$($serviceName.ToLower())\variables.yaml"
foreach ($environment in $pipeline.environments) {
    #transform $environment.name to o, t, a or p
    #Possible inputs: Development, Test, Acceptance, Production
    $environmentName = $environment.name.ToLower().Substring(0,1)
    $environmentSuffix = switch ($environmentName) {
        "d" { "o" }
        "t" { "t" }
        "a" { "a" }
        "p" { "p" }
    }
    ConvertTo-Yaml $environment.variables "tmp\$($serviceName.ToLower())\variables-$($environmentSuffix).yaml"
}

$yaml = "
trigger:
  branches:
    include:
    - main

pool: 'default'

resources:
  repositories:
  - repository: Pipelines
    type: git
    name: Pipelines
    ref: refs/heads/main

name: `$(Build.DefinitionName)_`$(SourceBranchName)_`$(date:yyyyMd).`$(Rev:r)

variables:
  - template: variables.yml

extends:
  template: Yaml/service.pipeline.yml@Pipelines
  parameters:"

$yaml | Out-File -FilePath "tmp\$($serviceName.ToLower())\$($serviceName.ToLower())-pipeline.yaml"

# update the release definition with the new path
$response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Put -Body $json -ContentType "application/json"

Write-Host "Release definition '$releaseDefinitionName' moved to folder '$targetFolderId'"