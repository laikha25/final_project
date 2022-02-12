<?php
$servername = "cloudgate";
$username   = "projectm_inamajuadmin";
$password   = "Sitiika255";
$dbname     = "projectm_inamajudb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>