<?php
include 'db_config.php';
global $conn;
$deviceId = "";

$sql = "SELECT * FROM user_info";
$data = array();
$result = mysqli_query($conn, $sql);
$count = mysqli_num_rows($result);
if ($count > 0) {
    while($row = $result->fetch_assoc()){
		$data [] = $row;
	}
	echo json_encode($data);
	 //echo $data;
} else {
    	echo json_encode("Error");
}

$conn->close();
?>