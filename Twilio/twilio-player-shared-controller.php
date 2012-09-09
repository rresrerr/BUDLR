<?php
	$control = "None";
	$phone_number = $_REQUEST['From'];
	$body = $_REQUEST['Body'];
	$body = strtolower($body);
	$id = $_GET['id'];
	$message = "Player $player: Control not understood. Try (U)p, (D)own, (L)eft or (R)ight.";
	
	if( $control != "None" )
	{
		$message = "Player $player: Moving $control";
		
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

				if (strpos($body,'b') !== false) {
				    $control = "Bomb";
				}
				
				$query=" INSERT INTO controls (id, player, control ) VALUES ('$id', '$player', '$control')";
				if ( !mysql_query($query) )
				{
					$message = "MYSQL ERROR: query failed.";
				}
			}
		}
	}

	header("content-type: text/xml");
	echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
?>