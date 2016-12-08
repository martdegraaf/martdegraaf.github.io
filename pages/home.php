
<style>
    base-card{
        width: 100%;
    }
    base-card#main{
        font-size: 150%;
        width: 100%;
        height: auto;
    }
    base-card.highlight, base-card.highlight::shadow #Card{
        width: 100%;
        background-color: #b7d3eb;
        
    }
    @media (max-width: 500px) {
      .profile{
            margin-right: auto;
            margin-left: auto;
            display: block;
            width: 75px;
            height: 75px;
            border-radius: 100%;
            border: 2px solid #FFF;
        }
        .big{
            text-align: center;
            font-size: 28px;
            padding-left: 30px;
            display: block;
            height: 60px;
            line-height:60px;
        }
      }
    @media (min-width: 501px) and (max-width: 800px) {
      .profile{
            margin-right: auto;
            margin-left: auto;
            display: block;
            width: 100px;
            height: 100px;
            border-radius: 100%;
            border: 2px solid #FFF;
        }
        .big{
            text-align: center;
            font-size: 56px;
            padding-left: 30px;
            display: block;
            height: 80px;
            line-height:80px;
        }
      }
  @media (min-width:801px) {
        .profile{
            border-radius: 100%;
            border: 2px solid #FFF;
            float: left;
        }
        .big{
            font-size: 72px;
            padding-left: 30px;
            display: inline-block;
            height: 150px;
            line-height:150px;
        }
    }
    
</style>
<base-card class='highlight'>
    <div class='highlightwrap'>
        <img class="profile" src='img/mart.jpg'/>
        <div class="big">
            Mart Software
        </div>
    </div>
</base-card>
<base-card id='main'>
    <h2>Welkom!</h2>
    <p>
        Mijn naam is Mart en ik ben een gedreven software ontwikkelaar. Op dit moment studeer ik Informatica aan de Hanzehogeschool in Groningen en hoop daar in juli(2015) af te studeren onder begeleiding van Centric. 
    </p>
    <p>
        Als software ontwikkelaar werk ik voor mijzelf en voor derden als ZZP'er. Hieronder kunt u lezen met welke talen ik ervaring heb en u kunt in mijn <a href='/portfolio'>portfolio</a> afgelopen projecten bekijken. Wilt u mij inhuren voor een project? <a href="/contact">Neem contact met mij op.</a>
    </p>
</base-card>

<base-card id='skills'>
    <h2>Skills</h2>
    <p>
        Door middel van werken naast mijn opleiding heb ik met meerdere talen en frameworks kennis gemaakt. Hieronder wil ik graag weergeven met welke elementen ik ervaring heb. In mijn <a href='/portfolio'>portfolio</a> staan bij een project beschreven welke talen en frameworks bij het project horen. 
    </p>
    <skill-rating description='PHP' rating='80'>c#.NET</skill-rating>
    <skill-rating description='PHP' rating='80'>ASP.NET</skill-rating>
    <skill-rating description='PHP' rating='85'>HTML</skill-rating>
    <skill-rating description='PHP' rating='86'>CSS</skill-rating>
    <skill-rating description='PHP' rating='82'>JavaScript</skill-rating>
    <skill-rating description='PHP' rating='85'>JQuery</skill-rating>
    <skill-rating description='PHP' rating='87'>PHP</skill-rating>
    <skill-rating description='PHP' rating='80'>SQL</skill-rating>
    <skill-rating description='PHP' rating='72'>Java</skill-rating>
    <skill-rating description='PHP' rating='83'>Android</skill-rating>
    <skill-rating description='PHP' rating='75'>Azure</skill-rating>
</base-card>