---
title: "Golden Tips To Leave Companies Without A Nasty Smell"
slug: "job-done"
date: 2023-05-17T01:14:56+01:00
publishdate: 2023-05-17T01:14:56+01:00
draft: false
author: ["Mart de Graaf"]
tags: ["Git", "DevOps", "Azure DevOps", "Powershell"]
summary: "Leave no technical debt, clean up after yourself when leaving a company."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true

series: ['Consultant tips']
---

As a consultant when a job ends you need to transition from the previous to the next. How do you efficiently clean up all open ends? The open branches that you leave behind are sort of dead code. Nobody is going to take care of it. Make sure you don't generate more work following these tips.

## 1. No open work items

Even if you would work with Trello, it would be nice to hand over open items to coworkers. When working in Azure DevOps, you can use the following Powershell script to get all open work items assigned to you.

{{< quoteblock >}}
💬 "The first impression is just as important as the last impression. Make sure you leave a good impression." - Mart de Graaf
{{</ quoteblock >}}

```PowerShell {linenos=table,file="OpenWorkItems.ps1"}
Powershell voor ophalen openstaande work items
```

## 2. No open branches :broccoli: or pull requests

When working with Git, you can use the following Powershell script to get all open branches. You can use this script to get knowledge of all open branches or to create a pull request for each branch. The pull request can be used to hand over the work to a colleague.

```PowerShell {linenos=table,file=OpenBranches.ps1}
Powershell voor ophalen openstaande branches
```

## 3. Say goodbye

Take the time to say goodbye to your colleagues and express your gratitude for the time you spent working together. You never know when you might cross paths with them again in the future.

## 4. Get feedback

Ask for feedback from your colleagues and manager. This feedback can be used to improve yourself in the future. It can also be used to improve the company you worked for. If you don't ask for feedback, you will never know what you could have done better.

When asking for feedback keep in mind it's to improve yourself, not to get a compliment. You can ask for feedback in the following way:

{{< quoteblock >}}
💬 "What could I have done better when working together?"
{{</ quoteblock >}}



## Checklist

- :check_box_with_check: Hand over open work items
- :check_box_with_check: Delete open branches
- :check_box_with_check: Say Goodbye to your team and colleagues
- :check_box_with_check: Check for your ip whitelists in Azure DevOps

## Conclusion

When leaving a company, you want to leave no technical debt behind and clean up after yourself. You can use the scripts in this article to help you with that.

### Further reading

- https://github.com/sven73a/Powershell-Utils-Azure

