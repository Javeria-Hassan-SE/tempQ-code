<?php
include 'db_config.php';
global $conn;
$deviceId = $user_id= $currentTemp = $minTemp = $maxTemp="";
$status = "Activated";
$array1=array();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
  // $_POST = json_decode(file_get_contents('php://input'), true);
   $user_id = (isset($_POST['user_id']) ? $_POST['user_id'] : '');
    //$user_id = $_POST['user_id'];
    $sql = "SELECT device_id FROM user_device WHERE user_id = '" . $user_id . "' AND  status = '" . $status . "' ";
    $data = array();
    $result = mysqli_query($conn, $sql);
    $count = mysqli_num_rows($result);
    if ($count > 0) {
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
        foreach ($data as $value) {
            $deviceId = $value['device_id'];
            $sql2 = "SELECT sensTempCValue FROM SensorData WHERE deviceId = '" . $deviceId . "' ORDER BY id DESC LIMIT 1";
            $result2 = mysqli_query($conn, $sql2);
            $count2 = mysqli_num_rows($result2);
            if ($count2 > 0) {
                while ($row2 = $result2->fetch_assoc()) {
                    $currentTemp = $row2;
                }
                $insertQuery = "SELECT * FROM sensor_alarm WHERE device_id = '" . $deviceId . "' ";
                $data = array();
                $newResult = $conn->query($insertQuery);
                if ($newResult->num_rows > 0) {
                    while ($row = $newResult->fetch_assoc()) {
                        $minTemp = $row['minValue'];
                        $maxTemp = $row['maximumValue'];
                    }
                    if($currentTemp > $maxTemp || $currentTemp < $minTemp ){
                        $array1[] = $deviceId;
                    }
                }

            }
        }
        if (empty($array1)) {
           echo json_encode("Error");
        }
        else{
           echo json_encode($array1);
        }

    } else {
        echo json_encode("Error");
    }
}
$conn->close();
?>