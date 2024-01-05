<?php
include 'db_config.php';
global $conn;
$user_id = "";
$deviceId="";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    //$_POST = json_decode(file_get_contents('php://input'), true);
	$deviceId = (isset($_POST['deviceId']) ? $_POST['deviceId'] : '');
	$sql = "Select device_id FROM user_device WHERE device_id = '" . $deviceId . "'";
	$result = mysqli_query($conn, $sql);
	$count = mysqli_num_rows($result);
	if($result->num_rows > 0){
	    $sql3 = "Update user_device SET enable_request='1' WHERE device_id = '" . $deviceId . "'";
	    $result3 = mysqli_query($conn, $sql3);
	    if($result3){
		    echo json_encode("Success");
	    }
        else{
		    echo json_encode("Error");
	    }
	
	}
	else{
		    echo json_encode("Error");
	}
}
	
$conn->close();
?>