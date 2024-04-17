---
title: "Migrating Classic Azure DevOps Releases to YAML Pipelines"
slug: "migrating-classic-to-yaml-releases"
date: 2024-04-17T23:45:36+02:00
publishdate: 2024-04-17T23:45:36+02:00
draft: false
author: ["Mart de Graaf"]
tags: []
summary: "Migrate your classic releases to YAML pipelines in Azure DevOps with our comprehensive guide. Streamline your deployment process today!"
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true
---

In a previous blogpost we tackled the issue to push files and creating pull requests using Powershell. In this blog post we are going to tackle the issue of migrating classic releases to YAML pipelines in Azure DevOps. We are going to use a script to fetch current classic releases and make yaml files out of it.

{{< quoteblock >}}
:robot: Check out my previous blog to get more context: [Foreach repositories push and create a pull request]({{< ref "posts/consulting/foreach-repo-push-and-pr" >}}).
{{</ quoteblock >}}

## One script to rule them all

This thing is not a one-size-fits-all solution. This script fetches all variables and puts them in variable files for you and puts a yaml file that extends an existing template. The template is let out of scope. The script is a starting point for you to migrate your classic releases to YAML pipelines and might give you ideas and inspiration.

### Why automate

![Should we automate?](should_we_automate.jpg#center "Automation has benefits over manual work when exceeding a number of repositories.")

As visualized in the chart above we can easily calculate the time saved by automating the process. When the time of the automation is smaller than the number of repositories times the time to do it manually, we should automate. In this case, we have 60 repositories and the time to do it manually is 1 hour per repository. I set the time to automate to 32 hours. This is the time I spent on the script. The time to do it manually would be 60 hours. So we saved 28 hours by automating the process. And we can reuse the script for future migrations. Or now you can too :wink:.

## Export release and archive it

In this script, a release is fetched from Azure DevOps using the Azure DevOps REST API. The release is then exported to a yaml file and moved to an archive folder. We can use the output of this script as input for our script to push files and create a pull request.

```PowerShell {linenos=table, file=ReleaseExportAndMoveToArchive.ps1}
```

## Conclusion

We have now migrated our classic releases to YAML pipelines. We can now use the output of this script to push files and create a pull request. This way we can automate the process of updating all our repositories with the same type of change. We have saved time and can now focus on ~~browsing/chilling/netflixing~~ other tasks.
