<?php
include 'db_config.php';
global $conn;
$userId = $userCompany = "";


$sql = "SELECT cat_name FROM sensors_category";
$data = array();
$newResult = $conn->query($sql);
if($newResult->num_rows > 0){
	while($row = $newResult->fetch_assoc()){
		$data [] = $row;
	}
	echo json_encode($data);
}
else{
	echo json_encode($error);
	}
	
$conn->close();
?>