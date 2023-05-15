---
title: "Efficiently Git Clone All Repositories from Azure DevOps using PowerShell: A Step-by-Step Guide"
slug: "git-clone-all-repos-azure-devops"
date: 2023-04-28T18:14:56+01:00
publishdate: 2023-04-28T18:14:56+01:00
draft: true
author: ["Mart de Graaf"]
tags: ["Git", "Powershell", "Azure DevOps"]
summary: "Learn how to clone all Repos from Azure DevOps using PowerShell"
## Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

## Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true

series: ['Consultant tips']
---

As a consultant, starting a new project with a client can be a daunting task. One way to make the transition smoother is by cloning all the repositories on your first day. This allows you to have quick access to all the necessary files and resources, enabling you to perform your job efficiently and effectively. In this blog post, we will explore the benefits of cloning repositories, a script for doing so, and some common pitfalls to avoid.

[Skip to the code sample](#code)

## Organizing your Git repos

When working for multiple clients or even just having private projects next to your client projects it can come in handy to organize your git repositories. For some Frontend repositories, the path with node_modules was too long and that forced me to place my folders on the Disk level. A path for a project for me would look like `C:\Git\{ClientName}\{RepositoryName}`.

```text
C:\Git
 ┣ Client1
 ┃ ┣ Client1.Repository1
 ┃ ┣ Client1.Repository2
 ┃ ┗ Client1.Repository3
 ┣ Client2
 ┃ ┣ Client2.Repository1
 ┃ ┗ Client2.Repository2
 ┗ private
 ┃ ┣ Blog
 ┃ ┗ Demo
```

### Using workspaces in Git Fork

Fork is a tool that will help you focus on the right workload. Using the structure as discussed with Fork, you can focus on the right repositories. Cloned new repositories but not seen by Fork? Reload the whole folder using right-click and 'Rescan repositories'. Get Git Fork from [git-fork.com](https://git-fork.com/).

![Fork Repository Manager](fork_repository_manager.png#center "Fork Repository Manager")

Use Fork Workspaces to focus on the current environment. It will also help you work on private projects outside of work hours on the same workstation.

![Fork Workspaces](fork_workspaces.png#center "Fork workspaces")

### Configure your git username

Depending on the network infra, you will need to configure your commit username to the email of your client.
Some instances block all git pushes from committers with a different domain.

```console
git config [--global] user.email "username@corperate.com"
```

In the script to clone all repositories, you can also enable the script to set the committer email for every repository.

## Code

To clone all repositories in Azure DevOps we can use the REST API to find all existing repositories. The code example consists of a Powershell script and a configuration file with settings and Authorization.

### Configuration

Make sure to create a file named: `CloneAllRepos.config` with the contents written below. Make sure every parameter is configured as your workspace.

```text {linenos=table}
[General]
Url=https://dev.azure.com/MART/project
Username=me@example.com
Password= ## Use Azure Devops to generate a Personal Access Token with rights: Code: Read/Write, and Packaging: Read#

[LocalGitConfig]
GitPath=C:\Git\
OrgName=MART

[GitOptions]
PruneRemoteBranches=false # Optional defaults to false
PruneLocalBranches=false # Optional defaults to false
GitEmail=username@corperate.com
```

### CloneAllRepos.ps1

When I first encountered the idea to clone all repos idea it was on a corporate wiki. After some backtracing, I found the source: [Script to clone all Git repositories from your Azure DevOps collection](https://blog.rsuter.com/script-to-clone-all-git-repositories-from-your-vsts-collection/).

The PowerShell script below does a `git pull` for existing repositories and performs a `git clone` on untracked repositories.

I edited the script to fit my needs with some extra parameters.

1. It puts the repos in the given directory in settings.
1. It prunes local branches when `PruneLocalBranches` is set to true.
1. It sets the git username email to the configured `GitUsername` under GitOptions, it's ignored when empty.

{{< highlight powershell "linenos=table" >}}
# Read configuration file
Get-Content "CloneAllRepos.config" | foreach-object -begin {$h=@{}} -process { 
    $k = [regex]::split($_,'='); 
    if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { 
        $h.Add($k[0], $k[1]) 
    } 
}
#AzDO config
$url = $h.Get_Item("Url")
$username = $h.Get_Item("Username")
$password = $h.Get_Item("Password")
# LocalGitConfig
$gitPath = $h.Get_Item("GitPath")
$orgName = $h.Get_Item("OrgName")
$pruneLocalBranches = $h.Get_Item("PruneLocalBranches") -eq "true"
$gitEmail = $h.Get_Item("GitEmail")

# Retrieve list of all repositories
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))
$headers = @{
    "Authorization" = ("Basic {0}" -f $base64AuthInfo)
    "Accept" = "application/json"
}

Add-Type -AssemblyName System.Web
$gitcred = ("{0}:{1}" -f  [System.Web.HttpUtility]::UrlEncode($username),$password)

$resp = Invoke-WebRequest -Headers $headers -Uri ("{0}/_apis/git/repositories?api-version=1.0" -f $url)
$json = convertFrom-JSON $resp.Content

# Clone or pull all repositories
$initpath =  ("{0}:{1}" -f  $gitPath,$orgName)

foreach ($entry in $json.value) { 
    $name = $entry.name 
    Write-Host $name

    $url = $entry.remoteUrl #-replace "://", ("://{0}@" -f $gitcred)
    if(!(Test-Path -Path $name)) {
        git clone $url
    } else {
        set-location $name
        git pull

        $branchname = git remote show origin | grep 'HEAD branch' | cut -d' ' -f5

        if($pruneRemoteBranches){
			Write-Host "Pruning remote $name"
            git remote prune origin
		}
        if($pruneLocalBranches){
			Write-Host "Pruning local branches $name"
            # this command removes all merged local branches
            git branch --merged | ? { $_ -notlike "*master" } | Out-File -FilePath "/tmp/merged-branches" -Encoding utf8; vi /tmp/merged-branches; Get-Content "/tmp/merged-branches" | %{ git branch -d $_ }
        }
        if($gitEmail){
            git config user.email "$gitEmail"
        }
        set-location $initpath
    }
}

(az repos list --query '[].{Name:name, Url:remoteUrl}' -o json | ConvertFrom-Json) | %{ git clone $_.Url }
{{< / highlight >}}

### Run it

Run the script it using a PowerShell prompt for example using Windows Terminal.

```PowerShell
./CloneAllRepos.ps1
```

## Using scripting for common tasks

In the world of microservices, we choose to duplicate some of the plumbing. When you want to change multiple repos knowledge on scripting can be helpful. In this series, I explored how to automate git tasks with PowerShell.

Some examples are:

- Updating multiple NuGet packages.
- Enforcing certain `Nuget.config` configurations.
- Renaming business terminology on multiple branches.

### Automating

With this structure, you could automate actions over multiple repositories. In the code below I wrote an example of automating script for changing the Nuget.config file in every repository. If your packages have the same layout changes can be done easier and faster. Also, please check out [my article using binary replace]({{< ref "replacing-your-projects-and-namespaces-using-bire.md" >}}).

```PowerShell {linenos=table}
git checkout main
git pull
git checkout -b fix/nugetconfig

# DO NECESSARY CHANGE in nuget.config.

git mv -f NuGet.config nuget.config
git add *

git commit -m "Only use private Nuget upstream"
git push --set-upstream origin fix/nugetconfig
git checkout main
```

## Conclusion and discussion

Make your workflow faster with scripting and your knowledge of the Git CLI. When you have to do repetitive tasks such as updating a single package on multiple (microservice-like) repositories, try to automate it. It may for the first occurrence not be profitable, but after three times, you will be faster than doing it manually.
