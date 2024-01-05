<?php
include 'db_config.php';
global $conn;
date_default_timezone_set('Asia/Karachi');


if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $userFullName = $userEmail = $userCompany =  $userContact =$userLocation = $userType = $userPassword = $isVerified = $userId="";
    //$_POST = json_decode(file_get_contents('php://input'), true);
    if(!empty($_POST)){
        $userFullName = (isset($_POST['userFullName']) ? $_POST['userFullName'] : "");
	    $userEmail = (isset($_POST['userEmail']) ? $_POST['userEmail'] : '');
	    $userCompany = (isset($_POST['userCompany']) ? $_POST['userCompany'] : '');
	    $userContact = (isset($_POST['userContact']) ? $_POST['userContact'] : '');
	    $userType = (isset($_POST['userType']) ? $_POST['userType'] : '');
	    $userPassword = (isset($_POST['userPassword']) ? $_POST['userPassword'] : '');
        $isVerified = (isset($_POST['isVerified']) ? $_POST['isVerified'] : '');
        $userLocation = (isset($_POST['userLocation']) ? $_POST['userLocation'] : '');
        // $userPassword = md5($userPassword);

	    $sql = "SELECT user_email FROM user_info WHERE user_email = '" . $userEmail . "'";
	    $result = mysqli_query($conn, $sql);
	    $count = mysqli_num_rows($result);
	    $result->free();

	    if ($count == 1) {
		    echo json_encode("User already exist!");
	    } else {
		    $insertStmt = "INSERT INTO user_info(user_full_name,user_email,
		    user_contact,user_company,user_location, user_type)VALUES('" . $userFullName . "','" . $userEmail . "',
		    '" . $userContact . "','" . $userCompany . "', '" . $userLocation . "', '" . $userType . "')";
		    $query = mysqli_query($conn, $insertStmt);
		    if ($query) {
			    $selectStmt = "SELECT user_id FROM user_info WHERE user_email = '" . $userEmail . "'";
			    if ($result2 = $conn->query($selectStmt)) {
				    while ($row = $result2->fetch_assoc()) {
					    $userId = $row["user_id"];
				    }

				    $insertQuery = "INSERT INTO login_info(user_name,password, user_id, user_type, is_verified)VALUES
				    ('" . $userEmail . "','" . $userPassword . "','" . $userId . "','" . $userType . "','" . $isVerified . "')";
				    $loginQuery = mysqli_query($conn, $insertQuery);
				    if ($loginQuery) {
				        $otp = rand(1000, 9999);
				        $is_expired = 0;
						// Set the email address and subject
						$to = $userEmail;
						$subject = 'OTP for Email Verification';
						// Set the message body
						$message = "Dear $userFullName, Your OTP code is: $otp,
						This OTP is valid for one-time use only. Regards, tempQ - A product by tecRoam";
						// Set the headers
						$headers = "From: javeria.hassan77@gmail.com\r\n";
						// Send the email
						if (mail($to, $subject, $message)) {
							$otpQuery = "INSERT INTO otp_expiry(user_id, otp,  is_expire)VALUES
							('" . $userId . "',
							'" . $otp . "',
							'" . $is_expired . "')";
							$otpQuery2 = mysqli_query($conn, $otpQuery);
							if($otpQuery2){
								echo json_encode("Success");
							}
							else{
								echo json_encode("Error");
							}
						} else {
  							echo 'OTP could not sent';
						}
				    }
			    }
		    }
	    }
    }
    else{
        echo json_encode("Error");
    }
}
$conn->close();
?>