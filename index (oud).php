<!DOCTYPE html>
<html>

<head>

  <title>Mart Software</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta name="viewport" content="width=device-width, minimum-scale=1.0, initial-scale=1.0, user-scalable=yes">
  <link rel="shortcut icon" type="image/x-icon" href="/img/favicon.ico" />
  
  <script type="text/javascript" src="/components/webcomponentsjs/webcomponents.min.js"></script>
  <link rel="import" href="/components/font-roboto/roboto.html">
  <link rel="import" href="/components/font-roboto/roboto.html">
  <link rel="import" href="/components/core-header-panel/core-header-panel.html">
  <link rel="import" href="/components/core-toolbar/core-toolbar.html">
  <link rel="import" href="/components/paper-tabs/paper-tabs.html">
  <link rel="import" href="/components/core-media-query/core-media-query.html">
  <link rel="import" href="/components/paper-item/paper-item.html">
  <link rel="import" href="/components/paper-shadow/paper-shadow.html">
  <link rel="import" href="/components/core-scaffold/core-scaffold.html">
  
  
  <link rel="import" href="/Mycomponents/ContentContainer.html">
  <link rel="import" href="/Mycomponents/project-card.html">

  <style>
  html,body {
    height: 100%;
    margin: 0;
    background-color: #E5E5E5;
    font-family: 'RobotoDraft', sans-serif;
    font-size: 14px;
  }
  core-toolbar {
    background-color: #4C92CE;
    color: white;
  }
  #tabs {
    width: 100%;
    margin: 0;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
	text-transform: uppercase;
  }
  paper-tab::shadow #ink{
    color: #b7d3eb;
  }
  .container {
    width: 80%;
    margin: 50px auto;
  }
  @media (min-width: 481px) {
    .container {
      width: 400px;
    }
  }
  @media (max-width: 800px) {
      #tabs{
          position: absolute;
          bottom: 0px;
          left: 0px;
          right: 0px;
          top: auto;
      }
      #header-toolbar{
          height: 128px;
      }
  }
  @media (min-width: 801px) {
    #tabs, content-container, .toolbar-tools {
        width: 1140px;
        margin-left: auto;
        margin-right: auto;
    }
}
      #tabs{
          left: auto;
      }
  core-toolbar.bottom {
     position: fixed;
     z-index: 10;
     bottom: 0;
     width: 100%;
     box-shadow: 0 -2px 10px 0 rgba(0, 0, 0, 0.16), 0 -2px 5px 0 rgba(0, 0, 0, 0.26);
}
paper-item{
    background-color: #FFF;
    margin-bottom: 10px;
}
core-header-panel {
    position: absolute;
    top: 0;
    bottom: 64px;
    left: 0;
    width: 100%;
    overflow: auto;
    -webkit-overflow-scrolling: touch;
}
paper-fab{
    background-color: #4C92CE;
}
paper-tab a{
    color: #FFF;
    text-decoration: none;
}
content-container a{
    color: #000;
    border-bottom: 2px solid #b7d3eb;
    text-decoration: none;
}
content-container a:hover{
    color: #4C92CE;
    border-bottom: 2px solid #4C92CE;
}
  </style>

</head>
<?php
    $pages = array("contact", "portfolio", "home", "agenda");
    $page = $_GET['page'];
    if(!in_array($page, $pages)){
        $page = "home";
    }
?>
<body unresolved>
  <script>
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-57143312-1', 'auto');
    ga('send', 'pageview');

  </script>

  
  <core-header-panel>

    <core-media-query query="max-width: 740px" queryMatches="false"></core-media-query>
    <core-toolbar id="header-toolbar">
            <h1 id="page-title">Mart Software</h1>
            <paper-tabs id="tabs" class="bottom" selected="<?=$page?>" self-end flex>
                <paper-tab name="home"><a href="/home" horizontal="" center-center="" layout="">Home</a></paper-tab>
                <paper-tab name="portfolio"><a href="/portfolio" horizontal="" center-center="" layout="">Portfolio</a></paper-tab>
                <paper-tab name="contact"><a href="/contact" horizontal="" center-center="" layout="">Contact</a></paper-tab>
            </paper-tabs>
    </core-toolbar>
    
    <content-container id="content" layout horizontal>
        <?php
            include 'pages/' . $page . '.php';
        ?>
    </content-container>

  </core-header-panel>
    <core-toolbar class="bottom" id="FooterBar">
        <span flex indent>
            &copy; Mart Software
        </span>
    </core-toolbar>

  <script>
  var tabs = document.querySelector('paper-tabs');
  var list = document.querySelector('post-list');

  /*tabs.addEventListener('core-select', function() {
    list.show = tabs.selected;
  });*/
  document.addEventListener('core-media-change', function(e) {
    //console.log("media change");
    //alert('\nevent: ' + e.type + ' query: ' + e.detail.media + ' matches: ' + e.detail.matches);
    var isInternetExplorer = navigator.appName.indexOf("Internet Explorer")>0;
    if(!e.detail.matches || isInternetExplorer){
        document.querySelector('#tabs').className = "";
        //add bottom class
    }else{
        document.querySelector('#tabs').className = "bottom";
        //remove bottom class
    }
  });
  </script>
</body>

</html>