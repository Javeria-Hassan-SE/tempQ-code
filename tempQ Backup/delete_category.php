<?php
include 'db_config.php';
global $conn;
$user_id = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    //$_POST = json_decode(file_get_contents('php://input'), true);
	$cat_name = (isset($_POST['cat_name']) ? $_POST['cat_name'] : '');

	$sql = "Select device_cat FROM user_device WHERE device_cat = '" . $cat_name . "'";
    
	$result = mysqli_query($conn, $sql);
	$count = mysqli_num_rows($result);
	if($result->num_rows > 0){
		echo json_encode("Error");
	}
	else{
		$sql2 = "Delete FROM sensors_category WHERE cat_name = '" . $cat_name . "'";
	    $result2 = mysqli_query($conn, $sql2);
	    if($result2){
		    echo json_encode("Success");
	    }
	    else{
		    echo json_encode("Error2");
	    }
	
	}
}
	
$conn->close();
?>