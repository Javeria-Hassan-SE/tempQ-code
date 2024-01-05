<?php

// $servername = "localhost";

// // REPLACE with your Database name
// $dbname = "thingsro_tempq_db";
// // REPLACE with Database user
// $username = "thingsro_tempqadmin";
// // REPLACE with Database user password
// $password = "Royalh@22";

$servername = "localhost";

// REPLACE with your Database name
$dbname = "tecroamc_tempq";
// REPLACE with Database user
$username = "tecroamc_tempqUser";
// REPLACE with Database user password
$password = "tempQ@77";


$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
	die("Connection failed: " . $conn->connect_error);
}

?>