---
title: "Creating Azure Pipelines Using PowerShell"
slug: "creating-azure-pipelines-using-powershell"
date: 2025-03-07T22:22:58+01:00
publishdate: 2025-03-07T22:22:58+01:00
draft: true
author: ["Mart de Graaf"]
tags: ["powershell", "azure devops", "automation", "pipelines"]
summary: "Have you ever created a new project and had code and pipelines and such ready to go, but still need to manually create the pipelines in Azure DevOps? Annoying, right? The flow is so simple it does not allow you to select folders or name your pipelines. This post will show you how to create Azure Pipelines using PowerShell."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true

cover:
    image: "cover.jpg" # image path/url
    alt: "Super hero that automates stuff" # alt text
    caption: "" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

Have you ever created a new project and had code and pipelines and such ready to go, but still need to manually create the pipelines in Azure DevOps? Annoying, right? The flow is so simple it does not allow you to select folders or name your pipelines. This post will show you how to create Azure Pipelines using PowerShell.

And if thats possible, why not automate more, like giving permissions to the pipelines and creating branchpolices? Let's dive in!


# Solution

To script the code i am using a mix of the Az CLI and the Azure DevOps REST API. The Az CLI is used to get the repo id and getting the authorization token. The REST API is used to create the pipeline, and more.
Enough talk, let's get to the code.

Also make sure the azure-devops extension is installed.

```powershell
az extension add --name azure-devops
```

## Getting access

```powershell
$accessToken = az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query "accessToken" -o tsv
if($null -eq $accessToken) {
    Write-Host "Could not get access token"
    exit 1
}

$headers = @{
    "Authorization"  = "Bearer $accessToken"
    "Content-Type"   = "application/json"
}
```

## Getting the repo id

```powershell
$repoName = "MyRepo"
$projectName = "MyProject"

$repo = az repos list --project $projectName --query "[?name=='$repoName']" -o json
if($null -eq $repo) {
    Write-Host "Could not find repo"
    exit 1
}
$repoId = $repo.id
Write-Host "Repo id is $repoId"
```

## Creating the pipeline

```powershell
# $headers and $repoId are already set from earlier samples
# Create a new pipeline
$projectName = "MyProject"
$repoName = "MyRepo"
$branchName = "main"
$yamlPath = "path/to/your/pipeline.yaml"

$uri = "https://dev.azure.com/your-org/$projectName/_apis/pipelines?api-version=7.1-preview.1"
$body = @{
    folder = "\\"
    name = "MyPipeline"
    configuration = @{
        path = $yamlPath
        repository = @{
            id = $repoId
            type = "azureReposGit"
            name = $repoName
            defaultBranch = $branchName
        }
    }
} | ConvertTo-Json

$pipelineId = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body -ContentType "application/json"
Write-Host "Pipeline created with id $($pipelineId.id)"
```

## Giving permissions

```powershell
# $headers and $repoId and $pipelineId are already set from earlier samples
# Give permissions to the pipeline
$projectName = "MyProject"
$repoName = "MyRepo"
$pipelineId = "MyPipelineId"

$uri = "https://dev.azure.com/your-org/$projectName/_apis/pipelines/$pipelineId/permissions?api-version=7.1-preview.1"
$body = @{
    resource = @{
        id = $pipelineId
        type = "pipeline"
    }
    role = "roleName"
    roleAssignment = @{
        principal = @{
            id = "principalId"
            descriptor = "principalDescriptor"
        }
    }
} | ConvertTo-Json -Depth 6

$permission = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body -ContentType "application/json"
Write-Host "Permission created with id $($permission.id)"

```

## Setting  the branch policy

```powershell
# $headers and $repoId and $pipelineId are already set from earlier samples
# Give the default branch a policy
$projectName = "MyProject"
$repoName = "MyRepo"
$branchName = "main"

$uri = "https://dev.azure.com/your-org/$projectName/_apis/policy/configurations?api-version=7.1-preview.1"
$body = @{
    isEnabled = $true
    isBlocking = $true
    type = @{
        id = "0609b952-1397-4640-95ec-e00a01b2c241"
    }
    settings = @{
        buildDefinitionId = $pipelineId
        queueOnSourceUpdate = $true
        displayName = "THE CODE SHOULD BUILD"
        scope = @{
            refName = "refs/heads/$branchName"
            matchKind = "exact"
            repositoryId = $repoId
        }
    }
} | ConvertTo-Json -Depth 6

$policy = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body -ContentType "application/json"
Write-Host "Policy created with id $($policy.id)"
```

# Conclusion and discussion

Having a script do the work can help you deliver consistent pipelines and policies. It can also help you to automate the creation of pipelines and policies in a new project. This can be useful when you have a lot of projects to manage.

Let's automate more together!
