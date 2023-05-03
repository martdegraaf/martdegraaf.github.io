+++
weight = 3
+++

{{% reveal/section %}}

# Visueel

Content en vormgeving

{{% reveal/note %}}
Een blog post bestaat uit elementen die samen de informatie tot een inzichtelijk geheel maken.
{{% /reveal/note %}}

---

![Text](post-schrijven/img/visual-blog-full.nl.png)

---

## Tekst
<h4 style="color:#D50965">Must have</h4>

- Kopjes - <span style="font-size:0.8em">minstens 3 levels</span>
- Paragrafen
- Bullets
- Inline - <span style="font-size:0.8em">*vet*, _cursief_, `code`</span>
- Hyperlinks - <span style="font-size:0.8em">met target</span>

---

![Quotes](post-schrijven/img/typography-text-4.nl.png)  
_Tekstblokken en stijlen_

---

## Tekst
<h4 style="color:#D50965">Should have</h4>

- Tabel
- Pull quotes
  - Block quote
  - Notes
  - Alerts

{{% reveal/note %}}
Pull quotes zijn tekstkaders die buiten de hoofdtekst staan en extra toelichting of accenten geven.
{{% /reveal/note %}}

---

![Quote](post-schrijven/img/typography-quote.nl.png)  
_Quote_

---

![Note](post-schrijven/img/typography-note.nl.png)  
_Note_

---

![Alert](post-schrijven/img/typography-alerts-1.nl.png)  
_Alerts_

---
## Code

- Inline 
- Snippets  
  <span style="font-size:0.8em">met syntax highlighting & copy/paste</span>
- GitHub Gists

--- 
![Snippets](post-schrijven/img/code-inline-snippet.nl.png)  
_Inline en snippet_

{{% reveal/note %}}
Let op de formatting van de code, voeg comments toe. Copy/paste moet mogelijk zijn.
{{% /reveal/note %}}

---
![Snippets](post-schrijven/img/code-gist.nl.png)  
_Gist_

{{% reveal/note %}}
Gists zijn voor grotere stukken code die 1-op-1 kunnen worden gebruikt
{{% /reveal/note %}}

---
## Media
- Afbeeldingen
- Video

{{% reveal/note %}}
Afbeeldingen maken content aantrekkelijk. Gebruik gratis foto's of eigen materiaal.
{{% /reveal/note %}}

---
![Snippets](post-schrijven/img/visual-video-1.nl.png)  
_Media_

{{% reveal/note %}}
Bedenk of je een functie wilt om videos en afbeeldingen groter of full screen te bekijken
{{% /reveal/note %}}

---
## Witruimte

- Het verschil tussen rommelig en overzichtelijk
- Vrije ruimte rondom tekst en media
- Ruimte tussen de regels  
  💡 _Iets meer regelafstand leest makkelijker_
- Bladspeigel - breedte van tekstblokken  
  💡 _Kortere tekstregels lezen makkelijker_

---
![Snippets](post-schrijven/img/visual-image-1.nl.png)  
_Whitespace_

{{% reveal/note %}}
Let op de ruimte tussen header, paragraaf en afbeelding. Tekst kade vult niet uit.
{{% /reveal/note %}}

---
## Toegankelijkheid
- Contrast - <span style="font-size:0.8em">pas op met kleuren<span>
- Herkenbaar en bruikbaar - <span style="font-size:0.8em">menu, links en buttons</span>
- Semantic HTML  
  ```html
  <nav>☰</nav>
  <main>
    <article>
        <h1>Writing a post</h1>
    </article>
  </main>
  <footer>© Me in 2023</footer>
  ```
- Alt tekst bij afbeeldingen en figuren  
  ```html
  <img alt="A black and white cat" src="cats.png">
  ```

{{% reveal/note %}}
Tekst moet niet wegvallen tegen de achtergrond. Links moeten herkenbaar zijn.
Denk ook aan touch devices waar geen hover is.

Probeer eens de tab index van jouw posts uit, klopt deze met wat je verwacht?
Zijn links "_blank" of niet? (Open in new tab)
{{% /reveal/note %}}

{{% /reveal/section %}}