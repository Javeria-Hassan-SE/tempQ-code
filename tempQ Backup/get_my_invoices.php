<?php
include 'db_config.php';
global $conn;
$userId="";

$deviceId = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    //$_POST = json_decode(file_get_contents('php://input'), true);
    $userId = (isset($_POST['userId']) ? $_POST['userId'] : '');
    $sql = "SELECT * FROM invoice AS p1 INNER JOIN invoice_details AS p2 ON 
    p1.inv_id = p2.inv_id INNER JOIN user_info AS p3 ON p1.user_id = p3.user_id Where p1.user_id = '$userId' order by p1.counter DESC ";
    $data = array();
    $result = mysqli_query($conn, $sql);
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