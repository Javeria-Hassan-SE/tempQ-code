 <?php

// Generate a random OTP code
$otp = rand(1000, 9999);

// Set the email address and subject
$to = 'javeria.hassan77@gmail.com';
$subject = 'Your OTP code';

// Set the message body
$message = "Your OTP code is: $otp";

// Set the headers
$headers = "From: javeria.hassan77@gmail.com\r\n";

// Send the email
if (mail($to, $subject, $message)) {
  echo 'OTP code sent successfully';
} else {
  echo 'Error: OTP code not sent';
}
// In this example, we are using the rand function to generate a random OTP code, and the mail function to send it to the user's email address. You can customize the message and subject of the email to suit your needs.

// Note that the mail function may not work on all servers, and you may need to use a third-party library or service to send emails from your PHP scripts


?>