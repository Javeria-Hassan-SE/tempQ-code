<?php
include 'db_config.php';
global $conn;
$user_name = $user_password = "";
$user_type = "user";
$error =  "Error";
date_default_timezone_set('Asia/Karachi');

if ($_SERVER["REQUEST_METHOD"] == "POST") {
   // $_POST = json_decode(file_get_contents('php://input'), true);
	$user_name = (isset($_POST['user_name']) ? $_POST['user_name'] : '');

	$sql = "SELECT * FROM login_info WHERE user_name = '" . $user_name . "' 
     AND user_type = '" . $user_type . "'";
    
	$result = mysqli_query($conn, $sql);
	$count = mysqli_num_rows($result);
	if ($count == 1){
        // Generate a password reset token and expiration date
        $token = bin2hex(random_bytes(16));
        $expiration_date = date('Y-m-d H:i:s', strtotime('+1 day'));

        // Update the user's password reset token and expiration date in the database
        $stmt = $conn->prepare("UPDATE login_info SET reset_token = ?, reset_expiration = ? WHERE user_name = ?");
        $stmt->bind_param("sss", $token, $expiration_date, $user_name);
        $stmt->execute();

        // Send the password reset email
        $to = $user_name;
        $subject = 'Reset Password Request - tempQ by tecRoam';
        //$headers = "Reset Password Request - tempQ by tecRoam";
        // $headers .= "MIME-Version: 1.0\r\n";
        // $headers .= "Content-Type: text/html; charset=UTF-8\r\n";
        $message = 'We received a request to reset your password. If you did not make this request, you can ignore this email.';
        $message .= 'To reset your password, click the following link:';
        $message .= 'http://tempq.tecroam.com/reset_form.php?token=' . $token . ' Reset password';
        $message .= 'This link will expire in 24 hours.';
        if(mail($to, $subject, $message)){
            echo json_encode("Success");
        }else{
            echo json_encode($error);
        }
        // Redirect the user to the password reset confirmation page
       // header('Location: http://tempq.tecroam.com/reset-confirm.php');
        exit; 
	}
	else {
		echo json_encode("Email is not valid");
	}
}
$conn->close();
?>