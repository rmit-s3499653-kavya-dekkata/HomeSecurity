/*$(document).ready(function() {
	$('#olvidado').click(function(e) {
		e.preventDefault();
		$('div#form-olvidado').toggle('500');
	});
	$('#acceso').click(function(e) {
		e.preventDefault();
		$('div#form-olvidado').toggle('500');
	});
	$('#login').click(function(e) {
		 e.preventDefault();
		 document.getElementById('invalid').style.display = "block";
		 if(($('#email').val().length > 0) && ($('#password').val().length > 0) ){
		   if(($('#email').val() === 'user1') && ($('#password').val() === 'password')){
			   $('#invalid').html('<p class="text-success"><strong>success</strong></p>')
			   window.location.href = "dashBoard.jsp";
		   }
		   //$('#invalid').addClass('"alert alert-success"');
		   else{
		     $('#invalid').html('<p class="text-danger"><strong>Invalid user name or password</strong></p>')
		     }
		   }
		});
});
*/