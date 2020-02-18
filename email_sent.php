<?php
	function decodeHexInput($input) {
		$i = 0;
		while($i<strlen($input)) {
			if($input[$i]=='%') {
				$hex = "" . $input[$i+1] . $input[$i+2];
				$to_replace = "%" . $hex;
				$decoded = hex2bin($hex);
				if($decoded=="\n")
					$decoded = "</br>";
				$input = str_replace($to_replace,$decoded,$input);
				$i=$i+3;
			}
			else {
				$i++;
			}
		}
		return $input;
	}

	$from = $_POST['from'];
	$subject = $_POST['subject'];
 	$message = $_POST['message'];
	$to = 'contact@vuln.com';

	$from = decodeHexInput($from);
	$subject = decodeHexInput($subject);
?>

<html>
	<head>
		<meta charset="utf-8"/>
		<title>Raw output</title>
	</head>
	<body>
		<p>The raw output of the email you just sent would be :</p>
		<p>
			<?php
			if(isset($_POST['from'])) {
			  echo "To: " . $to . "</br>";
			  echo "Subject: " . $subject . "</br>";
			  echo "From: " . $from . "</br>";
			  echo "</br>" . $message;
			}
			?>
		</p>
	</body>
</html>

