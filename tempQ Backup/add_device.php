<?php
$servername = "localhost";

// REPLACE with your Database name
$dbname = "thingsro_tempq_db";
// REPLACE with Database user
$username = "thingsro_tempqadmin";
// REPLACE with Database user password
$password = "Royalh@22";
$deviceName = $deviceId = $deviceCategory = $securityCode = $user_Name = $is_paid = $userId = $status = "";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
if ($_SERVER["REQUEST_METHOD"] == "POST") {
   // $_POST = json_decode(file_get_contents('php://input'), true);
    $deviceName = (isset($_POST['deviceName']) ? $_POST['deviceName'] : '');
    $deviceId = (isset($_POST['deviceId']) ? $_POST['deviceId'] : '');
    $deviceCategory = (isset($_POST['deviceCategory']) ? $_POST['deviceCategory'] : '');
    $securityCode = (isset($_POST['securityCode']) ? $_POST['securityCode'] : '');
    $user_Name = (isset($_POST['user_Name']) ? $_POST['user_Name'] : '');
    $status = (isset($_POST['status']) ? $_POST['status'] : '');
    $is_paid = "false";

    $sql = "SELECT device_id, status FROM sensors WHERE device_id = '" . $deviceId . "'";
    $result = mysqli_query($conn, $sql);
    $count = mysqli_num_rows($result);

    if ($count == 0) {
        echo json_encode("This device does not exist");
    } else {
        while ($row = $result->fetch_assoc()) {
            $status = $row['status'];
        }
        if ($status == "Activated") {
            echo json_encode("This device is activated already");
        } else {
            $selectStmt = "SELECT user_id FROM user_info WHERE user_email = '" . $user_Name . "' ";
            if ($result = $conn->query($selectStmt)) {
                while ($row = $result->fetch_assoc()) {
                    $userId = $row["user_id"];

                }
                $sql2 = "SELECT device_id FROM user_device where device_id = '". $deviceId ."'";
                $query2 = mysqli_query($conn, $sql2);
                if($query2 && mysqli_num_rows($query2) > 0){
                    echo json_encode("This device is already registered");
                } else{
                    $sql3 = "SELECT device_name FROM user_device WHERE user_id = '" . $userId . "' AND device_name = '". $deviceName ."'";
                    $query3 = mysqli_query($conn, $sql3);
                    if($query3 && mysqli_num_rows($query3) > 0){
                        echo json_encode("You have registeed this device name already");
                    } 
                    else {
                        $insertQuery = "INSERT INTO user_device(device_id,device_name, user_id, device_cat,security_code,is_paid, status)VALUES
                    ('" . $deviceId . "','" . $deviceName . "','" . $userId . "','" . $deviceCategory . "'
                    ,'" . $securityCode . "','" . $is_paid . "','" . $status . "')";
                        $query = mysqli_query($conn, $insertQuery);
                        if ($query) {
                            echo json_encode("Success");
                        } else {
                            echo json_encode("Cannot Register your device at this moment");
                        }
                    }

                }
                
            } else {
                echo json_encode("Incorrect User Email");
            }
        }

    }
}

$conn->close();
?>