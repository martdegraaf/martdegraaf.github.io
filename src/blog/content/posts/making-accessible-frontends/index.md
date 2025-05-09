---
title: "Making Accessible Frontends"
slug: "making-accessible-frontends"
date: 2025-03-15T20:16:01+01:00
publishdate: 2025-03-15T20:16:01+01:00
draft: true
author: ["Mart de Graaf"]
tags: []
summary: "Tools to make your frontend accessible and test it for accessibility."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true

cover:
    image: "cover.png" # image path/url
    alt: "Accessable websites" # alt text
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

Nobody wants to make websites accessible, but it is essential. This post will show you tips and tricks to make your frontend accessible.

## Obvious but important

The html should be correct and in the same order as you read the elements on the screen.

## Custom components should be accessible

If you create custom components, make sure they are accessible. It can be done by adding the correct aria attributes.

## Use Tooling

There are tools available that can help you make your frontend accessible.

[TODO screenies]

### Manual testing

For manual testing, the axe browser extension can help you find accessibility issues in your frontend. [Axe chrome extension](https://chromewebstore.google.com/detail/axe-devtools-web-accessib/lhdoppojpmngadmnindnejefpokejbdd)

This tool can help you analyse your localhost or build FrontEnd on static things.

Another good practice can be to run Google Lighthouse in your browser. This tool can help you find accessibility issues in your frontend.

### Use automated tooling

There are tools available that can help you find accessibility issues in your frontend.

- [axe-core](https://www.deque.com/axe/)
- [pa11y](https://pa11y.org/)
- [Lighthouse](https://developers.google.com/web/tools/lighthouse)

For teams that already use PlayWright, Axe-core can be integrated into your tests.

## Conclusion

You should be testing your frontend for accessibility. It is important to make your frontend accessible for everyone. And you should not only rely on automated testing, but also manual testing.
