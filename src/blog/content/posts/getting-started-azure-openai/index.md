---
title: "Getting started with Azure OpenAI"
slug: "getting-started-with-azure-openai"
date: 2023-07-12T18:00:00+02:00
publishdate: 2023-07-12T00:00:00+02:00
draft: false
author: ["Mart de Graaf"]
tags: ["Azure", "AI", "GPT"]
summary: AI is happening. How can you make sure your organization benefits from AI?
ShowToc: true

ShowReadingTime: true
ShowLastModified: false
ShowWordCount: true
---

## Introduction

Artificial intelligence is hip and happeng. Everyone can use ChatGPT right now easily. But there are some worries of where your chats will go. Is it safe? Is the model trained by my conversations?

Azure OpenAI services promises that the data stays in your environment in the cloud. In this blog post, I will show you how to get started with Azure OpenAI.

## Creating your OpenAI resource

Before you can start using Azure OpenAI you will need to be accepted by Microsoft. You need to apply for the 'Azure OpenAI Service' preview. You can do this by following the procedure to create this resource, a link to the application form is provided.

![Azure Marketplace - OpenAI](marketplace-openai.png#center "Azure Marketplace - OpenAI")

1. Create a new resource in Azure.
1. Search for OpenAI
1. Select the OpenAI resource
1. Create the resource

### OpenAI studio

After creating the resource you can go to the OpenAI studio.

![OpenAI Studio](openai_studio.png#center "OpenAI Studio")

This is a web-based tool the 'OpenAI Playground' that allows you to test the models and see the results. You can also create your own models and train them.

### Create a new Model

You can create a new model by clicking the 'Create Model' button. You can select the model you want to use. The default is the GPT-3 turbo model. I did my testing with the gpt-35 turbo Model. From the model you need to make a deployment. This will take a few minutes. After the deployment is done you can start using the model.

### Chat Playground 

![OpenAI Studio - Chat Playground](chat_playground.png#center "OpenAI Studio - Chat Playground")

In the screenshot above there are some features numbered:

1. Add data sources
2. Add system prompts
3. Clear the chat, and view the code
4. Parameters into the model.
5. Import and export the setup.

### Defining System Prompts

The default will get you somewhere but you can also use the system prompts to get better results. The system prompts are a way to give the model some context. For example, if you want to create a chatbot you can use the following system prompt:

```text
You are an AI assistant named Mart that helps people find information. The assistant is helpful, creative, clever, and very friendly.

Provide the full schedule when the user asks for a certain date.
End every message with "Mart knows everything". Add a mermaid diagram written in markdown to clarify your statement.
```

This kind of prompting will result in some hilarious results. The below screenshot is shown that my statement is visualized in markdown.

![Chat Playground](sample-chat.png#center "Sample Chat")

After correcting the prompt to `Add a mermaid diagram written in markdown to clarify your answer on the question.`. I got:

```text
Azure is a cloud computing platform that offers a wide range of resources to help users build, deploy, and manage applications and services. Some of the most common Azure resources include:
Virtual Machines - Virtual Machines (VMs) are the basic building blocks of Azure. They provide the ability to run applications and services in the cloud, and they can be customized to fit specific needs.
Storage Accounts - Storage Accounts are used to store data in the cloud. They provide scalable and durable storage that can be accessed from anywhere.
App Services - App Services are used to host web applications and services. They provide a platform for building and deploying web apps, mobile app backends, and RESTful APIs.
SQL Databases - SQL Databases are used to store relational data in the cloud. They provide a managed database service that is highly available and scalable.
Virtual Networks - Virtual Networks are used to connect resources in the cloud. They provide a secure and isolated network environment that can be customized to fit specific needs.

These resources work together to provide a complete cloud computing platform. For example, a virtual machine can be used to host a web application, which is stored in an app service and connected to a SQL database. Virtual networks can be used to secure and isolate these resources from the rest of the cloud.
Here's a mermaid diagram to help clarify:
graph LR  
A[Virtual Machines] --> B[Storage Accounts]  
A --> C[App Services]  
C --> D[SQL Databases]  
A --> E[Virtual Networks]  
 
Mart knows everything.
```

This was more what I expected. Only the mermaid diagram connections don't make sense. \

<!-- Date and privacy explained Azure vs GPT-->
<!-- Date and privacy explained-->
### Document your code with GPT

```text
create a mermaid diagram for the flow that is done in this c# code 

C# code here
```

This resulted in the code being explained in a good flowchart. This is a great way to document your code.


### Adding your own data using Cognitive Search

You can also add your own data to the model. This can be done by using the Cognitive Search feature. You can upload your own data and use it to train the model. You can also use the data to create completions.

<!--Link to Documentation about Playground adding data.-->
<!--Link to Documentation about Cognitive Search.-->
<!--Link to Documentation about System Prompts.-->


### OpenAI API

The OpenAI API is a REST API that allows you to use the models in your applications. You can use the API to create completions, chat, and dall-e requests.

## Creating your first completion

To create your first completion you will need to create an API key. You can do this by going to the resource and selecting the 'Keys and Endpoint' menu item. You can create a new key by clicking the 'New Key' button.



## Available models

- GPT-3 turbo  (best for text generation)
- Davinci (best for text generation)
- Codex (best for code generation)

GPT4 is not yet available.

## Available Methods

1. Chat
1. Completions
1. Dall-E


## Conclusion

I have no idea what the conclusion is. I just wanted to try out the OpenAI API and see the possibilities it has. Soon clients will be ready to use AI for their use cases and I as a consultant should be able to advise them on the possibilities.

<!-- Quoteblock here?-->
May the AI be with you.

## References in Azure

