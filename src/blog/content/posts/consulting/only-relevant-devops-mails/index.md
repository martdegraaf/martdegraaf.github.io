---
title: "Efficiently use Outlook Rules to Delete Azure DevOps Email Clutter"
slug: "filter-devops-mentions-in-outlook"
date: 2023-06-01T18:14:56+01:00
publishdate: 2023-06-01T18:14:56+01:00
draft: false
author: ["Mart de Graaf"]
tags: ["Outlook", "Azure DevOps"]
#ummary: "The text should be under 160 chars and therefore no longer than this string. Two sentences is the most effective. Or some shorter sentences after each other.1234"
summary: "Are you also annoyed by the number of emails generated by Azure DevOps? Learn how I fixed email overdose using an Outlook rule."
## Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

## Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true

series: ['Consultant tips']
---

We want to spend time on the most important things right? Are you also annoyed by the number of emails generated by Azure DevOps? See how I fixed the email overdose using an Outlook rule.

## E-mail headers

To remove all emails would be nice, but we won't see any mentions. To know how to recognize a mention email I opened a mention email.
I found the headers by clicking the three dots in the Outlook web version. And then Open the 'View' dropdown and select 'View message details'.

![Outlook web View message details](outlook-web-message-details.png#center "Outlook web - View > View message details")

We see that some headers indicate that the message trigger contained 'Mention'. This is essential information for our next steps. Here below the headers I found in the email message.

```plaintext {linenos=table}
X-VSS-Scope: organisation/project/Repository
X-VSS-Event-Type: ms.vss-mentions.identity-mention-event
X-VSS-Subscription-ID: ms.vss-mentions.identity-mention-subscription
X-VSS-Event-Initiator: Mart de Graaf
X-VSS-Event-Initiator-Ascii: Mart de Graaf
X-VSS-Event-Trigger: Mention
```

## Outlook Rules

I am not praising the Outlook client, I want to talk about the Rules feature of Outlook. The rules are found in the classic Outlook by pressing 'File' and then clicking the big 'Manage Rules & Alerts' button.
Let's create a rule to delete and mark all those emails as read. 

The first step is to define conditions. We know Azure DevOps emails from `azuredevops@microsoft.com`. For my case, I wanted to scope emails to a certain organization, which can be done by filtering specific words in the message header.
![Rule conditions](rules-step-1.png#center "Rule conditions")

---

The emails should be deleted, but also be marked as read. Nothing is more annoying than a number after your delete folder, right?
![Rule actions](rules-step-actions.png#center "Rule actions")

---

We still would like to receive the Mention emails. So we need to make an exception for them. As said earlier this can be done by filtering the message header for specific words.
![Rule exceptions](rules-step-exceptions.png#center "Rule exceptions")

---

## Full Outlook Rule

The only thing you have to edit in my example is the organisationName. 


```plaintext {linenos=table}
from azuredevops@microsoft.com
 and with VSS-Scope: organisationName
delete it
 and mark it as read
except if the message header contains 'X-VSS-Event-Trigger: Mention' or 'X-VSS-Subscription-ID: ms.vss-mentions.identity-mention-subscription'
```

---

{{< quoteblock >}}
:megaphone: Have any suggestions, I would love to hear them! 
{{</ quoteblock >}}


## Conclusion and discussion

Help yourself keep control of your inbox. I think you should work from the board and business wishes, and not from your inbox. 
