<?php
include 'db_config.php';
global $conn;
$deviceId = "";

$deviceId = (isset($_POST['deviceId']) ? $_POST['deviceId'] : '');
$sql = "SELECT * FROM user_device INNER JOIN user_info ON user_device.user_id = user_info.user_id INNER JOIN login_info ON 
user_info.user_id = login_info.user_id WHERE device_id = '$deviceId' ";

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