---
title: "Clone All Git Repos from Azure Devops"
slug: "git-clone-all-repos-azure-devops"
date: 2022-11-09T01:14:56+01:00
publishdate: 2022-11-09T01:14:56+01:00
draft: true
author: ["Mart de Graaf"]
tags: ["Git"]
summary: "Learn how to get all Repos from Azure DevOps using"
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

When you are a consultant and switching to a new client. It seems handy to clone all the repositories on your first day. When you have every repo cloned, you can do whatever you're paid for.

## Configuration

```text
[General]
Url=https://dev.azure.com/MART/project
Username=me@example.com
Password= ## Use Azure Devops to generate a Personal Access Token with rights: Code: Read/Write, and Packaging: Read#

[LocalGitConfig]
GitPath=C:\Git\
OrgName=MART

[GitOptions]
PruneLocalBranches=true
```

## The script

The PowerShell script below does a `git pull` for existing repositories and performs a `git clone` on untracked repositories. __System explained__

```ps1 {linenos=table}  
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

        if($pruneLocalBranches){
            git remote prune origin
            # this command removes all merged local branches
            git branch --merged | grep -v "master" >/tmp/merged-branches && vi /tmp/merged-branches && xargs git branch -d </tmp/merged-branches
        }
        set-location $initpath
    }
}

(az repos list --query '[].{Name:name, Url:remoteUrl}' -o json | ConvertFrom-Json) | %{ git clone $_.Url }
```

## Conclusion and discussion

__Solution explained__
Make your workflow faster with scripting and your knowledge of the Git CLI. When you have to do repetitive tasks such as updating a single package on multiple (microservice-like) repositories, try to automate it. It may for the first occurrence not be profitable, but after three times, you will be faster than doing it manually.
