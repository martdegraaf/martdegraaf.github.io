---
title: "Techorama 2025 notes and personal learnings"
slug: "2025"
date: 2025-10-30T22:13:48+01:00
publishdate: 2025-10-30T22:13:48+01:00
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

cover:
    image: "cover.webp" # image path/url
    alt: "Mart de Graaf - cartoon style." # alt text
    caption: "Mart de Graaf - cartoon style." # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

__Intro to the problem__

## Tuesday

My Tuesday started with a carpool with my colleague. We drove to Utrecht but came stuck in traffic unfortunately missed the opening keynote. For this day my tactic was to avoid AI talks, and choose on the last second what session to attend.

### Sessions attended on tuesday

1. **How building a portable escape room made me a better developer** by William Brander
**Session abstract:** *"I built a portable IoT escape room, and it changed how I think about development! In this session, we'll uncover unexpected parallels between escape rooms and architecting resilient, scalable systems. Let me share the lessons learned, and how they translate into invaluable guidance for Domain-Driven Design (DDD), modularity, communication, scalability and fault tolerance. Doors will be unlocked at the end - even if the audience can't solve the puzzles."*
   - Key takeaways:
     - Monitoring distributed systems can be devided into 3 piramids: Monitoring Area, Conitoring Concern and Interaction Type.
       - Monitoring Area
         - Infrastructure
         - Application
         - Capability
       - Monitoring Area
         - Health
         - Performance
         - Capacity
       - Interaction Type
         - Passive
         - Reactive
         - Proactive
     - If you build systems with joy, it will be reflected in the end product.
     - William showed us his remote escape room, which was really cool.

2. **Creating an observable cloud platform and application landscape with Azure** by Alex Thissen
**Session abstract:** *"In this session you will learn how to build and create a cloud platform for your applications that offers observability and monitoring capabilities. You are going to be introduced to the Azure resources for monitoring and operations and learn how to architect the landscape for multiple applications and business domains. Also, we will have a look at instrumenting applications with OpenTelemetry and the various patterns and practices to collect, filter and combine telemetry signals into an observable backplane. Combined with the Azure resources, the outcome is an environment that is capable to host, monitor and operate observable applications. You will see how this can help you in everyday situations in getting insights into and gaining control over your cloud-native applications running in Azure."*
   - Key takeaways:
     - Alex explained perfectly what the difference is between Azure monitor and a log analytics workspace.
         - Azure Monitor is the overall service that provides a unified monitoring solution for your applications and resources in Azure. It collects, analyzes, and acts on telemetry data from various sources to help you understand the performance and health of your applications. *It is managed by Azure*.
         - Log Analytics Workspace is a specific component within Azure Monitor that serves as a centralized repository for storing and analyzing log data. It allows you to run queries, create visualizations, and set up alerts based on the collected log data.
     - Alex tought the eye opener was that you can view your application insights and log analytics workspace in the Azure Data Explorer. I am not really sure why this is a big advantage, but I will explore this further.
     - Alex explained that the log Analytics workspace should be a shared resource for multiple applications. This could even be in the hub environment of a landing zone.
     - There is also an Kusto Explorer available at https://aka.ms/kustoexplorer which is a desktop application to query Kusto databases. I have to try this out.
     - Alex showed a new feature Health Monitoring in Azure. This is a feature to monitor the health of your applications. It is possible to build a Health Model to show the health if dependencies are not healthy.
   
