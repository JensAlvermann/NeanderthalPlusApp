$('#send-feedback').live("click", function() {
	var url = 'api/send_newsletter.php';
	var error = 0;
	var $contactpage = $(this).closest('.ui-page');
	var $contactform = $(this).closest('.contact-form');
	$('.required', $contactform).each(function (i) {
        if ($(this).val() === '') {
			error++;
        } 
	}); // each
	if (error > 0) {
			alert('Bitte f\u00fcllen Sie alle Felder aus');	
	} else {
		var firstname = $contactform.find('input[name="firstname"]').val();
		var surname = $contactform.find('input[name="surname"]').val();
		var email = $contactform.find('input[name="email"]').val();	

		//submit the form
		$.ajax({
			type: "GET",
			url: url,
			data: {firstname:firstname, surname:surname, email: email},
            success: function (data) {
				if (data == 'success') {
					// show thank you 
					$contactpage.find('.contact-thankyou').show();
					$contactpage.find('.contact-form').hide();
				}  else {
					alert('Sie können zurzeit nicht in den Newsletter Service eingetragen werden.<br>Bitte versuchen Sie es erneut.');
				}
			}
		}); //$.ajax

	}
	return false;
});
