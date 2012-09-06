<?php

	$control = "None";
	$phone_number = $_REQUEST['From'];
	$body = $_REQUEST['Body'];
	$body = strtolower($body);
	$message = "Player 2: Control not understood. Try (U)p, (D)own, (L)eft or (R)ight.";
	
	if (strpos($body,'l') !== false) {
	    $control = "Left";
	}
	
	if (strpos($body,'r') !== false) {
	    $control = "Right";
	}
	
	if (strpos($body,'u') !== false) {
	    $control = "Up";
	}

	if (strpos($body,'d') !== false) {
	    $control = "Down";
	}
	
	if( $control != "None" )
	{
		$message = "Player 2: Moving $control";
	}

	header("content-type: text/xml");
	echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
?>
<Response>
	<Sms><?php echo $message ?></Sms>
</Response>
