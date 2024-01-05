<?php
include 'db_config.php';
global $conn;
$user_id = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
	$user_id = (isset($_POST['user_id']) ? $_POST['user_id'] : '');

	$sql = "SELECT * FROM invoice_pdf WHERE user_id = '" . $user_id . "'";
    
	$result = mysqli_query($conn, $sql);
	$count = mysqli_num_rows($result);
	if($result->num_rows > 0){
		while($row = $result->fetch_assoc()){
			$data [] = $row;
		}
		echo json_encode($data);
	}
	else{
		echo json_encode($error);
		}
}
	
$conn->close();
?>