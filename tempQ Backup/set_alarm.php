<?php
include 'db_config.php';
global $conn;
$userId = $deviceId = $min =  $max  ="";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    //$_POST = json_decode(file_get_contents('php://input'), true);
	$userId = (isset($_POST['user_id']) ? $_POST['user_id'] : '');
	$deviceId = (isset($_POST['deviceId']) ? $_POST['deviceId'] : '');
	$min = (isset($_POST['min']) ? $_POST['min'] : '');
	$max = (isset($_POST['max']) ? $_POST['max'] : '');
	
	 $sql = "SELECT device_id FROM sensor_alarm WHERE device_id = '" . $deviceId . "'";
	    $result = mysqli_query($conn, $sql);
	    $count = mysqli_num_rows($result);
	    $result->free();
	    if ($count >= 1) {
		    $updateQuery = "Update sensor_alarm SET user_id='" . $userId . "', device_id = '" . $deviceId . "',minValue = '" . $min . "', maximumValue = '" . $max . "' Where device_id = '" . $deviceId . "' ";
			$query1 = mysqli_query($conn, $updateQuery);
			if ($query1) {
				echo json_encode("Success");
			}else{
                echo json_encode("Error");
            }
	    } else {
    
        $insertQuery = "INSERT INTO sensor_alarm(user_id, device_id,minValue, maximumValue)VALUES
		('" . $userId . "','" . $deviceId . "','" . $min . "','" . $max . "')";
			$query = mysqli_query($conn, $insertQuery);
			if ($query) {
				echo json_encode("Success");
			}else{
                echo json_encode("Error");
            }
	    }
    }
$conn->close();
?>
