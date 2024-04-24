---
title: "Efficiently Git Clone All Repositories from Azure DevOps using PowerShell: A Step-by-Step Guide"
slug: "git-clone-all-repos-azure-devops"
date: 2023-05-15T18:14:56+01:00
publishdate: 2023-05-15T18:14:56+01:00
draft: false
author: ["Mart de Graaf"]
tags: ["Git", "Powershell", "Azure DevOps"]
#ummary: "The text should be under 160 chars and therefore no longer than this string. Two senteces is the most effective. Or some shorter sentences after each other.1234"
summary: "Learn how to efficiently clone all Git repos in Azure DevOps with our comprehensive consulting guide. Streamline your development workflow today!"
## Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

## Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true

series: ['Consultant tips']

cover:
    image: "cover.webp" # image path/url
    alt: "A digital workspace with multiple computer screens displaying code and command lines." # alt text
    caption: "A digital workspace with multiple computer screens displaying code and command lines." # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

As a consultant, starting a new project with a client can be a daunting task. One way to make the transition smoother is by cloning all the repositories on your first day. This allows you to have quick access to all the necessary files and resources, enabling you to perform your job efficiently and effectively. In this blog post, we will explore the benefits of cloning repositories, a script for doing so, and some common pitfalls to avoid.

[Skip to the code sample](#configuration)

## Organizing your Git repos

When working for multiple clients or even just having private projects next to your client projects it can come in handy to organize your git repositories. For some Frontend repositories, the path with node_modules was too long and that forced me to place my folders on the Disk level. A path for a project for me would look like `C:\Git\{ClientName}\{RepositoryName}`.

```plaintext {linenos=table}
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

Use Fork Workspaces to focus on the current environment. It will also help you work on private projects outside of work hours on the same workstation. You can also create workspaces for different domains or teams if you are for example the lead or architect in a project.

![Fork Workspaces](fork_workspaces.png#center "Fork workspaces")

### Configure your git username

Depending on the network infra, you will need to configure your commit username to the email of your client.
Some instances block all git pushes from committers with a different domain.

```console {linenos=table}
git config [--global] user.email "username@corperate.com"
```

In the script to clone all repositories, you can also enable the script to set the committer email for every repository.

## Clone all repositories

To clone all repositories in Azure DevOps we can use the REST API to find all existing repositories. The code example consists of a Powershell script and a configuration file with settings and Authorization.

### Configuration

Make sure to create a file named: `CloneAllRepos.config` with the contents written below. Make sure every parameter is configured as your workspace.

```cfg {linenos=table,file=CloneAllRepos.config}
```

{{< quoteblock >}}
:bulb: ~~Don't know where to find a Personal Access Token in Azure DevOps? Read: [Microsoft's docs on personal access tokens](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate).~~

On 2024 april 17, I updated the script to get an access token using the current session of the az cli. see [Azure DevOps API Authentication](https://learn.microsoft.com/en-us/azure/devops/integrate/get-started/authentication/service-principal-managed-identity?toc=%2Fazure%2Fdevops%2Forganizations%2Fsecurity%2Ftoc.json&view=azure-devops#q-can-i-use-a-service-principal-or-managed-identity-with-azure-cli).
{{</ quoteblock >}}

### CloneAllRepos.ps1

When I first encountered the idea to clone all repos idea it was on a corporate wiki. After some backtracing, I found the source: [Script to clone all Git repositories from your Azure DevOps collection](https://blog.rsuter.com/script-to-clone-all-git-repositories-from-your-vsts-collection/).

The PowerShell script below does a `git pull` for existing repositories and performs a `git clone` on untracked repositories.

I edited the script to fit my needs with some extra parameters.

1. It puts the repos in the given directory in settings.
1. It prunes local branches when `PruneLocalBranches` is set to true.
1. It sets the git username email to the configured `GitUsername` under GitOptions, it's ignored when empty.

```PowerShell {linenos=table, file=CloneAllRepos.ps1}
```

{{< quoteblock >}}
:robot: If you have some additional ideas, let ChatGPT help you. Supply ChatGPt with the context: `Rewrite this PowerShell script to also <insert new Feature>. Here is the current version of the PowerShell script: <insert PowerShell script>.`. Let me know if you thought of a clever solution.
{{</ quoteblock >}}

### Run it

Run the script it using a PowerShell prompt for example using for example Windows Terminal.

```PowerShell {linenos=table}
./CloneAllRepos.ps1
```

## Using scripting for common tasks

In the world of microservices, we choose to duplicate some of the plumbing. When you want to change multiple repos knowledge on scripting can be helpful. In this series, I explored how to automate git tasks with PowerShell.

Some examples are:

- Updating multiple NuGet packages.
- Enforcing certain `Nuget.` `config` configurations.
- Renaming business terminology on multiple branches.

### Automating

With this structure, you could automate actions over multiple repositories. In the code below I wrote an example of automating script for changing the Nuget.config file in every repository. If your packages have the same layout changes can be done easier and faster. Also, please check out [my article using binary replace]({{< ref "replacing-your-projects-and-namespaces-using-bire.md" >}}).

```PowerShell {linenos=table}
git checkout main
git pull
git checkout -b fix/nugetconfig

# DO THE NECESSARY CHANGE in nuget.config.

git mv -f NuGet.config nuget.config
git add *

git commit -m "Only use private Nuget upstream"
git push --set-upstream origin fix/nugetconfig
git checkout main
```

## Conclusion and discussion

Make your workflow faster with scripting and your knowledge of the Git CLI. When you have to do repetitive tasks such as updating a single package on multiple (microservice-like) repositories, try to automate it. It may for the first occurrence not be profitable, but after three times, you will be faster than doing it manually. It can also help you clean up your workspace and be more tidy.
