<?php
	$control = "None";
	$phone_number = $_REQUEST['From'];
	$body = $_REQUEST['Body'];
	$body = strtolower($body);
	$id = $_GET['id'];
	$message = "Player $player: Control not understood. Try (U)p, (D)own, (L)eft or (R)ight.";
	
	// Send control to server
	if ( !mysql_connect("mysql.travis.aristomatic.com","travischen","ghandi") )
	{
		$message = "MYSQL ERROR: could not connect to mysel server.";
	}
	else
	{
		if( !mysql_select_db("disrupt_controls") )
		{
			$message = "MYSQL ERROR: can't select DB.";	
		}
		else
		{
			for ( $i=0; $i < strlen($body); $i++ ) {  
				
				$character = substr($body, $i,1); 
				$control = "None";
				
				if ( $character == "l" ) {
				    $control = "Left";
				}

				if ( $character == "r" ) {
				    $control = "Right";
				}

				if ( $character == "u" ) {
				    $control = "Up";
				}

				if ( $character == "d" ) {
				    $control = "Down";
				}

				if ( $character == "b" ) {
				    $control = "Bomb";
				}

				if ( $control != "None" ) {
					$query="INSERT INTO controls (id, player, control ) VALUES ('$id', '$player', '$control')";
					$message = "Player 1, Control Sent: $body";
					if ( !mysql_query($query) )
					{
						$message = "MYSQL ERROR: Query failed";
					}
				}
			}
		}
	}

	header("content-type: text/xml");
	echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
?>