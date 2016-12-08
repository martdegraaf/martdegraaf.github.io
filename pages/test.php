<?php
$baseUrl = "https://www.hihaho.com";
if(isset($_GET["env"])){
    $env = $_GET["env"];
    $baseUrl = "https://" . $env . ".hihaho.com";
}
        
        
$response = file_get_contents($baseUrl . "/user/showcase/videos");
$jsonResponse = json_decode($response);
$videos = $jsonResponse->videos;
?>
<h1>HiHaHo testing page</h1>
<p>
    Deze pagina haalt alle showcase videos op. Zet ?env=staging voor een andere environment.
</p>
Select the video here:
<select id='hihahoVideo' onChange="changeIframe(this);">
<?php
foreach($videos as $video){
    ?>
    <option value="<?= $baseUrl . '/embed/' . $video->Embed ?>?autoplay=1&controls=1"><?= $video->Title ?></option>
    
    <?php
}
?>
</select>
<br>
<br>
<iframe id="demoVideo" src="<?= $baseUrl . '/embed/' . $videos[0]->Embed ?>?autoplay=0&controls=1" width="1280" height="720" frameborder="0" allowfullscreen=""></iframe>

<script>
    function changeIframe(context){
        var newUrl = context.options[context.selectedIndex].value;
        
        var demoVideo = document.getElementById('demoVideo');
        
        demoVideo.src = newUrl;
    }
</script>