<?php
include 'db_config.php';
global $conn;
$deviceId ="";


if ($_SERVER["REQUEST_METHOD"] == "POST") {
   //$_POST = json_decode(file_get_contents('php://input'), true);
	$deviceId = (isset($_POST['deviceId']) ? $_POST['deviceId'] : '');
    $insertQuery = "SELECT * FROM sensor_alarm WHERE device_id = '" . $deviceId . "' ORDER BY device_id DESC LIMIT 1 ";
	$data = array();
    $newResult = $conn->query($insertQuery);
    if($newResult->num_rows > 0){
        while($row = $newResult->fetch_assoc()){
            $data [] = $row;
        }
        echo json_encode($data);
    }
    else{
        echo json_encode($error);
    }
}


$conn->close();
?>
