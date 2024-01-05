<?php
include 'db_config.php';
global $conn;

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $inv_id = $date_of_issue = $user_id =  $issue_by = $plan_id = $due_date = $total = $discount = $qty = $unit_price= $plan_type=$valid_till="";
    $device_id = array();
     $_POST = json_decode(file_get_contents('php://input'), true);
	if(!empty($_POST)){
        $inv_id = (isset($_POST['inv_id']) ? $_POST['inv_id'] : "");
	    $date_of_issue = (isset($_POST['date_of_issue']) ? $_POST['date_of_issue'] : '');
	    $user_id = (isset($_POST['user_id']) ? $_POST['user_id'] : '');
	    $issue_by = (isset($_POST['issue_by']) ? $_POST['issue_by'] : '');
	    $due_date = (isset($_POST['due_date']) ? $_POST['due_date'] : '');
	    $plan_id = (isset($_POST['plan_id']) ? $_POST['plan_id'] : '');
        $total = (isset($_POST['total']) ? $_POST['total'] : '');
		$discount = (isset($_POST['discount']) ? $_POST['discount'] : '');
	    $device_id = (isset($_POST['device_id']) ? $_POST['device_id'] : '');
	    $qty = (isset($_POST['qty']) ? $_POST['qty'] : '');
        $unit_price = (isset($_POST['unit_price']) ? $_POST['unit_price'] : '');
        $plan_type = (isset($_POST['plan_type']) ? $_POST['plan_type'] : '');
        $valid_till = (isset($_POST['valid_till']) ? $_POST['valid_till'] : '');
		$total_qty = count($device_id);
		
// 		$dateTimeString =$date_of_issue;
//         $dateTime = DateTime::createFromFormat('Y/m/d', $dateTimeString);
        
//         $dateTimeString2 =$due_date;
//         $dateTime2 = DateTime::createFromFormat('Y/m/d', $dateTimeString2);
	
		$insertStmt = "INSERT INTO invoice(inv_id,date_of_issue,user_id,
		issue_by,due_date, plan_id,total, discount, total_qty, plan_type, valid_till)VALUES('" . $inv_id . "','" . $date_of_issue . "',
		    '" . $user_id . "','" . $issue_by . "', '" . $due_date . "'
			, '" . $plan_id . "', '" . $total . "', '" . $discount . "', '" . $total_qty . "', '" . $plan_type . "', '" . $valid_till . "')";
		 $query = mysqli_query($conn, $insertStmt);
		if ($query) {
			foreach ($device_id as $item) {
				// Create an INSERT query
				$sql = "INSERT INTO invoice_details (inv_id, device_id, qty, unit_price)
				 VALUES ('" . $inv_id . "','" . $item . "','" . $qty . "', 
				 '" . $unit_price . "')";
			   $query2 = mysqli_query($conn, $sql);
			  }
			  if ($query2) {
			      $status ='Yes';
			      $updateQuery = "UPDATE user_device SET is_invoice_generated='$status' , subs_type='$plan_type' WHERE device_id='$item'";
			        $query3 = mysqli_query($conn, $updateQuery);
			        if ($query3) {
				        echo json_encode("Success");
			        }
			         else {
				  echo json_encode("Error");
				}
			} else {
				  echo json_encode("Error");
				}
			    
		    }
		    else{
		        echo json_encode("Error");
		    }
		}
	}
	else{
	    echo json_encode("Error");
	}

	$conn->close();
?>