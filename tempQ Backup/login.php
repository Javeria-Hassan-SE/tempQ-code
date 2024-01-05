<?php
include 'db_config.php';
global $conn;
date_default_timezone_set('Asia/Karachi');

$user_name = $user_password = $is_verified = $userId= $token = "";
$user_type = "user";
$error =  "Error";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
  // $_POST = json_decode(file_get_contents('php://input'), true);
	$user_name = (isset($_POST['user_name']) ? $_POST['user_name'] : '');
	$user_password = (isset($_POST['password']) ? $_POST['password'] : '');
	$token = (isset($_POST['token']) ? $_POST['token'] : '');
//  	$user_password = md5($user_password);

	$sql = "SELECT * FROM login_info WHERE user_name = '" . $user_name . "' AND password = '" . $user_password . "' AND user_type = '" . $user_type . "'";
    
	$result = mysqli_query($conn, $sql);
	$count = mysqli_num_rows($result);
	if ($count == 1){
	    while($row = $result->fetch_assoc()){
				$is_verified = $row ['is_verified'];
				$userId = $row['user_id'];
			}
			if($is_verified=="false"){
			    $otp = rand(1000, 9999);
				$is_expired = 0;
				// Set the email address and subject
				$to = $user_name;
				$subject = 'OTP for Email Verification';
				// Set the message body
				$message = "Dear User, Your OTP code is: $otp,
				This OTP is valid for one-time use only. Regards, tempQ - product by tecRoam";
				// Set the headers
				$headers = "From: javeria.hassan77@gmail.com\r\n";
				// Send the email
				if (mail($to, $subject, $message)) {
					$otpQuery = "INSERT INTO otp_expiry(user_id, otp,  is_expire)VALUES('" . $userId . "','" . $otp . "',
							'" . $is_expired . "')";
				    $otpQuery2 = mysqli_query($conn, $otpQuery);
					if($otpQuery2){
						echo json_encode("OTP Send");
					}
					else{
						echo json_encode("Error");
						}
					} else {
  						echo json_encode("Error");
					}
			}
			else{
			    $newSQL = "SELECT * from user_info where user_email = '" . $user_name . "'" ;
		   $data = array();
		   $newResult = $conn->query($newSQL);
		    if($newResult->num_rows > 0){
			    while($row = $newResult->fetch_assoc()){
				    $data [] = $row;
			    }
			    	$sql2 = "Update login_info SET token = '" . $token . "'   WHERE user_name = '" . $user_name . "'";
	                $result2 = mysqli_query($conn, $sql2);
	                 if($result2){
		                echo json_encode($data);
	            }
		        
		    }
		    else{
			    echo json_encode("Error");
		    }
		}
	}
	else {
		echo json_encode("Error");
	}
}
$conn->close();
?>