3. **Delivering on Identity Solutions - practical guidance and pitfalls to avoid** by Michele Leroux Bustamante
**Session abstract:** *"Identity is a critical part to any solution - whether that solution is deployed on premises or to a cloud provider. The challenge most organizations have is lack of deep expertise with identity protocols, authentication techniques and standards, associated use cases and solution design, user management and user self-service lifecycles and the recommended best practices and necessary threat modeling to deliver a solution to production. Even when using a hosted identity provider, you are not excused from understanding how applications integrate with that provider and participate in the holistic solution, and you typically also need to build significant custom work around the user lifecycle which should also follow recommended best practices that aren’t always obvious. In this session, Michele will share recommended best practices for identity solution design and delivery, drawing examples from experience with actual customer solutions with varying requirements. The goal is to educate you on common and practical ways to approach the identity solution design while adhering to recommended best practices. You’ll get an overview of critical protocol flows, the evolving preference for SPA / BFF patterns for application integration, the challenges that arise when you let identity become “too custom” and how this impacts your choice of identity platform framework or vendor."*
   - Key takeaways:
     - Every flow is deprecated except the authorization code flow with PKCE. So you should use Backends for Frontends (BFF) architecture.
     - Use no tokens in the browser. Store them in a secure cookie or use session storage.
     - Some banks do actually have access token valid for 30 days for some reason. Michele does not bank there :).
     - When you combine social with enterprise logins you have to be carefull with account linking. You don't want that a user can link his social account to an enterprise account without verification.
     - She explained Gateway federation, wich i am familiar with. This makes use of Home realm discovery.
     - Buying some tool like Auth0 is not enough, you still have to understand identity.

4. **Top 5 techniques for building the worst microservice system ever** by William Brander
**Session abstract:** *"Microservices come with promises of scalability, reliability, and autonomy. But if everything is so rosy, how come the only success stories we hear about are at places like Netflix or Uber? I've spent countless hours working on all kinds of microservice systems to come up with the definitive top 5 tips to ensure your microservices become complete disasters. Join me on a tour of insanity through some of the worst ways to make distributed mistakes."*
    - Key takeaways:
      - I think i identify with Dough the dog in the Pixar movie Up, because i am just as destracted as he is.
      - Five techniques to build a bad microservice architecture:
        1. Put an HTTP call in front of everything
        2. Do a big bang rewrite
        3. Don't use off the shelf frameworks
        4. Use Nouns instead of Verbs for service boundaries
        5. Conflate the logical with deployment boundaries
      - He explained that you should avoid these anti patterns to build a successful microservice architecture.

5. **C# 11 + .NET 7** by Stefan Pölz
**Session abstract:** *"Although we are capable of overloading operators for owned types with traditional C#, we cannot define generic mathematical algorithms that may be consumed by multiple types of the .NET ecosystem. Previewed in .NET 6, November 2022 marked the release of Generic Math in .NET 7. New language features of C# 11 enable both Microsoft's BCL team and the community to ship powerful mathematical operations in data types and generic interfaces. These result in algorithms that supersede repetitive concepts, such as System.Math and System.MathF. Alongside exploring these additions to .NET, we'll assemble our own custom type with calculations that utilizes Generic Math."*
   - Key takeaways:
     - Stefan explained all types have interfaces for math operations now. For example `IAdditionOperators<TSelf, TOther, TResult>`.
     - https://github.com/Flash0ver
     - Cool example is that he could calculate with custom types like Bytes Gigabytes and Terabyte, all in one type.

     
5. **What's new in C# 13, 14, and beyond?** by Bart de Smet
**Session abstract:** *"Come and catch up on the most recent C# language evolution and a peek into the future. We'll start this talk by looking at various enhancements to existing language features, such as params collections, improvements to the lock statement, null-conditional assignment, the new field keyword, and various restrictions that have been lifted around the use of ref structs. Next, we'll have an in-depth overview of the new extension member support, finally enabling extension properties and indexers. To finish the talk, we'll look at brand new features slated for upcoming versions, such as dictionary expressions, union types, and more."*
   - Key takeaways:
     - the extension members are coming to C# 13. This makes it possible to add methods to existing types without modifying their source code.
     - Some things are improved to get a Span<T> in a params array.
     - Null-conditional assignment in C# 14: `customer?.Order = GetOrder();`

https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-13

https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-14

## Wednesday

