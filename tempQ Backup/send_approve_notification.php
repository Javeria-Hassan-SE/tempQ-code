<?php
include 'db_config.php';
global $conn;

$userId= $deviceId=$sensTemp=$token=" ";
//$_POST = json_decode(file_get_contents('php://input'), true);
$userId = (isset($_POST['userId']) ? $_POST['userId'] : '');
$deviceId = (isset($_POST['deviceId']) ? $_POST['deviceId'] : '');


$getQuery = "Select token from login_info where user_id = '" . $userId. "' ";
if ($result = $conn->query($getQuery)) {
  while ($row = $result->fetch_assoc()) {
    $token = $row["token"];
  }
}
$url = 'https://fcm.googleapis.com/fcm/send';
$title="Device Approved";
$description="Your device . $deviceId . has been approved by admin.";
$sens_temp=0;
$fields = array(
  'to' => $token,
  'notification' => array(
    'title' => $title,
    'body' => $description,
    'click_action' => 'FLUTTER_NOTIFICATION_CLICK'
  )
);
$serverKey = 'AAAA7ll8PFI:APA91bFxBs-pS7GDEw7ROntt-4zY2FK5RRitq074klD0y1IuehVkEZ9abdGPOiE0CM_l_W09GlMnAaVoka90SMid1kdLBEjrcpuNXUvhhCz-mVp7iSRftabrfYCHnDu2XXgQFp8TYOPh';
// $headers = array(
//   'Authorization: key=' . 'AAAA7ll8PFI:APA91bFxBs-pS7GDEw7ROntt-4zY2FK5RRitq074klD0y1IuehVkEZ9abdGPOiE0CM_l_W09GlMnAaVoka90SMid1kdLBEjrcpuNXUvhhCz-mVp7iSRftabrfYCHnDu2XXgQFp8TYOPh',
//   'Content-Type: application/json'
// );
$headers = array(
  'Authorization:key='. $serverKey,
  'Content-Type: application/json'
);
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));
$result = curl_exec($ch);
if ($result === FALSE) {
    echo json_encode('Failed');
    die('FCM Send Error: ' . curl_error($ch));
    }
else{
    $insertQuery = "INSERT INTO notifications(device_id,user_id, sens_temp,is_sent,status, title, description)VALUES
				('" . $deviceId . "','" . $userId . "','" . $sensTemp . "'
                ,'Yes ','notification sent','" . $title . "','" . $description . "')";
				$query = mysqli_query($conn, $insertQuery);
				if ($query) {
					echo json_encode("Success");
				}
                else {
                    echo json_encode("Error");
                }
}
curl_close($ch);
?>
