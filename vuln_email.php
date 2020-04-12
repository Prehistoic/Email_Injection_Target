<html>
	<head>
		<title>Vulnerable contact page</title>
		<link rel="stylesheet" href="email.css"/>
	</head>

	<body>
		<form method="POST" action="<?=$_SERVER['PHP_SELF'];?>">
			<fieldset>
				<legend>Send us a mail</legend>

				<label for="sender">From : </label>
				<input type="text" name="from" id="sender">
				</br>
				<label for="subject">Subject : </label>
				<input type="text" name="subject" id="subject">
				</br>
				<label for="message">Your message : </label>
				<input type="text" name="message" id="message">
			</fieldset>
			<p>
				<input type="submit" value="Send"/>
				<input type="reset" value="Cancel"/>
			</p>
		</form>

		<?php
		if(isset($_POST['from'])) {
			$to = "mat.lac702@gmail.com";
			$from = urldecode($_POST['from']);
			$subject = $_POST['subject'];
		 	$message = $_POST['message'];
		 	$headers = "From: $from\n";
		 	
		 	mail($to, $subject, $message, $headers);
		}

		 ?>
	</body>
</html>
