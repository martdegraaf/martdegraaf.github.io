---
title: "Angular Global Singleton"
slug: "angular-global-singleton"
date: 2024-12-07T00:25:40+01:00
publishdate: 2024-12-07T00:25:40+01:00
draft: true
author: ["Mart de Graaf"]
tags: []
summary: ""
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true

cover:
    image: "cover.webp" # image path/url
    alt: "Mart de Graaf - cartoon style." # alt text
    caption: "Mart de Graaf - cartoon style." # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

__In a project with over 50 angular projects we had quite some duplicate code. The first thing you will think of is putting code in a NPM package. But that can be a challenge when some of the 50 had a different implementation.__

# System context

The applications we make are wizard like applications. We update the title on a route change. This is done by subscribing to the router events.
In the angular projects we had this code sample in the `app.component.ts`:

```ts {linenos=table}
__insert code here__
```

# Solution

The solution was found using the `APP_INITIALIZER` token. This token is used to run a function before the application is bootstrapped. When usng this method we can create a global singleton that does not need to be depended upon in the constructor of the components.

```ts {linenos=table}
__insert code here__
```

By creating a provide method, we can configure any behaviour that is needed for that specific project. And by allowing parameters to implement this method we can extend even for specific business logic for that project. I got this idea when we migrated to a newer version of Angular and i saw the `provideRoutes` method. This method is used to provide routes to the application. My solution is based on this method but implemented generic and simple.

```ts {linenos=table}
__insert code here__
```

# Conclusion and discussion

Please don't use this as an golden hammer. Normally you would want to be as explicit as possible when subscrbing to route events. In our case we removed complexity and variations in our codebase. Also i am not sure what kind of performance impact this has on applicattions. We use these subscriptions at root level, so it was a good fit for us.

__This blogpost is the first blog post using my new Dygma Defy keyboard. I did not edit the layers yet just trying to get used to the keyboard.__
