---
title: "2026 Workflows"
slug: "2026-workflows"
date: 2026-01-09T11:14:19+01:00
publishdate: 2026-01-09T11:14:19+01:00
draft: true
author: ["Mart de Graaf"]
tags: ["workflows", "podcast", "blogging", "productivity"]
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
    alt: "2026 Workflows" # alt text
    caption: "2026 Workflows" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page

series: ["2026 New Year"]
---

Workflows are important

WHY

But why did i do this?

veel door elkaar

first blog post doenst have to be perfect.
Vragen voor feedback

> "I can't believe how much you get done" - a few colleagues

In this article I want to tell you about the workflows and habits that got me started with podcasting and how to keep blogging regularly. I will also share some of my personal goals for 2026 and new workflows I have or will adopt.

## Workflows

Let's talk about workflows. I have optimized my workflows for podcasting and blogging. It is just like Agile, start with something small and improve it over time. And focussing on the most important parts first. In this article I will share with you how I set up my podcasting and blogging workflows.

### Podcast

To get started with podcasting Peter and I discussed how to start and what tools to use. Peter tended to act a lot more like Eric, hold back and rethink everthing. I was more of a Ryan "let's just do it" kind of person. I want to share with you how we set up our podcasting workflow.

> Read about Eric and Ryan in my blog post: [Meet Ryan and Eric]({{< ref "meet-ryan-and-eric/index.md" >}})

#### Recording

We wanted to keep things simple and use tools we already had. So we used what we had available:

{{< figure src="rode_mics.jpeg" alt="Rode mics used for podcasting" caption="Rode mics used for podcasting" align="center" height="300">}}

- **Microphones**: Two sets of Rode Wireless GO II
- **Recording Software**: Rode Connect

{{< figure src="Rode_connect.jpeg" alt="Connecting to Rode Connect" caption="Connecting to Rode Connect" align="center" height="300">}}

#### Editing

For editing, we decided to use Audacity, a free and open-source audio editing software. It offers all the basic features we needed to clean up our recordings, add intros/outros, and adjust audio levels. But to edit a full episode using audacity is still quite a bit of work. That is why we we looked into alternatives.

##### AI-Powered Transcription

To streamline the editing process, we explored AI-powered transcription services. To do this i created a .NET console application that used Whisper.Net to transcribe our recordings. This allowed us to quickly identify sections that needed editing without having to listen to the entire recording.

>> TODO Link naar github
```csharp {file=transcribePodcast.cs}
```

##### Online AI powered services

We also experimented with online AI-powered services that offer podcast editing features. These platforms can automatically remove filler words, background noise, and even suggest improvements to the audio quality. This significantly reduced the time we spent on manual editing.

The tools we used for this were:

- **Auphonic**: For automatic audio post-production.
- **Trebble.fm**: For AI-driven podcast editing and enhancements.

#### Podcast naming

We prioritized recording over naming our podcast. So we decided to come up with a name after recording the first episode.
We decided to name our podast "Oogkleppen" which translates to "Blinders" in English. The name reflects our focus on discussing topics from a unique perspective, challenging conventional wisdom, and exploring new ideas.

#### Podcast Intro

To create a catchy intro for our podcast, we searched for royalty-free music online. We searched on https://pixabay.com/ and editted music in our spoken intro and field tested it with some friends and colleagues. The feedback was positive, and we felt the intro set the right tone for our podcast.

### Blogging

After optimizing our podcasting workflow, I decided to optimize my blogging workflow as well. I mainly blog in markdown in Visual Studio Code. To streamline the process of creating new blog posts, I created a custom task in VS Code.

By using the `tasks.json` file I automated the process of creating a new blog post file using the hugo cli, so I only have to provide the post name and it will create the file and open it in VS Code.

So my new workflow for creating a new blog post is:

1. Use the command palette in VS Code ``Ctrl+Shift+P`` and select "Run Task"
2. Select "Hugo: New code post"
3. Enter the post name (e.g., "my-new-post")
4. Start writing the blog post in the newly created markdown file.
5. Branch and commit your changes as usual.
6. Push and create a PR to merge my new blog post.

This will setup a test environment in Azure Static Web Apps and allow me to preview the blog post before merging it to main.

```json
{
	"version": "2.0.0",
	"tasks": [
		{
			"label": "Hugo: New code post",
			"type": "shell",
			"command": "hugo new --kind code-post posts/${input:postName}; code ${workspaceFolder}/src/blog/content/posts/${input:postName}/index.md",
			"options": {
				"cwd": "${workspaceFolder}/src/blog"
			},
			"presentation": {
				"reveal": "always",
				"panel": "shared"
			},
			"problemMatcher": []
		}
	],
	"inputs": [
		{
			"id": "postName",
			"type": "promptString",
			"description": "Post name (e.g., my-new-post)",
			"default": "new-post"
		}
	]
}
```

### Blocking YouTube

We have kids at home. And they love YouTube. But I tell them the so-called 'Shorts' are videos that make them dumb. So to help them focus on better content I have blocked YouTube  on our home network using AdGuard within home assistant. This helped us as parents to have more control over what content our kids can access.

> Basically we as parents have been framing short videos as 'dumb videos' or 'videos that make you dumb'

Our current workflow was to navigate to AdGuard, go to Filters > Block Services and search youtube in the list and disable it. But, we all know, that blocking youtube completely is not always desired. That is why I want to improve this workflow.

I wanted to have this in our dashboard with a toggle switch. So I searched for solutions and found out that AdGuard has an API that can be used to toggle services. see: https://community.home-assistant.io/t/toggling-adguard-services-from-ha-dashboard/719007

### Consuming Blog posts and podcasts

For the setup of our podcast we needed to make it available for multiple platforms. Such as Spotify and Apple podcasts. Most other platforms work with RSS Feeds. So when we make the RSS Feed from Spotify available other third party platforms can also use it.

#### Consuming podcasts

Earlier I just used Spotify to listen to podcasts. Annoying because when you listen to music via Spotify it is difficult to find and continue the right podcast while in car. Or just always.

> I can recommend listening to the podcasts: Darknet Diaries and How to take over the World. If you are Dutch, take our podcast Oogkleppen! 😉

My colleague Peter recommended using Antennapod on Android. Jan uses Pocket Casts on iOS.
I installed both apps on Android, i am going to test both, and let you know. A big plus would be if a Android Auto integration is available.

#### Consuming blog posts

I earlier just checked content reguraly but from now on will organise blogs via Readly. RSS feeds mostly are available via /index.xml on most blogs. Some are available via /feed or /feed.rss. With Readly I can organise blogs into categories and read them when I want to.

### Making the right tactical switch

I am using a Dygma Defy keyboard for my daily work. It is a split keyboard that allows me to type more ergonomically. The keyboard has hot swappable switches. And i used the keyboard a year using linear switches. As of 2026 I have switched my right half to tactile switches. Let's see what half i am most comfortable with.

Checkout this video about the switch choice: https://www.youtube.com/watch?v=noUj7uUyIk4

{{< figure src="defy_switches.jpeg" alt="Dygma Defy - the right half. Brown are tactile, Yellow are linear." caption="Dygma Defy - the right half. Brown are tactile, Yellow are linear." align="center" height="300">}}

> I was using Gateron G Pro 2.0 Yellow (linear) switches. I have just installed Kailh Silent Brown switches on the right half of my keyboard.
