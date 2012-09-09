<?php
	// Send control to server
	if ( !mysql_connect("mysql.travis.aristomatic.com","travischen","ghandi") )
	{
	 	echo "MYSQL ERROR: could not connect to mysql server.";
	}
	else
	{
		if( !mysql_select_db("disrupt_controls") )
		{
			echo "MYSQL ERROR: can't select DB.";	
		}
		else
		{
			$query = "SELECT * FROM controls WHERE registered = 0 ORDER BY id";
			$result = mysql_query($query);
			$num = mysql_numrows($result);
			$i=0;
			while ($i < $num) {
				$player = mysql_result($result, $i, "player");
				$control = mysql_result($result, $i, "control");
				$id = mysql_result($result, $i, "id");
				mysql_query( "UPDATE controls SET registered = 1 WHERE id = '$id'" );

				echo "player$i=$player&control$i=$control&";
				$i++;
			}
			echo "count=$i";
		}
	}
	echo $message;
?>