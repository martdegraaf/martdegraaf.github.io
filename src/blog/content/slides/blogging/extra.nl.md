+++
weight = 20
+++

# Idea bin

1. Screen to GIF
1. Disclaimer?
1. Traffic meten
1. Traffic genereren
1. How to overcome Imposter syndrome while blogging.

---

# Hosting

1. Self-hosting
1. Netlify
1. Azure Static Web Apps
1. Github Pages
1. Medium

{{% reveal/note %}}
Om je blog naar de wereld te krijgen moet de blog ergens draaien.

Elk platform heeft eigen voor en nadelen.
{{% /reveal/note %}}

---

# Document and plan your workflow:

1. New article: `hugo new posts/your-cool-article.md`
2. Maak een standaard structuur in een archetype zodat je snel kan beginnen!
3. Hosting kan later nog wijzigen. Begin eenvoudig met bijvoorbeeld github pages, daarna kan je je blog altijd nog ergens anders hosten.

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