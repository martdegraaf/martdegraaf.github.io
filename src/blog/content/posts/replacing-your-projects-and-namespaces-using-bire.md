---
title: "Replacing Your Projects and Namespaces Using Bire"
slug: "replacing-your-projects-and-namespaces-using-bire"
date: 2023-01-26T22:45:56+01:00
publishdate: 2023-01-26T22:45:56+01:00
draft: true
author: ["Mart de Graaf"]
tags: []
summary: "We all sometimes want to rename projects and or namespaces but VS makes it hard, why can't we just take one command to replace all? We can with bire."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true
---

So a few years ago I worked with jlamfers. Jlamfers showed me a tool to easily replace .csproject names and namespaces. This tool is named Bire.

## Why you should care

Renaming files is hard. When renaming Projects in Visual Studio the Folder does not change and keeps its original name. The project path is declared in the Solution file (.sln). Not a problem when working in Visual Studio, but a minor annoyance when reviewing a pull request.

Also when renaming projects, not all namespaces will change as well.

## Bire

Jlamfers encountered a problem where with microservices he needed to build and the namespaces could be changed afterwards. The company used abbreviations for services, with bire he just could build and change the name afterward with a single command.

The tool of jlamfers is available at [Github jlamfers/bire](https://github.com/jlamfers/bire).

I Thought his tool was brilliant, but it missed the crucial documentation to make it understandable for the whole company.

{{< quoteblock >}}
:beer: Bire is pronaunced as the Dutch word 'Bier'. Bier is Dutch for beer. BiRe is an abbrivation for 'binary replace'.
{{</ quoteblock >}}

### Using Bire

`bire -from C:\git\source -to C:\git\target -replace this=that Something=Anything`

This is an example I wrote in the Readme file. But i want to give you a more concrete example lets imagine this folder structure. The project is in `C:\git\MyCoolProject\source`.

```text
source
 ┣ MyCoolProject.DataAccess
 ┃ ┣ ....
 ┣ MyCoolProject.DataModels
 ┃ ┣ ....
 ┣ MyCoolProject.Business
 ┃ ┣ ....
 ┣ MyCoolProject.WebApi
 ┃ ┣ ....
 ┣ MyCoolProject.Functions
 ┃ ┣ ....
 ┣ MyCoolProject.sln
```

Let's say we don't like `MyCoolProject` anymore and we want to rename it to `MCP`.

Then we can use Bire. Download the bire.exe from my [GitHub release 1](https://github.com/martdegraaf/bire/releases/tag/1.0.0).

Use the following command to get MyCoolProject abbreviated to MCP.

```cmd
`bire -from C:\git\MyCoolProject\source -replace this=that Something=Anything`
```

We're not copying the project we don't need the `-to` param. You should have your repo in git to do this change safely right?

## Ignoring the right files and file types

What if we would have certain files that would refer to MyCoolProject and we want them to stay that way instead of renaming `MyCoolProject` to `MCP`. For example a `MyCoolProjectClient.cs` class.

```cmd
`bire -from C:\git\MyCoolProject\source -replace MyCoolProject=MCP -ignore "MyCoolProjectClient.cs|(.*(\.|\/|\\)(exe|dll|obj|bin|pdb|zip|\.git|\.vs|cache|packages))$"`
```

## Conclusion

Bire helped me a lot at some companies. Let tools help you and get grip on your time back. Let me know if you have used bire and liked it.