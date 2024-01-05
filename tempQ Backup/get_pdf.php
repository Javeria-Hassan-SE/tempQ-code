<?php
include 'db_config.php';
global $conn;

$result = $conn->query("SELECT * FROM invoice_pdf ORDER BY id DESC");
$list = array();
if ($result) {
    while ($row = mysqli_fetch_assoc($result)) {
        $list[] = $row;
        echo json_encode($list);
    }
}

?>