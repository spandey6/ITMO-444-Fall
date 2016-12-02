<html>
<head> <title> galary </title> 
</head>
<body>
<h1> Galary Images </h1>

<?php
require 'vendor/autoload.php';

#show the images uploaded by the user
session_start();
$email = $_POST["email"];
echo "Your email is: " .  $email;

$rds = new Aws\Rds\RdsClient([
'version' => 'latest',
'region' => 'us-west-2'
]);

$result - $rds->describeDBInstances([
'DBInstanceIdentifier' => 'fp-spd-db',
]);
$endpoint = $result['DBInstances'][0]['Endpoint']['Address']

//Database begins
$link = mysqli_connect($endpoint, "controller","letmein","fp-spd-db") or die("Error" .mysqli_error($link));

//Check connection 
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}
mysqli_query($link, "SELECT * FROM comments WHERE email = '$email'");
$results = $link->insert_id;
$query = "SELECT * FROM comments WHERE email = '$email'";
if($res =$link->query($query))
{
//Print the pictures from finished and raw buket
}
while ($row = $res->fetch_assoc()) {
	if($_SESSION['gallery']({
		echo "<img src =\" " . $row['FinishedS3'] . "\" /> <br />";
	}
	else {
		echo "<img src =\" " . $row['RawS3'] . "\" /> <br />";
	}
}
$link->close();
?>
</body>
</html>

