<?php
// Version 1.4 - optimized for PHP 5.4
date_default_timezone_set('UTC');
include("lp_settings.inc"); //include file containing general settings




if (!isset($_COOKIE['votingstep'])) {
	$votingstep=1;
	} else { $votingstep = $_COOKIE['votingstep']; }

function SumArray($arr) {
	$h=count($arr); $in=0; $m=0;
	while ($in<$h) { $m += $arr[$in]; $in++;	}
	return $m;
}

function getIP() {
	if (getenv("HTTP_CLIENT_IP")) $ip = getenv("HTTP_CLIENT_IP");
	else if(getenv("HTTP_X_FORWARDED_FOR")) $ip = getenv("HTTP_X_FORWARDED_FOR");
	else if(getenv("REMOTE_ADDR")) $ip = getenv("REMOTE_ADDR");
	else $ip = "UNKNOWN";
return $ip;
}

function write2log ($linetoadd) {
	$rightnow=date("F j, Y, g:i a");
	$fplog=fopen('lp_log.dat', "a");
	fputs($fplog, getIP()."|".$rightnow."|".$linetoadd."\n");
	fclose($fplog);
}

function ReadElements() {
	global $filename;
	$fp=fopen($filename, "r");
	$file_contents=fread($fp,filesize($filename)-1);
	fclose($fp);
	$elements=explode(":",$file_contents);
	$h=(count($elements)-1)/2;
	$question=stripslashes($elements[0]);
	$in=0;
	while ($h>$in) {
		$item[$in]=$elements[(2*$in+1)];
		$itemvoted[$in]=$elements[(2*$in+2)];
		$in++;
	}
	return array ($item, $itemvoted, $question);
}

list ($item, $itemvoted, $question) = ReadElements();

if(isset($_COOKIE['pollidcookie'])) {
	if ($question != stripslashes($_COOKIE['pollidcookie'])) {
	$votingstep=1;
	}
}
setcookie("pollidcookie", $question, time()+$time_between_votes);


function ShowTheStuff($item, $itemvoted, $graph_width, $graph_height) {
	$hector=count($itemvoted);$totalvotes=0;$in=0;$stepstr='';
	$totalvotes=SumArray($itemvoted);
	$in=0;
	if ($totalvotes==0) { $totalvotes=0.0001; }
	while ($in<$hector) {
		$stepstr=$stepstr.stripslashes($item[$in]).': '.(int)(($itemvoted[$in]/$totalvotes)*100).'%<br>';
		$timesred=(int)((($itemvoted[$in]/$totalvotes))*$graph_width);
		$stepstr=$stepstr.'<img height='.$graph_height.' width='.$timesred.' src="lp_1.gif"><img height='.$graph_height.' width='.($graph_width-$timesred).' src="lp_0.gif"><br><br>';
		$in++;
	}
	return $stepstr;
}


if (!isset($votingstep)) {
	$votingstep=1;
	}

if ($votingstep==2) {
	if(!isset($_POST['radios'])){
		$votingstep=1;
		write2log("Clicked vote button without choosing an item");
	} // detect if someone has clicked the voting button without choosing an item
}

if ($votingstep==1) {
	write2log("Enters Poll");
	setcookie("votingstep","2",time()+$time_between_votes);
	$mainstr=$message1;
	$step1str='<form action="'.$callingfile.'" method="post" name="form1">';
	$totalvotes=SumArray($itemvoted);
	$in=0;
	$datop=count($item);
	while($in<$datop){
		$step1str=$step1str.'<input type="radio" name="radios" value="'.$in.'"> '.stripslashes($item[$in]).'<br>';
		$in++;
	}
	$step1str=$step1str.'<br><input style="'.$buttonstyle.'" type="Submit" value="'.$vote_str.'"></form>';
}

if ($votingstep==2) {
	setcookie("votingstep","3",time()+$time_between_votes);
	$mainstr=$message2;
	$itemvoted[$_POST['radios']]=$itemvoted[$_POST['radios']]+1;
	$totalvotes=SumArray($itemvoted);
	$fp=fopen($filename, "w");
	$hector=count($item);
	$in=0;
	$linetoadd=$question.':';
	fputs($fp, $linetoadd);
	while($in<$hector) {
		$linetoadd=$item[$in].':'.$itemvoted[$in].':';
		fputs($fp, $linetoadd);
		$in++;
	}
	fclose($fp);
	write2log("Vote received on ".$item[$_POST['radios']]);
	$step2str=ShowTheStuff($item, $itemvoted, $graph_width, $graph_height);
}
if ($votingstep==3) {
	$mainstr=$message3;
	$totalvotes=SumArray($itemvoted);
	write2log("Views results");
	$step3str=ShowTheStuff($item, $itemvoted, $graph_width, $graph_height);
}

?>
