---
title: "Study Notes AZ-500"
slug: "study-notes-az500"
date: 2022-12-05T21:16:24+01:00
draft: true
author: ["Mart de Graaf"]
tags: []
summary: "I failed my first attempt making the AZ-500 exam. In this article i make notes about the missing knowledge i had in my first exam."

#[Toc]
ShowToc: true
TocOpen: true
UseHugoToc: false

#[MetaSettings]
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true
---

I studied for AZ-500 using the MS Learning paths referenced on the [AZ-500 page](https://learn.microsoft.com/en-us/certifications/exams/az-500). I completed reading them however I skipped some of the practical exercises.

On the 5th of December, I took the AZ-500 exam and failed. I scored 588 points, 700 points will get you to pass. So it was not close, I needed to study and know more. Many questions were too difficult for me. This article is a notebook of my extra learnings and study material I needed to complete for AZ-500.

On the 19th of January, I retook the AZ-500 exam and failed again. Now I scored 684 points. This was closer and very frustrating. But, on the positive side, I have a positive trend in my results.

## First things first

I am a developer scoped to PaaS services so things like Azure storage and Azure KeyVault make sense to me. Azure AD and Virtual machines are not my daily work, but I would like to know the ins and outs.

## Online resources

Resources I needed to review and read again.

- [Azure Monitor - Alerts](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview)
- [Azure Policy Effects](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effects)
- [Azure VirtualMachine JIT access](https://learn.microsoft.com/en-us/azure/defender-for-cloud/just-in-time-access-usage?tabs=jit-config-asc%2Cjit-request-asc)

- [Azure Monitor - Virtual Machine](https://learn.microsoft.com/en-us/azure/azure-monitor//vm/monitor-virtual-machine)
- [Azure Blueprints](https://learn.microsoft.com/en-us/azure/governance/blueprints/overview)
- [Azure Storage SAS](https://learn.microsoft.com/en-us/azure/storage/common/storage-sas-overview)

## Azure Roles

I did struggle with what roles applied to what actions. I summed up some links here where built-in roles are documented.

- [Azure KeyVault](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli)
- [Azure KeyVault RBAC mapping](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-migration#access-policy-templates-to-azure-roles-mapping)
- a

Roles in AAD

- https://stackoverflow.com/questions/69077796/restrict-azure-active-directory-access-by-cloning-built-in-roles-and-using-roles
- https://learn.microsoft.com/en-us/azure/active-directory/roles/custom-create
- https://learn.microsoft.com/en-us/azure/active-directory/roles/custom-create#create-a-new-custom-role-to-grant-access-to-manage-app-registrations
- https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-template

## Notes Application insights session

- https://www.thomsip.net/articles/azure-application-insights-cheat-sheet
- https://learn.microsoft.com/en-us/azure/network-watcher/network-insights-overview

# note to self

- https://learn.microsoft.com/en-us/dotnet/core/extensions/queue-service


## Conditional access

https://learn.microsoft.com/en-us/azure/active-directory/identity-protection/overview-identity-protection

|Event|Risk level|
|--|--|
|User with leaked credentialsa|High|
|Sign-ins from anonymous IP adresses|Medium|
|Impossible travels to atypical locations|Medium|
|Sign-ins from unfamiliar location|Medium|
|Sign-ins from infected devices|Low|


https://docs.microsoft.com/en-us/azure/security/fundamentals/choose-ad-authn
https://learn.microsoft.com/en-us/azure/active-directory/hybrid/choose-ad-authn



wmlock
grouplock


SLB => Standard Load Balancer => Altijd nodig bij een Private Link.


Ping => IMCP Protocol <> TCP Protocol.


# User defined route
https://docs.microsoft.com/en-us/azure/virtual-network/tutorial-create-route-table-portal


```cli
az aks update \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --enable-pod-security-policy
```

# Network watcher

https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-packet-capture-overview


STRIDE framework


Contributer role geeft je geen toegang tot het beheren van RBAC
`Security Admin` role geeft rechten tot Microsoft Defender for Cloud.


