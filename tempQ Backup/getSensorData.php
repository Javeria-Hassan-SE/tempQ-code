<?php
include 'db_config.php';
global $conn;
$deviceId = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
   //$_POST = json_decode(file_get_contents('php://input'), true);
	$deviceId = (isset($_POST['deviceId']) ? $_POST['deviceId'] : '');
	$sql = "SELECT * FROM SensorData WHERE deviceId = '" . $deviceId . "' ORDER BY id DESC ";
    $data = array();
	$result = mysqli_query($conn, $sql);
	$count = mysqli_num_rows($result);
	if ($count > 0) {
        while($row = $result->fetch_assoc()){
			$data [] = $row;
		}
		echo json_encode($data);
	} else {
		echo json_encode("Error");
	}
}
$conn->close();
?>