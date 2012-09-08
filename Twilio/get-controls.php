<?php

	// // defining main variables
	// $dbHost = "mysql.travis.aristomatic.com";
	// $dbUser = "travischen";
	// $dbPass = "ghandi";
	// $dbName = "disrupt_controls";
	// $dbTable = "controls";
	// 
	// // connecting and selecting database
	// @mysql_connect($dbHost, $dbUser, $dbPass) or die(mysql_error());
	// @mysql_select_db($dbName) or die(mysql_error());
	// 
	// // getting data
	// $data = "";
	// $res = mysql_query("SELECT * FROM ".$dbTable." ORDER BY id") or die(mysql_error());
	// $index = 0;
	// while($row = mysql_fetch_object($res)) {
	// 	echo "player$index=$row[player]&control$index=$row[control]";
	// 	$index++;
	// }
	
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