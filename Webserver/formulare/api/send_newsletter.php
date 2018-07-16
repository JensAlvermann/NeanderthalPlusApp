<?php 
header('content-type: application/json; charset=utf-8');

if (isset($_GET["firstname"])) {
	$firstname = strip_tags($_GET['firstname']);
	$surname = strip_tags($_GET['surname']);
	$email = strip_tags($_GET['email']);
	$header = "From: ". $firstname . " <" . $email . ">rn"; 

	$ip = $_SERVER['REMOTE_ADDR']; 
	$httpref = $_SERVER['HTTP_REFERER']; 
	$httpagent = $_SERVER['HTTP_USER_AGENT']; 
	$today = date("F j, Y, g:i a");    
	
	$recipient = 'app@neanderthal.de';
	$subject = 'Neanderthal+ App: Anmeldung Newsletter';
	$mailbody = "
First Name: $firstname 
Last Name: $surname 
Email: $email 

Browser info: $httpagent
Referral: $httpref
Sent: $today
";
	$result = 'success';

	if (mail($recipient, $subject, $mailbody, $header)) {
		echo json_encode($result);
	}
}
?>