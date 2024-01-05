<?php
include 'db_config.php';
global $conn;
$userId = $userEmail = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
   // $_POST = json_decode(file_get_contents('php://input'), true);
	$userId = (isset($_POST['userId']) ? $_POST['userId'] : '');
	$userEmail = (isset($_POST['userEmail']) ? $_POST['userEmail'] : '');

	$updateQuery = "UPDATE user_info SET user_email='$userEmail' WHERE user_id='$userId'";
	$query = mysqli_query($conn, $updateQuery);
	if ($query) {
		$updateQuery2 = "UPDATE login_info SET user_email='$userEmail' WHERE user_id='$userId'";
	    $query2 = mysqli_query($conn, $updateQuery2);
	    if ($query2) {
		    echo json_encode("Success");
        }
        else{
            echo json_encode("Error");
        }
    }
    else{
        echo json_encode("Error");
        }
}
$conn->close();
?>