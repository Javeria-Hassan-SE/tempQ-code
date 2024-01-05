<?php
include 'db_config.php';
global $conn;
$catName = $userId  ="";
if ($_SERVER["REQUEST_METHOD"] == "POST") {
   //$_POST = json_decode(file_get_contents('php://input'), true);
	$catName = (isset($_POST['cat_name']) ? $_POST['cat_name'] : '');
	$userId = (isset($_POST['added_by']) ? $_POST['added_by'] : '');
	$sql = "SELECT cat_name FROM sensors_category WHERE cat_name = '" . $catName . "' ";
    
	$result = mysqli_query($conn, $sql);
	$count = mysqli_num_rows($result);
	if ($count == 1){
	    echo json_encode("Error");
	}
	else{
	   $insertQuery = "INSERT INTO sensors_category(cat_name,added_by)VALUES
	('" . $catName . "','" . $userId . "')";
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