Wednesday was starting early, we had to vote for the Dutch elections first before going to the conference center. After that I attended the following sessions.

1. **Kafka for .NET Developers** by Ian Cooper
**Session abstract:** *"Kafka is a low-latency streaming solution with a rich ecosystem of tools such as Kafka Connect and Flink, but is less well-known to .NET developers. In this session we will introduce Kafka, explaining the mysteries of records, offsets, SerDes and schema registries, in-sync replicas, partitions and tools like Connect and Flink. There will be code, as we work with examples in .NET of using as a messaging solution in your applications. By the end of this session you should feel comfortable with the concepts required to use Kafka as a .NET developer."*
   - Key takeaways:
     - Kafka is async messaging system with topics and partitions.
     - If your code fails, it can reprocess messages from a specific offset. If it keeps failing, you can move the offset forward to skip bad messages, but according to Ian, you should have gotten a queue instead of Kafka then.
     - Every partition can be consumed by only one consumer in a consumer group. This has it's own offset.
     - There is something called Kraft. Zookeeper was something old. Kraft can elect the leader nodes itself.
     - There is a setting called: `EnableAutoOffsetStore` which can be set to false to manage offsets yourself. Otherwise the offset is stored after each message is **read**. This can lead to message loss if your processing fails after reading the message but before processing it.
     - There is something called sticky partitions. This makes sure that messages with the same key always go to the same partition. This is usefull for ordering of messages.
     - Messages in Kafka are mostly in Avro, JSON or Protobuf format.

2. **Scaling Azure Container Apps: maximize performance and minimize costs** by Anthony Chu
**Session abstract:** *"Azure Container Apps is a fully managed serverless container platform that allows you to run containerized workloads at scale. By using the correct scaling strategies and pricing plans, you can maximize performance and minimize costs of your Azure Container Apps workloads. In this session, we'll show you how to scale container apps and jobs on Azure Container Apps using its built-in KEDA scalers. Whether you're running a small app or a large-scale microservice application, we'll show you how to build and scale your containerized workloads on Azure Container Apps to maximize performance and minimize costs."*
   - Key takeaways:
     - You can create container apps with dedicated GPU support now.
     - You can use KEDA scalers to scale your container apps based on anything. For example eventhubs blobs service bus via Managed Identity.
     - You can also use custom scalers. For example you can create a HTTP endpoint which returns the desired replica count.

