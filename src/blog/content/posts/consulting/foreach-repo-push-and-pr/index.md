---
title: "Foreach repository push files and create a pull request"
slug: "foreach-repo-push-and-pr"
date: 2024-04-17T22:45:36+02:00
publishdate: 2024-04-17T22:45:36+02:00
draft: false
author: ["Mart de Graaf"]
tags: []
summary: "Automate repetitive tasks using code, even when its in code."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true
---

For a client we manage for over 60 repositories with frontends and an api behind it. To realise some features, we need to update all repositories with the same change. That seems like a lot of work doesnt it?

## 

I talked in previous posts about automating these kinds of changes. But for this case we dont want to clone all 60 repositories. We could go for a temp folder and clone them one by one and then clean them up. Another solution could be creating a yaml pipeline for it, that clones on the agent machine and loops over all repositories, but i wanted to keep the blame to the person of the initial change.

