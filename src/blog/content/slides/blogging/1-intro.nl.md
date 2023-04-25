+++
weight = 1
+++


{{% reveal/section %}}

{{% reveal/slide transition="zoom" transition-speed="fast" %}}

# Whatsapp poll
{{ $image := resources.Get "whatsapp_poll.nl.png" }}
![Whatsapp poll]({{ $image.RelPermalink }})


![Whatsapp poll](whatsapp_poll.nl.png)

---

{{% reveal/slide id="agenda" %}}

# Agenda

1. [💡 Motivatie & inspiratie](#inspiratie)
1. [📒 Post schrijven](#post-schrijven)
1. [🔍 Optimalisatie](#optimalisatie)
1. [🏑 Stok achter de deur](#stok-achter-deur)
1. [🤖 Artificial intelligence](#chatgpt)
1. [🍕 Pizza](#pizza)

---

{{< reveal/mermaid >}}
stateDiagram
    [*] --> Drafting
    Drafting --> Editing: Content is ready
    Editing --> Drafting: Changes required
    Editing --> Reviewing: Content is final
    Reviewing --> Editing: Changes required
    Reviewing --> Publishing: Content is approved
    Publishing --> [*]: Blog post is live
{{< /reveal/mermaid >}}

{{% /reveal/section %}}