3. **Debugging Like a Coach: Fixing Team Bugs Before They Crash the Game** by Amber Vanderburg
**Session abstract:** *"Every developer knows how to debug bad code—but how good are you at debugging a bad team dynamic? In sports, coaches analyze real-time data, player behavior, and performance breakdowns to fix issues before they cause the game. Yet in tech, we often let misaligned teams, inefficient workflows, and poor communication go unchecked—until we hit a major release failure or a full-on team meltdown. This session will show you how to apply the coaching mindset to engineering leadership, using game film analysis, real-time feedback loops, and proactive team debugging to prevent small misalignments from becoming full-blown disasters. You’ll learn how to spot early warning signs of dysfunction, use data-driven decision-making to optimize team performance, and run post-mortems that actually lead to change (not just another boring meeting). If you can debug a program, you can debug a team—let’s break down the playbook. Learning Objectives: -Identify the “silent bugs” in tech teams—bottlenecks, misalignment, and ineffective communication—that hurt performance but often go unnoticed. -Use data-driven coaching techniques from pro sports (real-time analytics, film reviews, and performance tracking) to improve engineering team efficiency. -Learn how to run engineering retrospectives like a game tape review—breaking down past plays to improve future execution. -Apply in-the-moment coaching strategies to fix issues before they derail sprints—just like a coach making mid-game adjustments. -Develop a “team debugging” toolkit that ensures every project iteration is smoother, faster, and more efficient than the last. Bonus: We’ll do a live debugging session—not of code, but of common team dysfunctions—and break down exactly how to fix them."*
   - Key takeaways:
     - Books:
       - 5 Dysfunctions of a team
       - Crucial conversations
       - Only the paranoid survive
     - There is a difference between a personal need and a practical need. Get rid of the personal need first to make it easier to handle the practical need.
     - Use sentices like "Help me understand..." to get more information.
     - To make desicions in a team use ELMO (Enough, let's move on). And time box the discussion.
     - You should 'map your script'. Write down what you want to say and what the other person would say. This helps you to prepare for difficult conversations. Flip the script by changing your perspective.
     - If you want to change behavior give feedback with this format:
     | What behaviour **unwanted** happened | Why |
     | What alternative behaviour **wanted** is expected| Why |
     | Clarify expectations |

4. **Avoiding common pitfalls with async/await** by Stephen Cleary
**Session abstract:** *"Did you know that most async/await mistakes are the result of misconceptions? Join this talk to discover how to detect common async/await mistakes, and how to fix them! We'll be covering What You Need To Know about async/await in C#, including several different correct conceptual models of async/await that you can switch between at will. We will take a look at the common async pitfalls, best practices, and guidelines along with a careful examination of when to ignore the best practices. We'll be including some semi-advanced topics (specifically ValueTasks and Channels) to round out techniques for modern asynchronous development. While this talk is geared towards developers who already use async and await, it would also be appropriate for those who do not (yet). Feel free to bring questions!"*
    - Key takeaways:
      - USE ASYNC and AWAIT keywords always. Dont run in to deadlocks.
    - Avoid async void methods, except for event handlers in UI code.
    - Avoid using Task.Run in ASP.NET code. It does not help you except in UI code.
    - https://stephencleary.com
    - Task represents a methods execution. It as a completion, results and exceptions.
    - Async **wraps** the Task<T>.
    - await **unwraps** the Task<T>.
    - Don't run async code in constructors

5. **All-Time Sportiest Hacks** by Eric de Maar
**Session abstract:** *"In the high-stakes world of professional sports; data is the new gold, and hackers know it. From stolen medical records of star athletes to espionage between rival teams, the digital frontier has become as contested as the playing field itself. In this special talk, Eric de Maar, the creator of Hack the Bank, takes you on a thrilling journey through the most shocking sports-related hacks of all time. Discover how attackers infiltrated supposedly secure networks, manipulated sensitive information for competitive advantage and exposed organisations for corruption. You'll gain a front-row seat to tales of cyber sabotage that influenced World Cups and Olympics. Prepare to be challenged and inspired, because in the sport of security, every second counts."*
   - Key takeaways:
     - FIA got hacked because of broken register form, which allowed role attributes.
     - You should bring your adapter when you are speaking at conferences.

     
5. **What's new in C# 13, 14, and beyond?** by Bart de Smet
**Session abstract:** *"Come and catch up on the most recent C# language evolution and a peek into the future. We'll start this talk by looking at various enhancements to existing language features, such as params collections, improvements to the lock statement, null-conditional assignment, the new field keyword, and various restrictions that have been lifted around the use of ref structs. Next, we'll have an in-depth overview of the new extension member support, finally enabling extension properties and indexers. To finish the talk, we'll look at brand new features slated for upcoming versions, such as dictionary expressions, union types, and more."*
   - Key takeaways:
     - the extension members are coming to C# 13. This makes it possible to add methods to existing types without modifying their source code.
     - Some things are improved to get a Span<T> in a params array.
     - Null-conditional assignment in C# 14: `customer?.Order = GetOrder();`

https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-13

https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-14

### Ending keynote - Robert Doornbos

Amazing keynote about racing and many insights in the racing world. I learned about the value of teamwork, preparation, and focus. And also the real value of a formula 1 car, which is $12 to $16 million. I have watched the last couple of seasons and getting the insights from Robert was really cool.

## Conclusion and key learnings

I have learned a lot during Techorama 2025. I even won a Lego set of the Red Bull signed by Robert Doornbos.