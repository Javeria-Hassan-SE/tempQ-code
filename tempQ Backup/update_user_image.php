<?php
include 'db_config.php';
global $conn;
$userId = $userImage = "";


if ($_SERVER["REQUEST_METHOD"] == "POST") {
    //$_POST = json_decode(file_get_contents('php://input'), true);
	$userId = (isset($_POST['userId']) ? $_POST['userId'] : '');
	$userImage = (isset($_POST['userImage']) ? $_POST['userImage'] : '');

	$updateQuery = "UPDATE user_info SET user_image='$userImage' WHERE user_id='$userId'";
	$query = mysqli_query($conn, $updateQuery);
	if ($query) {
		echo json_encode("Success");
    }
    else{
        echo json_encode("Error");
        }
}
$conn->close();
?>