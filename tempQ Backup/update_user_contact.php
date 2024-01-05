<?php
include 'db_config.php';
global $conn;
$userId = $userContact = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    //$_POST = json_decode(file_get_contents('php://input'), true);
	$userId = (isset($_POST['userId']) ? $_POST['userId'] : '');
	$userContact = (isset($_POST['userContact']) ? $_POST['userContact'] : '');

	$updateQuery = "UPDATE user_info SET user_contact='$userContact' WHERE user_id='$userId'";
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
