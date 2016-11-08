<?php
$servername = "localhost"
$dbname = "school"

//create connection
$conn = new mysqli($servernanme, $dbname);
//check connection
if ($conn_error) {
	die("Connection failed: " . $conn->connect_error);
}
//sql to create a table
$sql = "CREATE TABLE Students (
Id INT() PRIMARY KEY,
Name VARCHAR(255) NOT NULL,
Age INT(3) 
)";
if ($conn->query($sql) === TRUE {
	echo "Table Students created successfully";
}
else {
	echo "Error creating table: " . $conn->error;
}
$conn->close();

?>
