---
title: "Apply Ip Restrictions Application Firewall"
slug: "apply-ip-restrictions-application-firewall"
date: 2024-05-17T18:09:39+02:00
publishdate: 2024-05-17T18:09:39+02:00
draft: false
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
    alt: "A modern, clean tech-themed cover image with a blue color scheme. The image features a digital wall composed of glowing blue circuitry patterns, symbolizing protection. Behind this digital wall, there is a crown, glowing with a soft blue light, representing an application firewall." # alt text
    # caption: "" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

Let's say you have an application gateway deployed in Azure. Behind the application gateway is more than one app service acting on requests. You are adding a new application and the new application needs to be ready before GO-live. You can not pre-test this on production without any sort of firewall rules. You want to restrict access to the new application to a set of IP addresses.

In this post, I will show you how to restrict access to your backend services using a Web Application Firewall policy. We will build a bicep file with my first production custom type!

![Architecture of an application gateway in front of multiple app services](appgateway.drawio.svg#center "Example Azure infrastructure")

## Restricting access

When you want to release new code to production but still want it not exposed to the outside world, you can restrict access to the backend services by IP. This can be done by adding custom rules to your web application firewall policy (also known as a WAF-policy).

### Adding custom rules in the portal

In the Azure portal, you can add custom rules to your WAF-policy. This can be done by navigating to the WAF-policy and selecting the `Custom rules` blade. Here you can add a new rule and select the action you want to take when the rule is matched. This gave insights into the capabilities of the WAF-policy custom rules.

![Showing custom policies of a WAF policy in the Azure Portal](application-gateway-portal.png#center "Custom policies of a WAF policy in the Azure Portal")

### Defining a custom type

Let's use custom types to give ourselves a better intellisense when configuring the parameters.

```bicep {linenos=table,file="WAFPolicyExclusions.bicep",fileLines="1-6"}
```

### Parameters

To use the custom type we need to define a parameter using the `restrictedDomain` type. To always allow a set of IP addresses we will add a `defaultAllowedIPs` array parameter. Those will be unioned with the ones given for a specific domain.

```bicep {linenos=table,file="WAFPolicyExclusions.bicep",fileLines="11-14"}
```

### Custom rules

Within the WAF-policy resource, we can provide custom rules. To do so we use the a for loop. The for loop loops over all `restrictedDomains` to add a custom rule for each domain.

The default action for this rule will be block, we want to block access to a domain _except_ for the allowed IP addresses.

#### Condition 1 - Does the domain match

For the first condition, we will add a rule that matches the `Host` in the `RequestHeaders`, this has to match the given domain. I chose for `BeginsWith` because I would not want people to make mistakes and possibly take down all domains.

#### Condition 2 - Is the IP address in the whitelist?

For the second condition, we will add a rule that matches the `RemoteAddr`, this has to **NOT** match the given IP addresses.
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

### Deploying

The only thing to do now is to deploy the bicep files. When you want to enable access to a certain domain you can remove the domain from the parameters file. In this specific case, the application gateway was used for multiple domains and many web applications. Therefore it was easier to restrict access to a specific domain on the WAF-policy. This can be different for your specific use case.

## Conclusion and discussion

The application gateway can be used to restrict access to your backend services. This can be done by adding custom rules to your WAF-policy. Keep in mind that this has some limits.


### References

- https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/custom-waf-rules-overview
- https://alanta.nl/posts/2021/04/manage-waf-rules-for-appgateway
