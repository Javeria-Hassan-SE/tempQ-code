<?php

$deviceId = "";

$sql = "SELECT * FROM plan_one AS p1 INNER JOIN plan_two AS p2 ON p1.plan1_id = p2.plan2_id";
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

$conn->close();
?>