<?php
include("lp_source.php");
?>
<html>
<head>
<title>Little Poll Test Facility</title>
<basefont size="2" face="Verdana">
</head>
<body bgcolor="#000000" text="#FFFFFF" link="#FFFFFF" vlink="#FFFFFF">
<center>
<br>
<h1>The Amazing Little Poll Test Facility</h1>
<br>
<br>
<table border=0 width=400 bgcolor=#FFFFFF>
	<tr>
    	<td><font size=2 color=#000000>
        	<strong><?php echo($mainstr); ?></strong>
        </td>
    </tr>
    <tr>
        <td bgcolor="#000000">
            <font size="1" color="#FFFFFF">
            <br>
            <blockquote>
            <?php echo($question); ?><br><br>
			<?php
			if($votingstep==1) { echo($step1str); }
			if($votingstep==2) { echo($step2str); }
			if($votingstep==3) { echo($step3str); }
			?><br>
			Number of votes: <?php echo($totalvotes); ?>
            </blockquote></td>
    </tr>
    <tr>
        <td bgcolor="#000000">
            <font size="2" color="#FFFFFF">
            <blockquote><br>
          	<a href="lp_silly.php">Link to other Page</a><br>
          	<a href="lp_recookie.php">Reset my Cookie, baby!</a>
          	</blockquote>
        </td>
    </tr>
</table>
</center>
</body>
</html>