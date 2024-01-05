<?php
include 'db_config.php';
global $conn;
$deviceId = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    //$_POST = json_decode(file_get_contents('php://input'), true);
	$deviceId = (isset($_POST['deviceId']) ? $_POST['deviceId'] : '');

		$sql2 = "Delete FROM sensor_alarm WHERE device_id = '" . $deviceId . "' ";
	    $result2 = mysqli_query($conn, $sql2);
	    if($result2){
		    echo json_encode("Success");
	    }else{
            echo json_encode("Error");
        }
	
}
	
$conn->close();
?>