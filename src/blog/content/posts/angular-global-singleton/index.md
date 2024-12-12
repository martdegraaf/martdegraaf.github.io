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
public AppComponent{

public constructor(private router: Router, private titleService: Title) {
  this.handleRouterEvent();
}
private handleRouterEvent(): void {
  this.router.events.pipe(
    takeUntill(this.destroy$),
    filter((event) => event instanceof NavigationEnd),
    map((event) => event as NavigationEnd)
  ).subscribe((event) => {
      this.titleService.setTitle(this.getTitle(event.url));
    });
}
}
```

# Solution

The solution was found using the `APP_INITIALIZER` token. This token is used to run a function before the application is bootstrapped. When usng this method we can create a global singleton that does not need to be depended upon in the constructor of the components.

## The root listener

```ts {linenos=table}
@Injectable({
    providedIn: 'root'
})
export class RouteHandlerService implements OnDestroy{
    private destroy$ = new Subject<void>();
    constructor(
        private router: Router,
        @Inject('ROUTE_HANDLING_LISTENERS') private subServices: RouteHandlerSubService[]
        ) {
        this.startListening();
    }
    private startListening(): void {
        this.router.events.pipe(
        takeUntill(this.destroy$),
        filter((event) => event instanceof NavigationEnd),
        map((event) => event as NavigationEnd)
        ).subscribe((event) => {
            this.titleService.setTitle(this.getTitle(event.url));
        });
    }
    public ngOnDestroy(): void {
        this.destroy$.next();
        this.destroy$.complete();
    }
}

export function provideRouteHandler(...subServices: Provider[][]): Provider[] {
    return [
        ...subServices.map((service) => service),
        {
            provide: APP_INITIALIZER,
            useFactory: (routeHandlerService: RouteHandlerService) => () => routeHandlerService,
            deps: [RouteHandlerService],
            multi: true
        }
    ];
}
```

## The sub services

We have some actions that need to be done on navigation such as logging a page view and setting the title of the page. We can create a sub service for this. This sub service can be injected in the `provideRouteHandler` method.

### TitleService

```ts {linenos=table}
@Injectable({
    providedIn: 'root'
})
export class TitleService implements RouteHandlerSubService {
    constructor(private titleService: Title) {}
    public handleRoute(event: NavigationEnd): void {
        this.titleService.setTitle(this.getTitle(event.url));
    }
}

export function withTitleService(): Provider[] {
    return [
        TitleService,
        {
            provide: 'ROUTE_HANDLING_LISTENERS',
            useExisting: TitleService,
            multi: true
        }
    ];
}
```

### PageViewLogger

```ts {linenos=table}
@Injectable({
    providedIn: 'root'
})
export class PageViewLogger implements RouteHandlerSubService {
    constructor(private logger: LoggingService) {}
    public handleRoute(event: NavigationEnd): void {
        this.logger.logPageView(event.url);
    }
}

export function withPageViewLogger(): Provider[] {
    return [
        PageViewLogger,
        {
            provide: 'ROUTE_HANDLING_LISTENERS',
            useExisting: PageViewLogger,
            multi: true
        }
    ];
}
```

## Implementing in your application

By creating a provide method, we can configure any behaviour that is needed for that specific project. And by allowing parameters to implement this method we can extend even for specific business logic for that project. I got this idea when we migrated to a newer version of Angular and i saw the `provideRoutes` method. This method is used to provide routes to the application. My solution is based on this method but implemented generic and simple.

So in your `main.ts`, you can now register the route handler like this:

```ts {linenos=table}
bootstapApplicaiton(AppComponent, {
    providers: [
        ...
        provideRouteHandler(withTitleService(), withPageViewLogger())
    ]
});
```

This allows even consumers to hook into those events and write their own subservice for hanlding router events.

# Conclusion and discussion

Please don't use this as an golden hammer. Normally you would want to be as explicit as possible when subscrbing to route events. In our case we removed complexity and variations in our codebase. Also i am not sure what kind of performance impact this has on applicattions. We use these subscriptions at root level, so it was a good fit for us.

Also if you are using my code here, please note it only supports NavigationEnd events. If you want to support more events, you should edit the design to support a method to in the service if it handles the event type. You could use the `Event`type from `@angular/router` to do this. 

```ts
public startListening(): void {
    this.router.events.pipe(
        takeUntill(this.destroy$),
    ).subscribe((event) => {
        this.subServices
            .filter((service) => service.handles(event))
            .forEach((service) => service.handle(event));
    });
}
```

__This blogpost is the first blog post using my new Dygma Defy keyboard. I did not edit the layers yet just trying to get used to the keyboard.__
