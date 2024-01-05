<?php
include 'db_config.php';
global $conn;
$userEmail = $otp = $fetch_OTP= $userID="";
$error =  "Error";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    //$_POST = json_decode(file_get_contents('php://input'), true);
	$userEmail = (isset($_POST['userEmail']) ? $_POST['userEmail'] : '');
	$otp = (isset($_POST['otp']) ? $_POST['otp'] : '');

	$sql = "SELECT user_id FROM login_info WHERE user_name = '" . $userEmail . "'";
    
	    $fetchID = mysqli_query($conn, $sql);
	    while ($row = mysqli_fetch_assoc($fetchID)) {
                $userID =  $row['user_id'];
            }
	$count = mysqli_num_rows($fetchID);
	if ($count == 1){
		  $newSQL = "SELECT otp from otp_expiry where user_id = '" . $userID . "'" ;
		   $newResult = $conn->query($newSQL);
		   while ($row = mysqli_fetch_assoc($newResult)) {
                $fetch_OTP =  $row['otp'];
                }
		if($fetch_OTP == $otp){
			$updateQuery = "UPDATE otp_expiry SET is_expire = '1' WHERE user_id='$userID'";
	        $query = mysqli_query($conn, $updateQuery);
	        if ($query) {
		        $updateQuery2 = "UPDATE login_info SET is_verified = 'true' WHERE user_id='$userID'";
	            $query2 = mysqli_query($conn, $updateQuery2);
	            if ($query2) {
		            echo json_encode("Success");
                }
            }
		}
		else{
			echo json_encode("Invalid OTP");
		}
	}
	else {
		echo json_encode("Invalid Email");
	}
}
$conn->close();
?>