---
title: "{{ replace .Name "-" " " | title }}"
slug: "{{lower (replace .Name " " "-") }}"
date: {{ .Date }}
publishdate: {{ .Date }}
draft: true
author: ["Mart de Graaf"]
tags: ["code", "csharp"]
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
    alt: "{{ replace .Name "-" " " | title }}" # alt text
    caption: "{{ replace .Name "-" " " | title }}" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

__Intro to the problem__

## System context

__System explained__
```cs {linenos=table}
__insert code here__
```

## Solution

__Solution explained__
```cs {linenos=table}
__insert code here__
```

## Conclusion and discussion

__Solution explained__
```cs {linenos=table}
__insert code here__
```
