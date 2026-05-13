---
title: "Update dependencies using Renovate CLI in Azure Devops"
slug: "renovate-in-azure-devops"
date: 2026-01-22T23:14:42+01:00
publishdate: 2026-02-27T23:14:42+01:00
draft: true
author: ["Mart de Graaf"]
tags: ["azure-devops", "ci-cd", "renovate", "dependency-management", "yaml", "automation"]
summary: "Automate dependency updates in your Azure Devops repositories using Renovate CLI integrated into your CI/CD pipelines."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: false
ShowWordCount: true

cover:
    image: "cover.jpg" # image path/url
    alt: "Image by Tom Majric from Pixabay" # alt text
    caption: "Image by [Tom Majric](https://pixabay.com/users/tomasi-654521/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=6170616) from [Pixabay](https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=6170616)" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

Lately our team has been exposed to a lot of vulnerability alerts on our npm dependencies. We have to keep our dependencies up to date to avoid security risks and bugs. Manually updating dependencies can be time-consuming and error-prone.

In this blog post, we will explore how we can use Renovate CLI, an open-source tool that automates dependency updates.

## Other mentionable tools

Renovate Enterprise is a commercial version of Renovate that offers additional features and support for larger teams and organizations. This is a SaaS offering. Which means your code is sent to 3rd party servers, if this is a concern you should consider using Renovate CLI or Dependabot.

- Dependabot: A GitHub-native tool that automatically creates pull requests to update dependencies.
- Trivy: A comprehensive security scanner for containers and other artifacts, which can also scan for vulnerabilities in dependencies.

> I do run dependabot on some of my personal projects. I have no experience with Trivy.

## Renovate CLI

Renovate CLI is a command-line tool that can be integrated into your CI/CD pipelines to automate the process of updating dependencies.

### Pizza session inspiration

A colleague of mine, Ivo Verburgh, presented the Renovate CLI tool in a so called pizza session. When he demo-ed the tool I was impressed by the number of supported languages and package managers and the ease of use.

> https://github.com/iverburgh/Renovate4Dotnet

So these two events together, the vulnerability alerts and the pizza session, made me decide to give Renovate CLI a try in one of our Azure Devops repositories.

### Start locally

TODO kan ik ook code inladen van een github repo?
```ps1

```

```bash
```

```cmd
npx renovate
```

### Personal Access Token (PAT)

Before we dive into the pipeline, we have to address the authentication part. Renovate CLI needs to authenticate with Azure Devops to create branches and pull requests.

There is a so called Azure Devops token (PAT) that you can create in your Azure Devops profile settings. This token should have at least read and write permissions for code and pull requests.

As a best practice, we should never use PERSONAL tokens in our pipelines. Instead, we can use a service connection, this can be done by using the System Access Token `$(System.AccessToken)` that is available in Azure Devops pipelines.

### Azure pipeline configuration

main challenges:
- System Access Token usage
- NPMRC file usage for private npm packages
- Making it work on a windows based build agent

```yaml {linenos=table}
schedules:
  - cron: '0 3 * * *'
    displayName: 'Every day at 3am (UTC)'
    branches:
      include: [ main ]
    always: true

trigger: none

parameters:
  - name: logLevel
    displayName: "The loglevel to use for renovate"
    type: string
    default: "info"
    values:
      - info
      - debug
  - name: nodeVersion
    displayName: "The Node.js version to use"
    type: string
    default: '22.19'

variables:
  logLevel: ${{ parameters.logLevel }}

pool: default

steps:
  - checkout: self
    fetchDepth: 1
    clean: true
    persistCredentials: true
  - task: UseNode@1
    displayName: 'Use Node ${{ parameters.nodeVersion }}'
    inputs:
      version: ${{ parameters.nodeVersion }}
  - task: npmAuthenticate@0
    inputs:
      workingFile: .npmrc
  - powershell: |
      git config --global user.email 'bot@renovateapp.com'
      git config --global user.name 'Renovate Bot'
      npx --userconfig .npmrc renovate
    displayName: 'Run Renovate'
    env:
      RENOVATE_PLATFORM: "azure"
      RENOVATE_ENDPOINT: $(System.CollectionUri)
      RENOVATE_TOKEN: $(System.AccessToken)
      AZURE_DEVOPS_PAT: $(System.AccessToken)
      AZURE_DEVOPS_ORGANIZATION: $(System.CollectionUri)
      AZURE_DEVOPS_PROJECT: $(System.TeamProject)
      RENOVATE_GITHUB_COM_TOKEN: $(GITHUB_TOKEN) # See https://docs.renovatebot.com/mend-hosted/github-com-token/#step-1-acquire-a-githubcom-token and save it as secret variable in the pipeline
      LOG_LEVEL: $(logLevel)
```

