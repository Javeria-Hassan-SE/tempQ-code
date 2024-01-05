<?php
    $token = isset($_GET['token']) ? $_GET['token'] :'';
?>
<html lang="en" >
<html>
<head>
  <title>Reset Password</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta charset="utf-8">
  <link rel="stylesheet" type="text/css" href="styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <link href='https://fonts.googleapis.com/css?family=Titillium+Web:400,300,600' rel='stylesheet' type='text/css'>  
  <link href='https://fonts.googleapis.com/css?family=Titillium+Web:400,300,600' rel='stylesheet' type='text/css'> 
 
</head>

<body class="body">
	
<div class="login-page">
  <div class="form">

    <h1>Reset Password</h1>
    <form action="http://tempq.tecroam.com/reset_password.php" method="post">
    <input type="hidden" name="token" value="<?php echo htmlspecialchars($token); ?>">
    New Password: <input type="password" name="password"><br>
    <button type="submit" name="submit" id="submit">Reset</button>
</form>

  </div>
</div>

</body>
</html>
<html>
<body>

</body>
</html>


