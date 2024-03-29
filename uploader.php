<?php

session_start();
require 'vendor/autoload.php';

$s3 = new Aws\S3\S3Client([
    'version' => 'latest',
    'region'  => 'us-west-2'
]);

// have to hard code this here because index.php doesn't exist
$_SESSION['email'] = "spandey6@hawk.iit.edu";
echo "\n" . $_SESSION['email'] ."\n";

// Retrieve the POSTED file information (location, name, etc, etc)
$uploaddir = '/tmp/';
$uploadfile = $uploaddir . basename($_FILES['userfile']['name']);

#echo '<pre>';
if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)) {
    echo "File is valid, and was successfully uploaded.\n";
} else {
    echo "Possible file upload attack!\n";
}

echo 'Here is some more debugging info:';
print_r($_FILES);

// Upload file to S3 bucket
$s3result = $s3->putObject([
    'ACL' => 'public-read',
     'Bucket' => 'raw-spd',
      'Key' =>  basename($_FILES['userfile']['name']),
      'SourceFile' => $uploadfile 

// Retrieve URL of uploaded Object
]);
$url=$s3result['ObjectURL'];
echo "\n". "This is your URL: " . $url ."\n";

// INSERT SQL record of job information
$rdsclient = new Aws\Rds\RdsClient([
  'region'            => 'us-west-2',
    'version'           => 'latest'
]);
$rdsresult = $rdsclient->describeDBInstances([
    'DBInstanceIdentifier' => 'fp-spd-db',
]);
$endpoint = $rdsresult['DBInstances'][0]['Endpoint']['Address'];
echo $endpoint . "\n";

$link = mysqli_connect($endpoint,"controller","letmein55","fp-spd-db") or die("Error " . mysqli_error($link));

/* check connection */
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}
$username = $_POST['username'];
$email = $_SESSION['email'];
$phone = '7735171580';
$finisheds3url = ' ';
$issubscribed=0;
$receipt=md5($url);
$status =0;

// code to insert new record
/* Prepared statement, stage 1: prepare */
if (!($stmt = $link->prepare("INSERT INTO records (id, email, phone, s3-raw-url, s3-finished-url, status,reciept,issubscribed) VALUES (NULL,?,?,?,?,?,?,?)"))) {
    echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
}
$email=$_SESSION['email'];

// prepared statements will not accept literals (pass by reference) in bind_params, you need to declare variables
$stmt->bind_param("ssssii",$email,$phone,$s3-raw-url,$s3-finsihed-url,$status,$reciept,$issubscribed);

if (!$stmt->execute()) {
    echo "Execute failed: (" . $stmt->errno . ") " . $stmt->error;
}
printf("%d Row inserted.\n", $stmt->affected_rows);

/* explicit close recommended */
$stmt->close();

// SELECT *
$link->real_query("SELECT * FROM comments");
$res = $link->use_result();

echo "Result set order...\n";
while ($row = $res->fetch_assoc()) {
    echo " id = " . $row['id'] . "\n";
}
$link->close();

// PUT MD5 hash of raw URL to SQS QUEUE
?>

