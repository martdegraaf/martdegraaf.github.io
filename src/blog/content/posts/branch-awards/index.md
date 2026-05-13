---
title: "The Stale Branch Awards"
slug: "branch-awards"
date: 2026-04-16T22:35:02+02:00
publishdate: 2026-04-16T22:35:02+02:00
draft: false
author: ["Mart de Graaf"]
tags: ["git", "branches", "devops", "cleanup", "leading", "teamwork"]
summary: "Have you ever seen a branch that lives longer than you even worked for the company? In this blog post, I will share my thoughts on long-lived branches and how to avoid them."
# Toc+
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: false
ShowWordCount: true

cover:
    image: "cover.png" # image path/url
    alt: "The Stale Branch Awards 2026, image of a person holding a trophy" # alt text
    caption: "The Stale Branch Awards 2026" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

At a project I was working on we have had some stale branches. And if I say stale, I mean really stale. Some branches were existing for over 8 years. And they were still there, not deleted, not merged, just there. Everybody wanted to do something about them, but wasn't able to. Every now and then during a meeting someone would mention the ancient branches, but nobody had the rights to delete branches of people who had left the company. So the subject faded away until the next time someone would ask about them and this went on for years. I have seen this in multiple projects and it is a common problem. In this blog post, We can solve this problem now!

## The Branch Awards

The last and final meeting were these stale branches were discussed, a team member came up with an AI generated powershell script to give insight in the amount of stale branches. The default threshold was set to 6 months. The company had managed to collect 1337 stale branches. The script would give a report of the amount of stale branches per person and the oldest branch per person. If you have read some of my previous blog posts, you know I scripted something like this in PowerShell as well. So I arrogantly spoke up and said:

> "You are telling us the known issue here!"

But my team member was like:

> "Let me finish please."

What she showed us after was an aggregated report of the amount of stale branches per person and per repository. And for the person list she had prepared a ranking and scrolled so only position 11-15 were visible. And then she said:
> "And here we have the Branch Awards. The top 15 people with the most stale branches. Numbers 15- 11 did not make it to the top 10, but get a participation trophy 🎖️"

And then she scrolled up and revealed the top 10 one by one with funny names for each position. The number 1 was called: 'The supreme neglecter' and had a golden trophy 🏆. The number 2 was called 'Distinguished Deserter' and had a silver trophy 🥈. The number 3 was called 'Bronze Abandoner' and had a bronze trophy 🥉. And the rest of the top 10 had some funny names as well.

The Branch Awards were born and it was a huge success. The team loved it and it was a great way to bring attention to the problem of stale branches. After the branch awards I managed to get the rights to delete branches and started to clean up stale branches of people who had left the company and checked with the team for their branches. We ended up with only 21 branches that were stale for more than 6 months.

## Tension

You could imagine that this would create some tension in the team, but it did not. The team took it with humor and it was a great way to bring attention to the problem. It was a fun way to bring up the problem. If you have a issue that you think will bring tension in the team, try to make it fun and bring attention to it in a positive way. Also make sure to stay factual and not personal.

## Inspiration

With the Branch Awards in place I could not stop myself generating a similar script for stale pull requests.

I have even made a song with Suno about open pull requests. You can listen it here:
[https://suno.com/s/9h9vLG9c19Z6GWJF](https://suno.com/s/9h9vLG9c19Z6GWJF)

Or the dutch version: [https://suno.com/s/mpDUvCwVbWojo9Vb](https://suno.com/s/mpDUvCwVbWojo9Vb)

## Conclusion

Just like with the 'FinOps' making fun of the savings by calling it meatballs saved. My coworker managed to make fun of the stale branches and bring attention to the problem by creating the Branch Awards. And it worked! We managed to clean up a lot of stale branches and bring attention to the problem. So if you have a problem with stale branches, create your own Branch Awards and see how it works for you!

> If you do not want to generate your script and use ours, you can find it here: [Branch Awards Script TODO]().
