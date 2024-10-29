+++
weight = 1
+++

{{% reveal/section %}}

## Wat is Azure DevOps Artifacts?

- **Azure DevOps Artifacts** is een service waarmee je NuGet-, npm-, Maven-, Python- en Universal Packages kunt beheren.
- Je kunt eenvoudig:
  - Packages **publiceren** en **opslaan**.
  - Packages **delen** binnen teams.
  - **Versiebeheer** en **dependencies** beheren.
  
---

## Waarom NuGet-pakketten in Azure Artifacts publiceren?

- **Veilig delen:** Beperk toegang tot pakketten binnen je organisatie of project.
- **CI/CD integratie:** Eenvoudige integratie met Azure Pipelines voor geautomatiseerde builds en releases.
- **Versioning en lifecycle management:** Volg en beheer verschillende versies van je packages.

---

## Stap 1: Maak een Artifacts-feed in Azure DevOps

1. Ga naar je **Azure DevOps project**.
2. Klik op **Artifacts** in de zijbalk.
3. Klik op **New Feed**.
4. Vul een naam in voor je feed, bijvoorbeeld `MyProjectFeed`.
5. Stel de feed in op **private** als je de toegang wilt beperken.
6. Klik op **Create**.

---

## Stap 2: Configureer je project voor Azure Artifacts

1. Voeg de Artifacts-feed toe aan je `NuGet.config` bestand:
   
   ```xml
   <configuration>
     <packageSources>
       <add key="AzureDevOps" value="https://pkgs.dev.azure.com/<organization>/<project>/_packaging/<feed>/nuget/v3/index.json" />
     </packageSources>
   </configuration>
   ```

2. Vervang de placeholders `<organization>`, `<project>`, en `<feed>` door je eigen waarden van Azure DevOps.

---

## Stap 3: Maak en pak je NuGet-pakket

1. Maak een NuGet-package zoals eerder besproken:
   
   ```bash
   dotnet pack
   ```

2. Dit genereert een `.nupkg` bestand in de `bin/Debug` map.

---

## Stap 4: Publiceer je NuGet-pakket naar Azure Artifacts

1. Voordat je publiceert, zorg dat je bent ingelogd bij Azure DevOps:
   
   ```bash
   dotnet nuget add source https://pkgs.dev.azure.com/<organization>/<project>/_packaging/<feed>/nuget/v3/index.json --name "AzureDevOps" --username <username> --password <PAT>
   ```

   - **`<PAT>`** is een **Personal Access Token** die je kunt genereren in Azure DevOps.
   
2. Push het pakket naar de feed:

   ```bash
   dotnet nuget push bin/Debug/MathLibrary.1.0.0.nupkg --source "AzureDevOps"
   ```

---

## Stap 5: Toegang beheren en packages gebruiken

1. **Toegangsbeheer**:
   - Ga naar **Artifacts** > **Feeds** > **Permissions** om de toegang tot je feed te beheren.
   - Je kunt toegang geven aan specifieke gebruikers of teams binnen je organisatie.
   
2. **Package gebruiken**:
   - Voeg de feed toe aan je **NuGet.config** bestand in andere projecten.
   - Gebruik je NuGet-pakket zoals elke andere dependency in Visual Studio of via de command-line.

---

## Best Practices voor Azure Artifacts

- **Automatisering:** Integreer package publicatie in je CI/CD pipeline met Azure Pipelines.
- **Versioning:** Gebruik duidelijke versiebeheerpraktijken zoals **semantic versioning**.
- **Toegangsbeheer:** Houd controle over wie pakketten kan publiceren en downloaden.
- **Retentiebeleid:** Stel retentie in om verouderde pakketten automatisch te verwijderen.

{{% /reveal/section %}}
