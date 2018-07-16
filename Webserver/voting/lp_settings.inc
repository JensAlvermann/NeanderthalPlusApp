<?php 

//settings for The Amazing Little Poll:


// IMPORTANT: change this one into the name of your homepage file, 
//           for example, index.php
$callingfile="poll.php"; 

// File in which voting scores are kept
$filename = "lplist.txt"; 

// Change this password so no one else can access the lp_admin.php via the web
$pwd="mammut"; 

//Time between votes in seconds
$time_between_votes = 10; 

// Width of graph in pixels
$graph_width = 100; 

// Height of graph in pixels
$graph_height = 15; 

// Messages (Can easily be used as 'dynamic headers' for the poll)
$message1="<br><b>Welches Thema f&uuml;r eine der n&auml;chsten<br>Ausstellungen im Neanderthal Museum<br>w&uuml;rde Sie am meisten interessieren?</b><br><br>";  
$message2="<br><b>Vielen Dank f&uuml;r Ihr Feedback!</b><br><br>";
$message3="<br><b>So wurde bisher abgestimmt</b><br><br>";

// Text on vote button
$vote_str=""; 

// Use CSS code to style the 'vote' button
$buttonstyle="background-image: url(vote.svg); border: 0px; width: 62%; height: 35px;";
?>