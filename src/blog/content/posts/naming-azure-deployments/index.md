---
title: "Naming Azure Deployments"
slug: "naming-azure-deployments"
date: 2026-01-30T07:54:28+01:00
publishdate: 2026-01-30T07:54:28+01:00
draft: true
author: ["Mart de Graaf"]
tags: ["azure", "bicep", "infrastructure-as-code"]
summary: "Best practices for naming Bicep deployments and Bicep modules to avoid overwriting and ensure uniqueness."
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
    alt: "Strategy, chess pieces on a board" # alt text
    caption: "Image by [Michal Jarmoluk](https://pixabay.com/users/jarmoluk-143740/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1080527) from [Pixabay](https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1080527)" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

## Azure overwrites deployments

When you deploy with the same name in Azure Resource Manager (ARM) or Bicep, Azure treats it as an update to the existing deployment. This means that if you use a static name for your deployments, each new deployment will overwrite the previous one. This can lead to confusion and makes it difficult to track changes over time.

Some people encountered a limit on the number of deployments you can have in a resource group. This limit is 800 deployments. When you reached this limit before 2020, you had to delete old deployments manually. However, since 2020, Azure automatically cleans up old deployments, so this is less of a concern now.

> https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-history-deletions?tabs=azure-powershell

## Constraints

When naming your deployments, keep in mind the following constraints:

- Deployment names must be unique within a resource group.
- Deployment names can contain alphanumeric characters, hyphens, and underscores.
- Deployment names cannot exceed 64 characters in length.

When using modules you want to make sure the deployment names are also unique within the scope of the module deployment.

## Naming strategy

To avoid overwriting deployments and to keep track of changes, it's a good practice to use a unique naming strategy for each deployment. Here are some common approaches:

1. **Timestamp**: Append a timestamp to the deployment name. This ensures that each deployment has a unique name based on the date and time it was created.
   Example: `myDeployment_20231119T075428`
2. **Versioning**: Use a version number in the deployment name. Increment the version number with each deployment.
   Example: `myDeployment_v1`, `myDeployment_v2`
3. **Combination**: Combine both timestamp and versioning for even more clarity.
    Example: `myDeployment_v1_20231119T075428`
4. **Unique Identifiers**: Use GUIDs or other unique identifiers to ensure uniqueness.
    Example: `myDeployment_123e4567-e89b-12d3-a456-426614174000`

### Naming starts in your CI CD pipeline

When deploying from a CI/CD pipeline, you can generate a unique deployment name using the pipeline's built-in variables. For example, in Azure DevOps, you can use the build ID or timestamp to create a unique name.

```yaml {linenos=table}
steps:
- task: AzureResourceManagerTemplateDeployment@3
  inputs:
    deploymentName: '$(Build.BuildId)'
    # Other deployment inputs
```

Or via Az cli in yaml:

```yaml {linenos=table}
steps:
- script: |
    az deployment group create --resource-group myResourceGroup --template-file main.bicep
        --name "$(Date:yyyyMMddTHHmmss)"
```

Or via Az cli in yaml:

```yaml {linenos=table}
steps:
- script: |
    az deployment group create --resource-group myResourceGroup --template-file main.bicep
        --name "$(Build.BuildId)"
```

In Github Actions, you can use the `github.run_id` or `github.run_number` to create a unique deployment name.

```yaml {linenos=table}
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - name: Deploy to Azure
      run: |
        az deployment group create --resource-group myResourceGroup --template-file main.bicep
            --name "${{ github.run_id }}"
```

### Bicep sample for timestamp naming

```bicep {linenos=table}
param deploymentName string = 'myDeployment_${utcNow('yyyyMMddTHHmmss')}'
resource deployment 'Microsoft.Resources/deployments@2021-04-01' = {
  name: deploymentName
  properties: {
    mode: 'Incremental'
    template: {
      // Your template content here
    }
  }
}
```

### User defined function for naming

You can create a user-defined function in Bicep to generate a unique deployment name based on your preferred strategy.

This example function creates a prefixed name and ensures it does not exceed 64 characters:
If it exceeds it will still encounter the error during deployment, but you can adjust the logic as needed.

```bicep {linenos=table}
@export()
@description('Returns a module name with a prefix and ensures the name is at most 64 characters')
func prefixedName(suffix string) string => length('${az.deployment().name}-${suffix}') > 64 ? substring('${az.deployment().name}-${suffix}', 0, 64) : '${az.deployment().name}-${suffix}'
```

So to fix it we want a scrolling suffix that makes sure the name is unique but also fits within the constraints.

```bicep {linenos=table}
@export()
@description('Returns a module name with a prefix and ensures the name is at most 64 characters')
func prefixedName(suffix string) string {
  var baseName = '${az.deployment().name}-${suffix}'
  var maxLength = 64
  return length(baseName) > maxLength ? substring(baseName, 0, maxLength) : baseName
}
```


# Conclusion and discussion

TODO