### Timeouts

We ran the script for 80 repositories, and it hit the job timeout of 1 hour. After trying 3 hours, it also hit the timeout. So I editted the pipeline to use a matrix strategy, a job for every repository. To get all matching repositories Renovate does have an argument `--write-discovered-repos=discovered-repos.json` to only write the discovered repositories to JSON. I read them and put them into a variable to put into the matrix.

```yaml {linenos=table}
schedules:
  - cron: '0 3 * * *'
    displayName: 'Every day at 3am (UTC)'
    branches:
      include: [ main ]
    always: true

trigger: none

parameters:
  - name: logLevel
    displayName: "The loglevel to use for renovate"
    type: string
    default: "info"
    values:
      - info
      - debug
  - name: nodeVersion
    displayName: "The Node.js version to use"
    type: string
    default: '22.19'

variables:
  logLevel: ${{ parameters.logLevel }}

jobs:
  - job: Discover
    displayName: 'Discover Repositories'
    pool: default
    steps:
      - checkout: self
        fetchDepth: 1
        clean: true
        persistCredentials: true
      - task: UseNode@1
        displayName: 'Use Node ${{ parameters.nodeVersion }}'
        inputs:
          version: ${{ parameters.nodeVersion }}
      - task: npmAuthenticate@0
        inputs:
          workingFile: .npmrc
      - powershell: |
          npx --userconfig .npmrc renovate --write-discovered-repos=discovered-repos.json
        displayName: 'Discover Repos with Renovate'
        env:
          RENOVATE_PLATFORM: "azure"
          RENOVATE_ENDPOINT: $(System.CollectionUri)
          RENOVATE_TOKEN: $(System.AccessToken)
          AZURE_DEVOPS_PAT: $(System.AccessToken)
          AZURE_DEVOPS_ORGANIZATION: $(System.CollectionUri)
          AZURE_DEVOPS_PROJECT: $(System.TeamProject)
          RENOVATE_GITHUB_COM_TOKEN: $(GITHUB_TOKEN)
          LOG_LEVEL: $(logLevel)
      - powershell: |
          $repos = Get-Content -Raw 'discovered-repos.json' | ConvertFrom-Json
          $matrix = @{}
          foreach ($repo in $repos) {
            # Use the repo name (after the last /) as matrix key, replace dots with underscores for Azure DevOps compatibility
            $repoName = ($repo -split '/')[-1] -replace '\.', '_'
            $matrix[$repoName] = @{ repoFilter = $repo }
          }
          $matrixJson = $matrix | ConvertTo-Json -Compress
          Write-Host "Generated matrix: $matrixJson"
          Write-Host "##vso[task.setvariable variable=matrix;isOutput=true]$matrixJson"
        displayName: 'Generate Matrix'
        name: discoverRepos

  - job: RunRenovate
    displayName: 'Run Renovate'
    dependsOn: Discover
    pool: default
    strategy:
      maxParallel: 1
      matrix: $[ dependencies.Discover.outputs['discoverRepos.matrix'] ]
    steps:
      - checkout: self
        fetchDepth: 1
        clean: true
        persistCredentials: true
      - task: UseNode@1
        displayName: 'Use Node ${{ parameters.nodeVersion }}'
        inputs:
          version: ${{ parameters.nodeVersion }}
      - task: npmAuthenticate@0
        inputs:
          workingFile: .npmrc
      - powershell: |
          git config --global user.email 'bot@renovateapp.com'
          git config --global user.name 'Renovate Bot'
          npx --userconfig .npmrc renovate
        displayName: 'Run Renovate'
        env:
          RENOVATE_PLATFORM: "azure"
          RENOVATE_ENDPOINT: $(System.CollectionUri)
          RENOVATE_TOKEN: $(System.AccessToken)
          AZURE_DEVOPS_PAT: $(System.AccessToken)
          AZURE_DEVOPS_ORGANIZATION: $(System.CollectionUri)
          AZURE_DEVOPS_PROJECT: $(System.TeamProject)
          RENOVATE_GITHUB_COM_TOKEN: $(GITHUB_TOKEN)
          RENOVATE_AUTODISCOVER_FILTER: $(repoFilter)
          LOG_LEVEL: $(logLevel)
```

