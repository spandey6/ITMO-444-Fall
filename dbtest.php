<?php
//connection
$link= mysqli_connect("put some data") or die ("Error " . mysqli_error($link))

echo "Results is below" . $link;

//sql to create a table
$sql = "CREATE TABLE Students (
Id INT NOT NULL AUTO_INCREAMENT PRIMARY KEY,
Name VARCHAR(255),
Age INT(3) 
)";

$link->query($sql);

?>
