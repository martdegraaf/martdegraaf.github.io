---
title: "Add project properties for consuming apps to a NuGet package"
date: 2022-10-19T18:00:00+02:00
publishdate: 2022-10-19T00:00:00+02:00
draft: false
author: ["Mart de Graaf"]
tags: ["NuGet", ".NET", "csproj"]
summary: This article explains how to add consuming project properties to a NuGet package. Those project properties will be used in the consuming apps.
ShowToc: true

ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true
---
# Introduction
For a recent project, I wanted to add a property to the consuming applications from within my NuGet package. This prevents  making a pull request for every consuming application with a .csproj change.

{{< quoteblock >}}
:notebook: Please note in this example the NuGet package has the ID: `MyProject.ExampleNuGet`, so replace that value for your nuget package. The consuming application is `MyProject.ConsumingWebApi`.
{{</ quoteblock >}}


## NuGet file structure
```
MyProject.ExampleNuGet  (Repository level)
 ┣ MyProject.ExampleNuGet
 ┃ ┣ Extensions
 ┃ ┃ ┗ MySpecialThing.cs
 ┃ ┣ MyProject.ExampleNuGet.csproj
 ┃ ┗ MyProject.ExampleNuGet.props
 ┣ MyProject.ExampleNuGet.sln
 ┗ nuget.config
```

## MyProject.ExampleNuGet.props
The NuGet package has a .props-file to enforce some property's to the consumers.
```xml {linenos=table}
<Project>
  <PropertyGroup>
    <!-- Enable output XML Docs for Swagger. -->
    <GenerateDocumentationFile>true</GenerateDocumentationFile>
    <!-- Disable missing XML comment warnings. -->
    <NoWarn>$(NoWarn);1591</NoWarn>
  </PropertyGroup>
</Project>
```
## MyProject.ExampleNuGet.csproj
Important is to set the build action of the `MyProject.ExampleNuGet.props` file to package it to the build directory. See the example below:
```xml {linenos=table}
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net6.0</TargetFramework>
  </PropertyGroup>

  <ItemGroup>
    <None Update="MyProject.ExampleNuGet.props" Pack="true" PackagePath="build">
    </None>
  </ItemGroup>

</Project>
```

## Conclusion
When installing this package on for example `MyProject.ConsumingWebApi` a file is generated in de build folder `MyProject.ConsumingWebApi.csproj.nuget.g.targets`.
This ensures the setting is on when building `MyProject.ConsumingWebApi`.


## References
I used the following resources to fix my problem.
- https://stackoverflow.com/questions/67263924/create-nuget-containing-shared-project-properties-automatic-references
- https://learn.microsoft.com/en-us/nuget/concepts/msbuild-props-and-targets#packagereference-projects