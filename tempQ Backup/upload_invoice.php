<?php
include 'db_config.php';
global $conn;
$pdf_file = $invoiceId = $userId = $pdfFileName= $pdfTmpName= $uploadPath="";
$error =  "Error";

// Check if the request has a PDF file
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  // Get the user ID from the request
  $pdfFile = (isset($_FILES['pdf_file']) ? $_FILES['pdf_file'] : '');
  $userId = (isset($_POST['user_id']) ? $_POST['user_id'] : '');
  $invoiceId = (isset($_POST['invNumber']) ? $_POST['invNumber'] : '');

  // Get the PDF file details
//   $pdfFile = $_FILES['pdf_file'];
  $pdfFileName = $pdfFile['name'];
  $pdfTmpName = $pdfFile['tmp_name'];
  
  

  // Move the uploaded file to a desired location
  $uploadPath = './invoices/' . $pdfFileName;
//   $target_path = $_SERVER['DOCUMENT_ROOT'] . "/uploads/" . basename($_FILES['uploadedFile']['name']);

  if (move_uploaded_file($pdfFile,$uploadPath)) {
    // File uploaded successfully, insert the file details into MySQL database

    // Insert file details into the database
    $query = "INSERT INTO invoice_pdf (inv_id,user_id, invoice_pdf) VALUES ( '$pdfFileName','$userId', '$uploadPath')";
    if ($conn->query($query) === TRUE) {
      echo json_encode('PDF file uploaded successfully');
    } else {
      echo json_encode('Failed to insert file details into database');
    }
      
  } 
  
  else {
    echo json_encode('Failed to move uploaded file');
  }
} else {
  echo json_encode('No PDF file found in the request');
}
?>