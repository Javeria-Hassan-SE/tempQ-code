<?php
include 'db_config.php';
global $conn;
$userId ="";


if ($_SERVER["REQUEST_METHOD"] == "POST") {
   //$_POST = json_decode(file_get_contents('php://input'), true);
	$userId = (isset($_POST['userId']) ? $_POST['userId'] : '');
    $insertQuery = "SELECT * FROM notifications WHERE user_id = '" . $userId . "' ";
	$data = array();
    $result = mysqli_query($conn, $insertQuery);
    $count = mysqli_num_rows($result);
    if ($count > 0) {
        while($row = $result->fetch_assoc()){
		    $data [] = $row;
	    }
	    echo json_encode($data);
	 //echo $data;
    } else {
    	echo json_encode("Error");
    }
}

$conn->close();
?>