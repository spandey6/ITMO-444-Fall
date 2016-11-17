?php
//connection
require 'vendor/autoload.php';


$client = new Aws\Rds\RdsClient([
  'region'            => 'us-west-2',
    'version'           => 'latest'
]);


$result = $client->describeDBInstances([
    'DBInstanceIdentifier' => 'inclass-544'
]);


$endpoint = $result['DBInstances'][0]['Endpoint']['Address'];
echo $endpoint . "\n";

$link = mysqli_connect($endpoint,"controller","ilovebunnies","inclass") or die("Error " . mysqli_error($link));

/* check connection */
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}

//sql to create a table
$sql = "CREATE TABLE students (
Id INT NOT NULL AUTO_INCREAMENT PRIMARY KEY,
Name VARCHAR(255),
Age INT(3)
)";
INSERT INTO students VALUES(1,'Mark','24');
INSERT INTO students VALUES(1,'Alex','23');
INSERT INTO students VALUES(1,'Hari','24');
INSERT INTO students VALUES(1,'Kevin','20');
INSERT INTO students VALUES(1,'Ganesh','28');

$create_tbl = $link->query($create_table);
if ($create_table) { 
        echo "Table is created or No error returned.";
}        
else {    
        echo "error!!";  
}       

$link->close();
      
?>
