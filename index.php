<?php 
session_start();

//database connection
echo "This is my database"
$link = mysquli_connect("fp-spd-db","controller","letmein","3306") or die("Error " . mysquli_error($link));

echo "Here is your result: " .$link;
 ?>
<html>
<head><title>Welcome</title>
</head>
<body>
<h1> Hello Everyone </h1>
<!-- The data encoding type, enctype, MUST be specified as below -->
<form enctype="multipart/form-data" action="welcome.php" method="POST">
    <!-- MAX_FILE_SIZE must precede the file input field -->
    <input type="hidden" name="MAX_FILE_SIZE" value="3000000" />
    <!-- Name of input element determines name in $_FILES array -->
	Send this file: <input name="userfile" type="file" /><br />
	Enter Email of user: <input type="email" name="email"><br />

	<input type="submit" value="Send File" />
</form>
<hr />
</body>
</html>