### Run strategy

We should decide how often we want to run Renovate CLI. Depending on the project size and the number of dependencies, running it too often can lead to a flood of pull requests. In our case this would also mean overloading our build agents, because every PR has a build validation configured.

A other colleague of mine, also inspired by the same pizza session, runs it every night on 3 AM. This way he gets a daily update of dependencies without overwhelming the team with PRs during working hours.

Another option is to run it hourly to catch updates as soon as possible. And rate limit the number of PRs created per hour using the `prHourlyLimit` configuration option.

> "Updates are work too, but the goal should not be to have many open pull requests. Only updates that went to production do actually prevent against a vulnerability." - Mart de Graaf, 2026

Let's refer to a book I read last year: "The Goal" by Eliyahu M. Goldratt. In this book, the author emphasizes the importance of focusing on the overall system's performance rather than individual tasks. Applying this principle to our situation, we should aim to optimize our dependency update process as a whole, rather than trying to address every single update immediately.

In a metaphor used by Goldratt, we would be busy creating inventory we cannot process, instead of focusing on the bottleneck that limits our throughput. In our case, the bottleneck is the build agent running all the validations and the team's capacity to review and merge pull requests. By controlling the flow of updates hourly, we can ensure that we are not overwhelming our system and team, thus improving our overall efficiency theoretically.

Also consider if there are multiple updates for the same repository, it could case conflicts. Renovate can rebase or merge branches automatically, but not if it runs only once a day. Then you might need to trigger renovate manually to resolve conflicts, which I think should be avoided.

### Onboarding and autodiscovery

To onboard a new repository to Renovate CLI, we can create a configuration file named `renovate.json` in the root of the repository. This file contains various settings to customize Renovate's behavior.

We want to enable autodiscovery so that Renovate can automatically detect the repositories belonging to our teams.

With these two options enabled, Renovate will scan the specified projects and repositories for dependencies and will first create a so-called onboarding PR. You can make a configuration for what your projects should look like, before it starts onboarding the repositories.

### Grouping updates

Another useful feature of Renovate CLI is the ability to group updates. This means that instead of creating a separate pull request for each dependency update, we can group them into a single pull request based on certain criteria. Extremely useful to bundle for example all @angular dependencies into a single PR.

## Limitations

- bicep registry support is limited, shameful when using AVM templates. I hope this will be improved in the future.
- .NET framework support is not working. If you are in a .NET Framework project you might consider migrating to .NET 10 already! Binding redirects are giving me bad vibes anyway.

## Conclusion and discussion

TBD First onboarding should start next week.


## Links and references

- https://docs.renovatebot.com/
- https://github.com/iverburgh/Renovate4Dotnet
