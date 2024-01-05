<?php
include 'db_config.php';
global $conn;
$deviceId = $status= $userId= $invId ="";
$activeStatus = "Activated";
$deactiveStatus = "Rejected";
$activePaid = "Yes";
$deactivePaid = "false";
date_default_timezone_set('Asia/Karachi');
$valid_date = date("Y-m-d", strtotime("+1 month"));


if ($_SERVER["REQUEST_METHOD"] == "POST") {
  // $_POST = json_decode(file_get_contents('php://input'), true);
	$deviceId = (isset($_POST['deviceId']) ? $_POST['deviceId'] : '');
    $status = (isset($_POST['status']) ? $_POST['status'] : '');
    $userId = (isset($_POST['userId']) ? $_POST['userId'] : '');

    if($status == "Approved"){
        $update = "Update user_device SET is_paid = '$activePaid' , status = '$activeStatus' WHERE device_id ='$deviceId'" ;
        $query = mysqli_query($conn, $update);
	    if ($query) {
            $update2 = "Update sensors SET status = '$activeStatus' WHERE device_id = '$deviceId'" ;
            $query2 = mysqli_query($conn, $update2);
	        if ($query2) {
	            $select = "SELECT inv_id from invoice_details WHERE device_id = '$deviceId'";
	            $newResult = $conn->query($select);
                if($newResult->num_rows > 0){
                    while($row = $newResult->fetch_assoc()){
			                $invId = $row['inv_id'];
		                }
                }
		        $update3 = "Update invoice SET approved_by = '$userId' , valid_till = '$valid_date' WHERE inv_id = '$invId'" ;
                $query3 = mysqli_query($conn, $update3);
	            if ($query3) {
		            echo json_encode("Success");
	            }else{
                    echo json_encode("Error");
                }
	        }else{
               
              echo json_encode("Error");
            }
        }
		
	}else{
        $update = "Update user_device SET is_paid = '$deactivePaid' , status = '$deactiveStatus' WHERE device_id = '$deviceId'" ;
        $query = mysqli_query($conn, $update);
	    if ($query) {
            $update2 = "Update sensor SET status = '$deactiveStatus' WHERE device_id = '$deviceId'" ;
            $query2 = mysqli_query($conn, $update2);
	        if ($query2) {
	            $select = "SELECT inv_id from invoice_details WHERE device_id = '$deviceId'";
	            $newResult = $conn->query($select);
                if($newResult->num_rows > 0){
                    while($row = $newResult->fetch_assoc()){
			                $invId = $row['inv_id'];
		                }
                }
		        $update3 = "Update invoice SET approved_by = '$userId' WHERE inv_id = '$invId'" ;
                $query3 = mysqli_query($conn, $update3);
	            if ($query3) {
		            echo json_encode("Success");
	            }else{
                    echo json_encode("Error");
                }
	        }else{
                echo json_encode("Error");
            }
        }
    }

}


$conn->close();
?>
