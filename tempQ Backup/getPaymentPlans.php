<?php
include 'db_config.php';
global $conn;
$sql = "SELECT unit_price, sensor_qty FROM plan_one";
$result = mysqli_query($conn, $sql);

// Initialize the arrays
$array1 = array();
$array2 = array();
while($row = mysqli_fetch_assoc($result)) {
    $array1[] = $row;
}

$sql2 = "SELECT total_price, sesnor_qty FROM plan_two";
$result2 = mysqli_query($conn, $sql2);

// Initialize the arrays
$array2 = array();
while($row2 = mysqli_fetch_assoc($result2)) {
    $array2[] = $row2;
}

// Convert the arrays to a JSON object
$json = json_encode(array('array1' => $array1, 'array2' => $array2));
echo $json;
$conn->close();
?>