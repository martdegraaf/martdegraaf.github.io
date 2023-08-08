# Mart's Hugo blog

[Visit https://blog.martdegraaf.nl/](https://blog.martdegraaf.nl/)

A PR will trigger a deployment to Azure Static Web Apps for staging purposes.

A commit on the main branch will (also) be deployed to GitHub pages.
[Visit https://martdegraaf.github.io/](https://martdegraaf.github.io/)

## Navigate to the blog
`cd .\src\blog`

## New code post

`hugo new --kind code-post posts/your-new-blog.md`

## New book review

`hugo new --kind book-review books/cool-book.md`

## Blog in Dutch

_Not use this for findability_

`hugo new posts/nederlandse-blog-post.nl.md`


## Run it

Add `--disableFastRender` to disable the fast render of the site. This will make sure the CSS is generated correctly.

```cmd
hugo server --buildDrafts --buildFuture --disableFastRender
```

## See future posts

```cmd
hugo list future
```

## Links to start blogging

1. [Emoiji cheat sheet](https://www.webfx.com/tools/emoji-cheat-sheet/)
1. [Fontmatter Hugo](https://gohugo.io/content-management/front-matter/)

## notes to self

[Abbreviation examples Azure resources](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)

## Thanks to

1. [Jackson Lucky's blog - LastModified](https://www.jacksonlucky.net/posts/use-lastmod-with-papermod/)


Ideas for blog:
1. SonarCloud?
1. Builder pattern TestContainers Respawn
