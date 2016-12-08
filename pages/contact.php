
<style>
    @media (max-height: 500px){
        .googlemapwrap{
            width: 100%;
            height: 120px;
            position: relative;
        }
        social-icons{
            position: absolute;
            top: -15px;
            left: 0px;
            right: 0px;
        }
    }
    @media (min-height: 501px){
        .googlemapwrap{
            width: 100%;
            height: 200px;
            position: relative;
        }
        social-icons{
            position: absolute;
            top: -25px;
            left: 0px;
            right: 0px;
        }
    }
    google-map::shadow #map{
        
    }
    base-card{
        width: 100%;
    }
    
</style>
<div class="googlemapwrap">
    <google-map latitude="53.004941" longitude="6.543239" minzoom="15" maxzoom="20" fit>
        <google-map-marker latitude="53.004941" longitude="6.543239"
            title="Mart Software">
                <address>
                    <strong>Mart Software</strong><br>
                    Geulstraat 73<br>
                    Assen, 9406RR<br>
                    Nederland
                </address>
        </google-map-marker>
    </google-map>
</div>
<base-card>
    <p></p>
    <h2>Contactgegevens</h2>
    <p>
        Neem eenvoudig contact met mij op via de onderstaande media of stuur direct een mail naar <b>mart@martdegraaf.nl</b>.
    </p>
    <p></p>
    <a href="skype:martdegraaf?chat"><img class="skypeStatus " src="http://mystatus.skype.com/martdegraaf"/></a>
    <address>
        <strong>Mart Software</strong><br>
        Geulstraat 73<br>
        Assen, 9406 RR<br>
        Nederland
    </address>
    <i>
        <br>
        KvK-nummer: 59150718 <br>
        VATnr.: NL 217.044.633.B01<br>
    </i>
    <p></p>
    <p></p>
    <social-icons></social-icons>
</base-card>