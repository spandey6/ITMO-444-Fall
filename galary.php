<?php

session_start();

echo "Your email is: " .  $_SESSION['email'];
$email = $_SESSION['email'];
echo "\n" . md5($email);

$_SESSION['receipt'] = md5($email);
$rds = new Aws\Rds\RdsClient([
'version' => 'latest',
'region' => 'us-west-2'
]);
$result - $rds->describeDBInstances([
'DBInstanceIdentifier' => '',
]);
$endpoint = $result['DBInstances'][0]['Endpoint']['Address']

//Database begins
$link = mysqli_connect($endpoint, "root","letmein","spandey") or die("Error" .mysqli_error($link));

//connection 

?>

<html>
<head>
<title>Galary Page</title>
</head>
<body>
Gallery
<a href="gallery.php"> Gallery </a> <a href="upload.php"> Upload </a>

</body></html>
