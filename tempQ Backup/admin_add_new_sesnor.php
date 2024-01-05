<?php
include 'db_config.php';
global $conn;
$deviceName = $deviceID= $userId  = $cat_name= $catId="";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
   //$_POST = json_decode(file_get_contents('php://input'), true);
	$deviceName = (isset($_POST['device_name']) ? $_POST['device_name'] : '');
    $deviceID = (isset($_POST['device_Id']) ? $_POST['device_Id'] : '');
	$userId = (isset($_POST['user_Id']) ? $_POST['user_Id'] : '');
    $cat_name = (isset($_POST['cat_name']) ? $_POST['cat_name'] : '');

    $selectStmt = "SELECT cat_id FROM sensors_category WHERE cat_name = '" . $cat_name . "'";
			    if ($result2 = $conn->query($selectStmt)) {
				    while ($row = $result2->fetch_assoc()) {
					    $catId = $row["cat_id"];
				    }
                    $insertQuery = "INSERT INTO sensors(device_id, device_name,cat_id,added_by)VALUES
	('" . $deviceID . "','" . $deviceName . "','" . $catId . "','" . $userId . "')";
    $query = mysqli_query($conn, $insertQuery);
	if ($query) {
		echo json_encode("Success");
	}else{
        echo json_encode("Error");
    }
                }


	
			
		
}
$conn->close();
?>
