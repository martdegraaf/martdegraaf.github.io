---
title: "Copier as Boilerplate Tool"
slug: "copier-as-boilerplate-tool"
date: 2025-03-19T17:37:16+01:00
publishdate: 2025-03-19T17:37:16+01:00
draft: true
author: ["Mart de Graaf"]
tags: []
summary: "Read how i use Copier as a boilerplate tool to create new projects based on existing projects."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true

cover:
    image: "cover.webp" # image path/url
    alt: "Mart de Graaf - cartoon style." # alt text
    caption: "Mart de Graaf - cartoon style." # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

For .NET you have the `dotnet new` command to create a new project. But what if you want to create a new project based on an existing project? This post will show you how to use Copier as a boilerplate tool.

For Angular i created a BIG Node script to create angular projects from scratch, but it was a pain to maintain. When i found Copier i was amazed how easy it was to create a new project based on an existing project.

## What is Copier?

Copier is a command-line tool that helps you copy files from one place to another. It is a simple tool that can help you create a new project based on an existing project.

## How to use Copier?

You will need to install Python because it runs on Python.

Install python via chocolatey:

```bash
choco install python
```

To use Copier, you need to install it first. You can install Copier via pip:

```bash
pip install copier
```

After you have installed Copier, you can use it to copy files from one place to another. Here is an example of how you can use Copier to create a new project based on an existing project:

```bash
copier copy path/to/boilerplate path/to/new/project --trust
```

This command will copy all the files from the `path/to/boilerplate` directory to the `path/to/new/project` directory.

## Configuration

Let's discuss some configurations i used in my first project.

### `copier.yml`

The `copier.yml` file is a configuration file that tells Copier how to copy files from one place to another. Here is an example of a `copier.yml` file:

```yaml
# This is a comment
variables:
  project_name: "My Project"
  author_name: "John Doe"
  author_email: "
    project_description: "This is my project"
    project_url: "https://example.com"
    project_license: "MIT"
    project_version: "0.1.0"

# This is a comment
```

### .copier-answers.yml

The `.copier-answers.yml` file is a file that contains the answers to the questions that Copier asks when copying files from one place to another. You have to create this file yourself in your template.

### Copy from remote

You may want to copy files from a remote repository. You can do this by using the `git+` prefix in the `copier.yml` file. Here is an example of how you can copy files from a remote repository:

```yaml
# This is a comment
files:
  - src: "git+

```


## Some pains

It's not easy to regonize the difference between tasks and migrations. 

## Conclusion

Copier is a simple tool that can help you create a new project based on an existing project. It is a handy tool to have in your toolbox when you need to create a new project quickly.
