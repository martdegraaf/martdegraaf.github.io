---
title: "BMAD versus Spec-Driven Development met Spec Kit"
slug: "bmad-versus-spec-driven-development-speckit"
date: 2026-09-09T09:00:00+02:00
publishdate: 2026-09-09T09:00:00+02:00
draft: true
author: ["Mart de Graaf"]
tags: ["ai", "agentic development", "bmad", "spec-driven development", "spec kit"]
summary: "Een feitelijke vergelijking tussen BMAD-METHOD en Spec-Driven Development met Spec Kit, met praktische keuzes voor teams die AI serieus in software delivery willen inzetten."
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
    alt: "Architectuurschets met AI workflows en specificaties" # alt text
    caption: "Van prompt naar gecontroleerde software delivery" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

AI coding agents maken teams sneller. Dat deel is inmiddels duidelijk. De echte vraag is: hoe zorg je dat snelheid niet ten koste gaat van richting, kwaliteit en uitlegbaarheid?

In deze post vergelijk ik twee concrete benaderingen:

- **BMAD-METHOD** (bron: `bmad-code-org/BMAD-METHOD`)
- **Spec-Driven Development met Spec Kit** (bron: `github/spec-kit`)

Niet als marketingvergelijking, maar als praktische keuzehulp voor teams die AI volwassen willen inzetten.

## Welke bronnen ik gebruik

Voor BMAD baseer ik me op de officiële repository:

- https://github.com/bmad-code-org/BMAD-METHOD

Voor Spec Kit baseer ik me op de officiële repository:

- https://github.com/github/spec-kit

Alle vergelijkingen hieronder zijn terug te leiden naar informatie uit deze bronnen.

## BMAD in het kort

Volgens de BMAD README staat BMAD voor **Agile AI Driven Development** en wil het de hele delivery-cyclus afdekken: van verhelderen en plannen tot bouwen, verifiëren en leren.

Wat opvalt in de positionering:

1. **Right-sized process**: kleine wijzigingen kunnen direct naar build, grotere veranderingen krijgen meer planningsdiepte.
2. **Durable context**: beslissingen blijven expliciet en worden meegenomen naar vervolgstappen.
3. **Nieuw en bestaand codebase**: BMAD richt zich expliciet op zowel greenfield als brownfield.
4. **Workflow-ecosysteem**: naast de kernmethode zijn er modules en aanvullende workflows.

In de quickstart noemt BMAD onder andere `bmad setup` en vervolgens `bmad-build` als startpunt voor delivery in een project.

## Spec-Driven Development met Spec Kit in het kort

Volgens de Spec Kit README is het een open source toolkit om eerst te definiëren **wat** je bouwt en **waarom**, voordat je naar implementatie gaat met een AI coding agent.

De kernflow die Spec Kit beschrijft:

1. `/speckit.constitution`
2. `/speckit.specify`
3. `/speckit.plan`
4. `/speckit.tasks`
5. `/speckit.implement`
6. `/speckit.converge`

Opvallend detail: Spec Kit benoemt expliciet dat je stap 5 en 6 herhaalt tot de uitkomst "Converged" is. Daarnaast heeft het uitbreidbaarheid via **extensions**, **presets** en **bundles**.

## De vergelijking: waar zit het echte verschil?

| Dimensie | BMAD-METHOD | Spec Kit |
| --- | --- | --- |
| Primaire framing | Agile AI Driven Development | Spec-Driven Development |
| Scope | End-to-end deliverymethode met meerdere paden | Gestructureerde specificatie-naar-implementatie flow |
| Startpunt | Context en change scope bepalen, dan passende diepte | Constitution en specificatie als vaste basis |
| Besturingsprincipe | Process "right-sized" maken op complexiteit | Eerst specificeren, dan plannen en uitvoeren |
| Iteratievorm | Delivery loop met leren en bijsturen | Converge-loop tegen spec/plan/tasks |
| Aanpasbaarheid | Modules en workflows in BMAD-ecosysteem | Extensions, presets en bundles |

## Wanneer kies je wat?

In de praktijk zien wij drie patronen.

1. **Kies BMAD als governance en routekeuze centraal staan**.
   BMAD is sterk wanneer je per change expliciet wilt bepalen hoeveel proces nodig is en wanneer je meerdere rollen en perspectieven wilt borgen.
2. **Kies Spec Kit als artifact-discipline centraal staat**.
   Spec Kit is sterk wanneer je team consistente specs, plannen en taken als harde tussenproducten wil afdwingen.
3. **Combineer ze wanneer je beide nodig hebt**.
   BMAD kan de overkoepelende delivery-aanpak zijn; Spec Kit kan binnen die aanpak de specificatie- en convergentiestappen structureren.

## Wat dit zegt over AI-volwassenheid

Veel teams gebruiken AI nog als "slimme autocomplete". Dat is nuttig, maar beperkt. Zowel BMAD als Spec Kit laten een volwassener patroon zien:

1. Besluiten expliciet maken.
2. Context als artefact vastleggen.
3. Iteratief toetsen of implementatie nog in lijn is met intentie.

Precies daar zit voor ons bij Vitas de kern. AI-waarde ontstaat niet door meer prompts, maar door beter ingerichte delivery-systemen waarin menselijk oordeel, traceerbaarheid en feedbacklussen centraal staan.

## Conclusie

BMAD en Spec Kit concurreren niet per se; ze optimaliseren een ander zwaartepunt.

- BMAD optimaliseert de **delivery-aanpak over de hele keten**.
- Spec Kit optimaliseert de **specificatiegedreven uitvoering en convergentie**.

Voor organisaties die AI serieus willen inzetten, is de relevante vraag daarom niet "welke tool is beter?" maar: **welke werkwijze dwingt in onze context de juiste beslissingen af, op het juiste moment?**

## Referenties

- https://github.com/bmad-code-org/BMAD-METHOD
- https://github.com/github/spec-kit
