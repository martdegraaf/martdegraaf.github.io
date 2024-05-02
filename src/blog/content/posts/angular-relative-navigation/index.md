---
title: "Angular Relative Navigation"
slug: "angular-relative-navigation"
date: 2024-04-25T07:47:30+02:00
publishdate: 2024-04-25T07:47:30+02:00
draft: false
author: ["Mart de Graaf"]
tags: ["angular", "navigation", "routing", "typescript"]
summary: "Learn how to navigate to a route relative to the current route in Angular. This is useful when you have a wizard-like flow in your application."
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

For a project, we have routes that live in states. We wanted to navigate to a route relative to the current route. for each child route, we will be able to navigate to the previous and next route.

## System context

Let's say we have a `app-routing.module.ts` with the following routes:

```ts {linenos=table}
const routes: Routes = [
  {
    path: 'parent',
    component: ParentComponent,
    children: [
      {
        path: 'child1',
        component: Child1Component,
        data: { stepName: 'child1'}
      },
      {
        path: 'child2',
        component: Child2Component,
        data: { stepName: 'child2'}
      },
      {
        path: 'child3',
        component: Child3Component,
        data: { stepName: 'child3'}
      }
    ]
  }
];
```

## Router.navigate

We do not want to edit the url property, because it can lead to complexity. You would just say Angular does have the router to do so. The current route is a chain of activated routes when you are navigating to url like `/parent/child1/child2/child3`.

```ts {linenos=table}
//Inside Some component

constructor(
    private router: Router,
    private activatedRoute: ActivatedRoute
) {}

navigate() {
  let lastChildRoute = getLastActivatedRouteInChain(this.activatedRoute);
  this.router.navigate(['../child2'], { relativeTo: lastChildRoute });
}
```

To get the activated route for for example `child3` when the url is `/parent/child1/child2/child3` we need to get the last child route in the chain. This `ActivatedRoute` object is passed to the `relativeTo` property of the `router.navigate` method.

```ts {linenos=table}
export const getLastActivatedRouteInChain = (activatedRoute: ActivatedRoute): ActivatedRoute => {
  let lastRoute = activatedRoute;
  while (lastRoute.firstChild) {
    lastRoute = lastRoute.firstChild;
  }
  return lastRoute;
};
```

## Conclusion and discussion

This way we can navigate to a route relative to the current route. This is useful when you have a wizard-like flow in your application.

### Further reading

- [Angular Router](https://angular.io/guide/router)
