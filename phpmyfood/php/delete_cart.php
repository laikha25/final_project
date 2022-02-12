<?php
    error_reporting(0);

    include_once("dbconnect.php");
    $user_email = $_POST['user_email'];
    $prid = $_POST['prid'];

    $sqldelete = "DELETE FROM tbl_cart WHERE user_email = '$user_email' AND prid = '$prid'";

    if ($conn->query($sqldelete) === TRUE){
        echo "success";
    }else {
        echo "failed";
    }
?>
