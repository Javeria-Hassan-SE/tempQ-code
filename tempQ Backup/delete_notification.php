<?php
include 'db_config.php';
global $conn;
$id = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
   // $_POST = json_decode(file_get_contents('php://input'), true);
	$id = (isset($_POST['id']) ? $_POST['id'] : '');
		$sql2 = "Delete FROM notifications WHERE id = '" . $id . "'";
	    $result2 = mysqli_query($conn, $sql2);
	    if($result2){
		    echo json_encode("Success");
	    }else{
            echo json_encode("Error");
        }
	
}
	
$conn->close();
?>