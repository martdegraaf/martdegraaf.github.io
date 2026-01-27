---
title: "Building Images Using Apko and Melange"
slug: "building-images-using-apko-and-melange"
date: 2026-01-23T00:23:15+01:00
publishdate: 2026-03-27T00:23:15+01:00
draft: true
author: ["Mart de Graaf"]
tags: ["apko", "melange", "oci", "containers", "dotnet", "devops", "docker"]
summary: "TODO You should fill this ..."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: false
ShowWordCount: true

cover:
    image: "cover.webp" # image path/url
    alt: "Building Images Using Apko and Melange" # alt text
    caption: "Building Images Using Apko and Melange" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

Let's say you want to build containers and use .NET. Where do you start? I think you will look for building somthing like a Dockerfile. But what if you want to build OCI images without Docker or Podman? In this blog post, I will explore how to build OCI images using Apko and Melange. And not only because Dockerfiles are a little scary, but also for deterministic builds and smaller, more secure images.

## Requirements

To follow along with this blog post, you will need the following tools installed on your system:

- [Apko](https://github.com/chainguard-dev/apko)
- [Melange](https://github.com/chainguard-dev/melange)

I am using a Windows 11 machine with WSL2. You can use any Linux distribution that supports Apko and Melange.

## Building OCI images

There are multiple ways to build OCI images. The most common way is using Docker or Podman with a Dockerfile. But there are other ways to build OCI images, like using Apko and Melange.

## Hardened images

TODO Uitleg over hardened images en waarom je die zou willen gebruiken. Risico's van niet hardened images.



## System context

__System explained__
```cs {linenos=table}
__insert code here__
```

## Conclusion and discussion

Should you use Apko and Melange for building OCI images? It depends on your use case. If you want to build small, secure, and deterministic images, then Apko and Melange are great tools to use. However, if you are already using Docker or Podman and are comfortable with them, then you might not need to switch.

## Links and references

- https://edu.chainguard.dev/open-source/build-tools/melange/getting-started-with-melange/