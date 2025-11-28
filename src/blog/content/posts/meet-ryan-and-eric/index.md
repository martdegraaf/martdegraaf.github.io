---
title: "Meet Ryan and Eric"
slug: "meet-ryan-and-eric"
date: 2025-11-21T21:41:58+01:00
publishdate: 2025-11-21T21:41:58+01:00
draft: false
author: ["Mart de Graaf"]
tags: ["Ryan", "Eric", "keyboard-shortcuts", "visual-studio-code", "developer-archetypes"]
summary: "Meet Ryan and Eric, two software developers but completely different."
# Toc
ShowToc: false
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: false
ShowWordCount: true

cover:
    image: "cover.png" # image path/url
    alt: "Meet Ryan and Eric" # alt text
    caption: "Meet Ryan and Eric" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

For my presentation "Visual Studio Code: One Tool to Rule Them All?" I created two fictional characters: Ryan and Eric. Both are software developers, but they take very different approaches to their work.

A colleague of mine suggested I write a blog post to introduce them properly. Everyone who heard my story about them immediately recognized these two archetypes. Even presenters who spoke after my session started using Ryan and Eric in their talks. So let's give them the spotlight they deserve, right?

## Meet Ryan

Have you met Ryan? Ryan is a young developer, fresh out of college. He has a couple of core qualities: he learns fast, is curious and loves new technologies. Ryan probably has more unfinished projects on his laptop than finished ones.

> :robot: The images of Ryan and Eric are AI-generated using Sora, by providing my own image as input and describing the character traits.

{{< figure src="Ryan.png" alt="Ryan - fast, experimental, shortcut-obsessed" caption="Ryan - fast, experimental, shortcut-obsessed" align="center" height="300">}}

Ryan is the kind of person who uses hip IDEs like Visual Studio Code, because it is lightweight and fast. Ideally Ryan would like to use his phone to code on the go, while watching his favorite series on Netflix.

> “Move fast and fix things later.” - Ryan

When you have a Ryan on your team, you will notice that he will run before thinking his actions through. He will push fast to production, only to find out later that something is broken. But hey, at least he tried, right? And if he is just as fast to fix it again, everything is fine.

## Meet Eric

Eric is a seasoned developer with years of experience. He is pragmatic, values stability and prefers to stick to tried-and-true tools. Eric will start Notepad++ to quickly format his XML or JSON or compare files. He jokes that you cannot write any good code in Visual Studio Code, because where is the "Play" button to start the project?

{{< figure src="Eric.png" alt="Eric - stable, cautious, prefers proven tools" caption="Eric - stable, cautious, prefers proven tools" align="center" height="300">}}

When you have an Eric on your team, you will notice that he will take his time to think things through. He will criticize decisions beforehand knowing that changing things later will be costly. Why change when you have worked this way for years?

> “If it ain't broke, don't fix it.” - Eric

## A conversation between Ryan and Eric

If Ryan and Eric were to have a conversation, it might go something like this:


### Having multiple PR's open

> **Context:** Eric leans back.

{{< chat-start >}}

{{< chat speaker="eric" position="left" >}}
We’re going to make some rules. Ready?
{{< /chat >}}

{{< chat speaker="ryan" position="right" >}}
Is “no” an acceptable answer?
{{< /chat >}}

{{< chat speaker="eric" position="left" >}}
No.  
**Rule 1:** No more than two open PRs at a time.
{{< /chat >}}

{{< chat speaker="ryan" position="right" >}}
What if I have three great ideas?
{{< /chat >}}

{{< chat speaker="eric" position="left" >}}
Write them down. Ship two. The third can wait.
{{< /chat >}}

{{< chat-end >}}


### Writing an ADR

> **Context:** A new framework is being discussed. Ryan is already prototyping.  

{{< chat-start >}}

{{< chat speaker="eric" position="left" >}}
Before we change the framework, we write an ADR.
{{< /chat >}}

{{< chat speaker="ryan" position="right" >}}
Can't we just try it first and see what happens?
{{< /chat >}}

{{< chat speaker="eric" position="left" >}}
We can try it. But we still write an ADR.
{{< /chat >}}

{{< chat speaker="ryan" position="right" >}}
What do you even want in there? "Ryan had a feeling"?
{{< /chat >}}

{{< chat speaker="eric" position="left" >}}
No.<br/>
**ADR Rule 1:** Capture the problem, the options, and why we picked this one.
{{< /chat >}}

{{< chat speaker="ryan" position="right" >}}
That sounds like homework.
{{< /chat >}}

{{< chat speaker="eric" position="left" >}}
It's future-you cheating on future-homework. You won't remember why you did this in six months.
{{< /chat >}}

{{< chat speaker="ryan" position="right" >}}
Fine. I'll write the ADR. Short one.
{{< /chat >}}

{{< chat speaker="eric" position="left" >}}
Short is okay. Undocumented is not.
{{< /chat >}}

{{< chat-end >}}


## Ryan and Eric

These two fictional characters represent two very different behavior patterns in software development teams. Ryan pushes for speed and experimentation; Eric optimizes for stability and predictability. Most of us have both inside us, and the trick is to know when to lean into which.

Let's introduce an example I myself encounter often: My colleague acts like Eric. He locks his computer using `Ctrl+Alt+Del` and selects 'Lock' from the menu. I think he should use Ryan to optimize his workflow. I, on the other hand, use `Windows+L` to lock my computer instantly. The same pattern shows up in formatting code, switching screens, or running builds: you can click your way through, or you can invest in shortcuts and automation. Ryan would use `Windows+P` to extend his screen while Eric would right click on his desktop and select 'Display settings' to do the same.

The tension between Ryan and Eric is useful. Ryan pulls the team toward new tools and faster workflows; Eric stops us from breaking production every week. Healthy teams make space for both.

## Conclusion and discussion

Ryan and Eric are two fictional characters that represent two extremely different behavior patterns in software development teams. You can act like Ryan or Eric, but you should use both to balance innovation and stability. I hope Ryan and Eric will return in future blog posts as well. If you want to refer to them, you are welcome to do so. Please link back to this post.

Let's set the mode accordingly:

```javascript
var mode = DeadlineIsToday ? Ryan : Eric;
```

> What about you? Are you more like Ryan or Eric? Or do you have another archetype in mind? Let me know in the comments!

### Further reading

I wrote an Ryan-like article before read it here: [Mart's Cheatsheet]({{< ref "marts-cheatsheet/index.md" >}})
