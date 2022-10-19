---
title: "Add properties for consuming apps to a nuget package"
date: 2022-10-19T18:00:00+02:00
publishdate: 2022-10-19T00:00:00+02:00
draft: false
author: ["Mart de Graaf"]
tags: ["Nuget", ".NET"]
summary: This article explains how to make a 
ShowToc: true
---
# Introduction
For a recent project, I wanted to add a property to the consumers from within my nuget package.

For this case i am making a Nuget package with the ID: `MyProject.ExampleNuget`, so replace that value for your project.

## Nuget file structure
```
MyProject.ExampleNuget  (Repository level)
 ┣ MyProject.ExampleNuget
 ┃ ┣ Extensions
 ┃ ┃ ┗ MySpecialThing.cs
 ┃ ┣ MyProject.ExampleNuget.csproj
 ┃ ┣ MyProject.ExampleNuget.csproj.user
 ┃ ┗ MyProject.ExampleNuget.props
 ┣ AMyProject.ExampleNuget.sln
 ┗ nuget.config
```

## MyProject.ExampleNuget.props
To enforce some property's to the consumers of my Nuget package.
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
## MyProject.ExampleNuget.csproj
Important is to set the build action of the `MyProject.ExampleNuget.props` file to package it to the build directory. See the example below:
```xml {linenos=table}
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net6.0</TargetFramework>
  </PropertyGroup>

  <ItemGroup>
    <None Update="MyProject.ExampleNuget.props" Pack="true" PackagePath="build">
    </None>
  </ItemGroup>

</Project>
```

## References
I used the following resources to fix my problem.
- https://stackoverflow.com/questions/67263924/create-nuget-containing-shared-project-properties-automatic-references
- https://learn.microsoft.com/en-us/nuget/concepts/msbuild-props-and-targets#packagereference-projects