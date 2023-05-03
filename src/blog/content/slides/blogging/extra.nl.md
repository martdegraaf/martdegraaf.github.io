+++
weight = 20
+++

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