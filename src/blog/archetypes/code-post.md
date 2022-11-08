---
title: "{{ replace .Name "-" " " | title }}"
slug: "{{lower (replace .Name " " "-") }}"
date: {{ .Date }}
publishdate: {{ .Date }}
draft: true
author: ["Mart de Graaf"]
tags: []
summary: "TODO You should fill this ..."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true
---

__Intro to the problem__

# System context
__System explained__
```cs {linenos=table}
__insert code here__
```

# Solution
__Solution explained__
```cs {linenos=table}
__insert code here__
```

# Conclusion and discussion
__Solution explained__
```cs {linenos=table}
__insert code here__
```
