+++
weight = 1
+++

{{% reveal/section %}}

## Wat is .NET Standard?

- **.NET Standard** is een formele specificatie van .NET API's die beschikbaar zijn in alle .NET-implementaties.
- Het zorgt ervoor dat code die je schrijft in een bibliotheek **compatibel** is met meerdere platformen zoals:
  - .NET Framework
  - .NET Core
  - Xamarin
  - Unity

---

## Waarom .NET Standard gebruiken?

- **Cross-platform compatibiliteit:** Schrijf één keer een library en gebruik deze op verschillende .NET-implementaties.
- **Herbruikbaarheid:** Je NuGet-pakket werkt op alle platformen die .NET Standard ondersteunen.
- **Voorkomt duplicatie:** Voorkomt het onderhouden van verschillende versies van een library voor verschillende platformen.

---

## .NET Standard versus .NET Core en .NET 5+

- **.NET Core** en **.NET 5/6/7+** bieden specifieke implementaties voor moderne platformen, maar zijn niet altijd compatibel met oudere platformen zoals .NET Framework.
- **.NET Standard** lost dit probleem op door een gemeenschappelijke API-set te bieden die **breed compatibel** is.
  
### Welke te kiezen?

- Voor **cross-platform libraries** kies je vaak voor .NET Standard.
- Voor **toekomstgericht** werk en **nieuwe projecten** wordt .NET 6+ aangeraden.

---

## Versies van .NET Standard

- Verschillende versies van .NET Standard bieden verschillende niveaus van API-ondersteuning.
  
### Veelgebruikte versies:
  
- **.NET Standard 2.0:**
  - Ondersteunt .NET Core 2.0, .NET Framework 4.6.1 en hoger, Xamarin.
  - Brede compatibiliteit en wordt vaak gebruikt in NuGet-packages.
  
- **.NET Standard 2.1:**
  - Ondersteunt alleen .NET Core 3.0+ en Xamarin.
  - Niet compatibel met .NET Framework, maar biedt nieuwe API’s.

---

## .NET Standard en NuGet-packages

- Als je een **NuGet-package** maakt, kun je in het `.csproj`-bestand specificeren voor welke platformen je wilt dat het compatibel is.
  
- Stel je **Target Framework** in:
  
```xml
<PropertyGroup>
  <TargetFramework>netstandard2.0</TargetFramework>
</PropertyGroup>
```

- Dit zorgt ervoor dat je package werkt op alle platformen die **.NET Standard 2.0** ondersteunen.

{{% /reveal/section %}}
