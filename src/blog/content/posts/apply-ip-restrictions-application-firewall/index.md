---
title: "Apply Ip Restrictions Application Firewall"
slug: "apply-ip-restrictions-application-firewall"
date: 2024-05-15T18:09:39+02:00
publishdate: 2024-05-15T18:09:39+02:00
draft: true
author: ["Mart de Graaf"]
tags: []
summary: "How to restrict access to your backend services using an Azure Application Gateway and a Web Application Firewall policy. This post will show you how to add custom rules to your WAF-policy to restrict access to your backend services by IP address"
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

Let's say you have an application gateway deployed in Azure. Behind the application gateway are more than one backend services acting on requests for your costumers.

![Architecture of an application gatway in front of multiple app services](appgateway.drawio.svg#center "Example Azure infrastructure")

## Restricting access

When you want to release new code to production but still want it not exposed to the outside world, you can restrict access to the backend services by IP. This can be done by adding custom rules to your web application firewall policy (also known as a WAF-policy).

### Adding custom rules in the portal

In the Azure portal, you can add custom rules to your WAF-policy. This can be done by navigating to the WAF-policy and selecting the `Custom rules` blade. Here you can add a new rule and select the action you want to take when the rule is matched. This gave the insights of the capabilities of the WAF-policy custom rules.

<!-- todo image here -->

### Defining a custom type

Let's use custom types to give ourselves a better intellisense when configuring the parameters.

```bicep {linenos=table,file="WAFPolicyExclusions.bicep",fileLines="1-6"}
```

### Parameters

To use the custom type we need to define a parameter using the `restrictedDomain` type. To always allow a set of IP addresses we will add a `defaultAllowedIPs` array parameter. Those will be unioned with the ones given for a specific domain.

```bicep {linenos=table,file="WAFPolicyExclusions.bicep",fileLines="11-14"}
```

### Custom rules

Within the WAF-policy resource we can provide custom rules. To do so we use the a for loop. The for loop loops over all `restrictedDomains` to add a custom rule for each domain.

The default action for this rule will be block, we want to block access to a domain _except_ for the allowed IP addresses.

#### Condition 1 Domain

For the first condition, we will add a rule that matches the `Host` in the `RequestHeaders`, this has to match the given domain. I chose for `BeginsWith` because I would not want people to make mistakes and possibly take down all domains.


#### Condition 2 RemoteAddr

For the second condition, we will add a rule that matches the `RemoteAddr`, this has to **NOT** match the given IP addresses. I chose for `BeginsWith` because I would not want people to make mistakes and possibly take down all domains.
please note the `negationConditon: true` to make sure the rule is matched when the IP address is **not** in the list.

```bicep {linenos=table,file="WAFPolicyExclusions.bicep",fileLines="21-55"}
```

## Lessons learned

While building wasn't difficult, I learned two things that I want to share with you.

1. The name of the rule has to be unique.
1. The priority must be unique and can only be a value between 1 and 100.

This also means you only can have 100 custom rules in a WAF policy. This is a limitation you have to take into account when designing your solution.

## Full Solution

Here's a full bicep file with the custom type, parameters, and custom rules.

```bicep {linenos=table,file="WAFPolicyExclusions.bicep"}
```

And of course an example bicep parameters file.

```bicep {linenos=table,file="WAFPolicyExclusions.bicepparam"}
```

## Conclusion and discussion

The application gateway can be used to restrict access to your backend services. This can be done by adding custom rules to your WAF-policy. Keep in mind that this has some limits.
