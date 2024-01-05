<!DOCTYPE html>
<html>
<body>
<?php

include 'db_config.php';
global $conn;


$sql = "SELECT id, deviceId,time_stamp,reading_date, sensTempFValue, sensTempCValue, sensVoltageValue, sensPerc FROM SensorData ORDER BY id DESC";

echo '<table cellspacing="5" cellpadding="5">
      <tr> 
        <td>ID</td> 
        <td>Device ID</td> 
        <td>Time Stamp</td> 
        <td>Date</td> 
        <td>Temp (F) </td> 
        <td>Temp (C) </td>
        <td>sensVoltageValue </td>
        <td>Battery % </td>
      </tr>';
 
if ($result = $conn->query($sql)) {
    while ($row = $result->fetch_assoc()) {
        $row_id = $row["id"];
        $deviceId = $row["deviceId"];
        $time_stamp = $row["time_stamp"];
        $reading_date = $row["reading_date"]; 
        $sensTempFValue = $row["sensTempFValue"];
        $sensTempCValue = $row["sensTempCValue"];
        $sensVoltageValue = $row["sensVoltageValue"]; 
        $sensPerc = $row["sensPerc"];
 echo '<tr> 
                <td>' . $row_id . '</td> 
                <td>' . $deviceId . '</td> 
                <td>' . $time_stamp . '</td> 
                <td>' . $reading_date . '</td> 
                <td>' . $sensTempFValue . '</td> 
                <td>' . $sensTempCValue . '</td> 
                <td>' . $sensVoltageValue . '</td> 
                <td>' . $sensPerc . '</td> 
              </tr>';
    }
    $result->free();

}
$conn->close();
?> 
</table>
</body>
</html>