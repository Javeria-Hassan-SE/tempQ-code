<?php
include 'db_config.php';
global $conn;
date_default_timezone_set('America/New_York');
$d = date("Y-m-d h:i:s");
// $t = date("H:i:s");
// $readingTme = "'".$d. .$t."'";
// Keep this API Key value to be compatible with the ESP8266 code provided in the project page.
// If you change this value, the ESP8266 sketch needs to match
$api_key_value = "tPmAT5Ab3j7F9";
 // Create connection

$api_key = $deviceId =$sensVoltageValue =$percentage =$sensTempCValu=$sensTempFValue = "";
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // $_POST = json_decode(file_get_contents('php://input'), true);
    //echo var_dump($_POST);
    // if($_POST !=null){
    //     $deviceId = $_POST["sensor"];
    //     echo $deviceId;
    // }
    // else{
    //     echo "POST is null";
    // }
    $deviceId = $_POST["sensor"];
    $sensVoltageValue = test_input($_POST["voltage"]);
    $percentage = test_input($_POST["percentage"]);
    $sensTempCValue = test_input($_POST["temperature_C"]);
    $sensTempFValue = test_input($_POST["temperature_F"]);
       
    $sql = "INSERT INTO SensorData (deviceId, sensTempFValue,sensTempCValue ,sensVoltageValue,sensPerc, reading_date_time)
    VALUES ('" . $deviceId . "', '" . $sensTempFValue . "', '" . $sensTempCValue . "', '" . $sensVoltageValue . "', '" . $percentage . "'
    , '" . $d . "')";
       
    if ($conn->query($sql) === TRUE) {
        echo "New record created successfully";
    }
    else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
}

else {
    echo "No data posted with HTTP POST.";
}

$conn->close();

function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}
?>