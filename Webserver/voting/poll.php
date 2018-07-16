<!DOCTYPE html> 
<?php include("lp_source.php"); ?>
<html> 
	<head> 
	


</head> 
<body style="background-color: #FFF !important;color: #000; text-shadow: none; font-size: 14px !important; font-family: Roboto, sans-serif; "> 

<div data-role="page">



	<div data-role="content">
	

<?php echo($mainstr); ?>

<?php if($votingstep==1) { echo($step1str); } 
      if($votingstep==2) { echo($step2str); } 
      if($votingstep==3) { echo($step3str); }
?>
			
	</div>

</div>

</body>
</html>