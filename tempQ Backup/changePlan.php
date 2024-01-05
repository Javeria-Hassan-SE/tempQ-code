
<?php
include 'db_config.php';
global $conn;
$deviceId = $planType= $userId= $invId ="";
$activeStatus = "Activated";
$deactiveStatus = "Rejected";
$activePaid = "Yes";
$deactivePaid = "false";
date_default_timezone_set('Asia/Karachi');
$valid_date = date("Y-m-d", strtotime("+1 month"));


if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $_POST = json_decode(file_get_contents('php://input'), true);
	$deviceId = (isset($_POST['deviceId']) ? $_POST['deviceId'] : '');
    $planType = (isset($_POST['status']) ? $_POST['planType'] : '');
    $userId = (isset($_POST['userId']) ? $_POST['userId'] : '');

        $update = "Update user_device SET subs_type = '$planType' , is_paid = '$deactivePaid' WHERE device_id ='$deviceId'" ;
        $query = mysqli_query($conn, $update);
	    if ($query) {
             echo json_encode("Success");
	        }else{
               
              echo json_encode("Error");
            }
}

$conn->close();
?>
