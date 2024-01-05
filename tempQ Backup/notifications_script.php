<?php
include 'db_config.php';
global $conn;

$userId = $deviceId = $sensTemp = $token = " ";
 $_POST = json_decode(file_get_contents('php://input'), true);
$userId = (isset($_POST['userId']) ? $_POST['userId'] : '');
$deviceId = (isset($_POST['deviceId']) ? $_POST['deviceId'] : '');
$sensTemp = (isset($_POST['sensTemp']) ? $_POST['sensTemp'] : '');

$getQuery = "Select token  from login_info where user_id = '" . $userId . "' ";
if ($result = $conn->query($getQuery)) {
    while ($row = $result->fetch_assoc()) {
        $token = $row["token"];
    }
}
$sql = "Select is_notify FROM sensor_alarm WHERE device_id = '" . $deviceId . "'";
$result = mysqli_query($conn, $sql);

// Check if is_notify equals 1
if ($result && mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    $is_notify = $row["is_notify"];
    if ($is_notify == 0) {
        $sql3 = "Update sensor_alarm SET is_notify='1' WHERE device_id = '" . $deviceId . "'";
        $result3 = mysqli_query($conn, $sql3);
        if ($result3) {

            $url = 'https://fcm.googleapis.com/fcm/send';
            $title="Temperature Alert for . $deviceId .  ";
            $description = 'Your current temperature deviates from the set temperature on your alarm. Please check and adjust accordingly.';
            $fields = array(
                'to' => $token,
                'notification' => array(
                    'title' => $title,
                    'body' => $description,
                    'click_action' => 'FLUTTER_NOTIFICATION_CLICK'
                )
            );
            $serverKey = 'AAAA7ll8PFI:APA91bFxBs-pS7GDEw7ROntt-4zY2FK5RRitq074klD0y1IuehVkEZ9abdGPOiE0CM_l_W09GlMnAaVoka90SMid1kdLBEjrcpuNXUvhhCz-mVp7iSRftabrfYCHnDu2XXgQFp8TYOPh';

            $headers = array(
                'Authorization:key=' . $serverKey,
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
            } else {
                $is_sent=1;
                $status_not="norification sent";
                $insertQuery = "INSERT INTO notifications(device_id,user_id, sens_temp,is_sent,status, title, description)VALUES
				('" . $deviceId . "','" . $userId . "','" . $sensTemp . "'
                ,'" . $is_sent . "','" . $status_not . "','" . $title . "','" . $description . "')";
				$query1 = mysqli_query($conn, $insertQuery);
				if ($query1) {
					echo json_encode("Success");
				}
                else {
                    echo json_encode("Error1");
                }
            }
        } else {
            echo json_encode("Error2");
        }
        curl_close($ch);
    } else {
        echo json_encode("Error3");
    }
} else {
    echo json_encode("Error4");
}
?>