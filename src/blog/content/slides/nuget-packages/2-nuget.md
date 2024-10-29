+++
weight = 1
+++

{{% reveal/section %}}


## Wat is NuGet?

- **NuGet** is de package manager voor .NET.
- Het biedt een manier om:
  - **Code te delen** tussen projecten en teams.
  - **Externe libraries** te gebruiken zonder het wiel opnieuw uit te vinden.
- Het beheert dependencies en versiebeheer automatisch.

---

## Waarom NuGet-packages maken?

- **Herbruikbare code:** Deel generieke functionaliteit tussen projecten.
- **Efficiënt werken:** Geen code duplicatie meer.
- **Versiebeheer:** Gemakkelijk updates doorvoeren en distribueren.
- **Gedeeld met de wereld:** Publiceer je package op [nuget.org](https://www.nuget.org).

---

## Tools die je nodig hebt

1. **Visual Studio** (of een andere IDE zoals VS Code)
2. **.NET SDK** (met NuGet CLI)
3. **NuGet.org account** (voor het publiceren)

{{% /reveal/section %}}

---

{{% reveal/section %}}

## Voorbeeld: Maak een .NET Class Library

1. Open Visual Studio.
2. Maak een nieuw project: `Class Library`.
3. Voeg een eenvoudige class toe, bijvoorbeeld:
    ```csharp
    public class MathLibrary
    {
        public int Add(int a, int b) => a + b;
    }
    ```

4. **Compileer** het project om te controleren of alles werkt.

---

## Package Metadata toevoegen

- Open het `.csproj`-bestand en voeg de NuGet metadata toe:

```xml
<PropertyGroup>
  <PackageId>MathLibrary</PackageId>
  <Version>1.0.0</Version>
  <Authors>JouwNaam</Authors>
  <Description>Een eenvoudige wiskundige library</Description>
</PropertyGroup>
```

- Deze informatie wordt gebruikt voor het package dat je maakt.

---

## NuGet-package maken

1. Open de **CLI** in de projectmap.
2. Voer het volgende commando uit om een package te genereren:

   ```bash
   dotnet pack
   ```

3. Dit genereert een `.nupkg` bestand in de `bin/Debug` map.

---

## Package testen (lokaal)

1. Maak een nieuw **console project**.
2. Voeg je NuGet-package lokaal toe:

    ```bash
    dotnet add package MathLibrary --source <pad naar lokale map>
    ```

3. Gebruik de class in je code om te testen of het werkt:
    ```csharp
    var math = new MathLibrary();
    Console.WriteLine(math.Add(2, 3));
    ```

---

## Je NuGet-package publiceren

### Stap 1: API-key verkrijgen

- Ga naar [nuget.org](https://www.nuget.org) en **genereer een API-key**.

---

### Stap 2: Package publiceren

- Gebruik het volgende commando om je package te publiceren naar NuGet.org:

    ```bash
    dotnet nuget push bin/Debug/MathLibrary.1.0.0.nupkg --api-key <API_KEY> --source https://api.nuget.org/v3/index.json
    ```

---

## Versiebeheer met NuGet

### Semantic Versioning

- **MAJOR.MINOR.PATCH**
  - **Major:** Brekende wijzigingen.
  - **Minor:** Nieuwe functionaliteiten, geen brekende wijzigingen.
  - **Patch:** Kleine bugfixes.

### Belangrijk om consistentie te waarborgen!

---

## Best Practices voor NuGet-packages

- **Goede documentatie:** Voeg een README of XML-documentatie toe.
- **Versiebeheer:** Gebruik duidelijke en consistente versienummers.
- **Dependency management:** Beheer afhankelijkheden goed om conflicten te voorkomen.
- **Unit tests:** Zorg dat je package voldoende getest is.

{{% /reveal/section %}}