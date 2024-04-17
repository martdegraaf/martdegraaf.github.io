---
title: "Foreach repository push files and create a pull request"
slug: "foreach-repo-push-and-pr"
date: 2024-04-17T22:45:36+02:00
publishdate: 2024-04-17T22:45:36+02:00
draft: false
author: ["Mart de Graaf"]
tags: []
summary: "Automate repetitive tasks using code, even when it is in code."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true
---

For a client, we manage over 60 repositories with frontends and an API behind them. To realize some features, we need to update all repositories with the same change. That seems like a lot of work doesn't it?

## Clone 60 projects?

I talked in previous posts about automating these kinds of changes. But for this case, we don't want to clone all 60 repositories. We could go for a temp folder and clone them one by one and then clean them up. Another solution could be creating a yaml pipeline for it, that clones on the agent machine and loops over all repositories, but I wanted to keep the blame on the person of the initial change.

For this case I used GitHub copilot to help me brainstorm for solutions, another solution I did not follow was using a `$gitClient` object in Powershell.

## Push files

In the underlying script, I can create a branch from the main branch and push the contents of the readme file. This is a simple example, but it could be any file. The script can push the file to the repository and create a pull request.

```PowerShell {linenos=table, file=PushReadmeAzureDevOps.ps1}
```

## Conclusion

I am going to use this script to update files across all of our repositories. For this client, the code review is important, so the automation would end in a set pull request. In the next blog post, I am going to create a script that will create files to be pushed for every repository.
