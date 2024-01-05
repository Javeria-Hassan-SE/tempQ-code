<?php
include 'db_config.php';
global $conn;
$userId = $userCompany = "";


$sql = "SELECT counter FROM invoice WHERE counter = (SELECT MAX(counter) FROM invoice)";
 $result = mysqli_query($conn, $sql);

// Fetch the result as an associative array
$row = mysqli_fetch_assoc($result);

// Extract the value of the column
$last_value = $row['counter'];
echo json_encode($last_value);

	
$conn->close();
?>