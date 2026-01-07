---
title: "2026 A New Year, New Workflows"
slug: "2026-new-year-workflows"
date: 2026-01-07T10:49:12+01:00
publishdate: 2026-01-07T10:49:12+01:00
draft: true
author: ["Mart de Graaf"]
tags: ["code", "csharp"]
summary: "In 2026, I started podcasting and optimized my blogging workflow. Read about the tools and processes I used to get started."
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
    alt: "2026 New Year" # alt text
    caption: "2026 New Year" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

I want you to know I started podcasting last year and the first episode went live on January 1st, 2026! 🎉 The podcast is called Oogkleppen and is recorded in Dutch.

## Workflows

Let's talk about workflows. I have optimized my workflows for podcasting and blogging. It is just like Agile, start with something small and improve it over time. And focussing on the most important parts first. In this article I will share with you how I set up my podcasting and blogging workflows.

### Podcast

To get started with podcasting Peter and I discussed how to start and what tools to use. Peter tended to act a lot more like Eric, hold back and rethink everthing. I was more of a Ryan "let's just do it" kind of person. I want to share with you how we set up our podcasting workflow.

#### Recording

We wanted to keep things simple and use tools we already had. So we used what we had available:

- **Microphones**: Two sets of Rode Wireless GO II
- **Recording Software**: Rode Connect

#### Editing

For editing, we decided to use Audacity, a free and open-source audio editing software. It offers all the basic features we needed to clean up our recordings, add intros/outros, and adjust audio levels. But to edit a full episode using audacity is still quite a bit of work. That is why we we looked into alternatives.

##### AI-Powered Transcription

To streamline the editing process, we explored AI-powered transcription services. To do this i created a .NET console application that used Whisper.Net to transcribe our recordings. This allowed us to quickly identify sections that needed editing without having to listen to the entire recording.

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

```json {file=tasks.json}
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

### Setting goals for 2026

As we step into 2026, it's a great time to set some personal and professional goals. Here are a few goals I have set for myself this year:

- Speaking: give 6 talks, develop 1 new talk, speak at 2 new events (never spoken at before).
- Podcast: release 6 episodes, have 6 guests, decide if Peter and I want to continue.
- Health : Lose some kg, strength training 2x/week.
- Blog: Publish 12 blog posts, every last Friday of the month at 16:00.

#### Anti-goal 2026: Only "Fun" or "Promised"

In 2026, I commit to only engaging in activities that I either genuinely enjoy (≥7/10 energy) or have explicitly promised (clear agreement/expectation). Anything outside of that: don't do it or renegotiate.

#### Review

I reviewed my goals with a peer and he asked me what my personal goals were for 2026 especially for my family. I tought about this throughly and decided to book a vacation with my family for our wedding anniversary. Thanks Peter for the great question!

### Blocking YouTube

We have kids at home. And they love YouTube. But I tell them the so-called 'Shorts' are videos that make them bumb. So to help them focus on better content I have blocked YouTube  on our home network using AdGuard within home assistant. This helped us as parents to have more control over what content our kids can access.

Our current workflow was to navigate to AdGuard, go to Filters > Block Services and search youtube in the list and disable it.

I wanted to have this in our dashboard with a toggle switch. So I searched for solutions and found out that AdGuard has an API that can be used to toggle services. see: https://community.home-assistant.io/t/toggling-adguard-services-from-ha-dashboard/719007

### Consuming Blog posts and podcasts

For the setup of our podcast we needed to make it available for multiple platforms. Such as Spotify and Apple podcasts. Most other platforms work with RSS Feeds. So when we make the RSS Feed from Spotify available other third party platforms can also use it.

#### Consuming podcasts

Earlier I just used Spotify to listen to podcasts. Annoying because when you listen to music via Spotify it is difficult to find and continue the right podcast while in car. Or just always.

I can recommend listening to the podcasts: Darknet Diaries and How to take over the World. If you are Dutch, take our podcast Oogkleppen! 😉

My colleague Peter recommended using Antennapod on Android. Jan uses Pocket Casts on iOS.
I installed both on Android, i am going to test both, and let you know. A big plus would be if a Android Auto integration is available.

#### Consuming blog posts

I earlier just checked content reguraly but from now on will organise blogs via Readly. RSS feeds mostly are available via /index.xml on most blogs. Some are available via /feed or /feed.rss. With Readly I can organise blogs into categories and read them when I want to.

### Making the right tactical switch

I am using a Dygma Defy keyboard for my daily work. It is a split keyboard that allows me to type more ergonomically. The keyboard has hot swappable switches. And i used the keyboard a year using linear switches. As of 2026 I have switched my right half to tactile switches. Let's see what half i am most comfortable with.

Checkout this video about the switch choice: https://www.youtube.com/watch?v=noUj7uUyIk4

> I was using Gateron G Pro 2.0 Yellow (linear) switches. I have just installed Kailh Silent Brown switches on the right half of my keyboard.

## All the pancakes in the world

Let us be better in 2026 by optimizing our workflows and embracing new technologies. Whether it's podcasting or blogging, finding efficient ways to create and share content can lead to greater productivity and enjoyment. I wish you all the pancakes in the world in 2026! 🥞🎉