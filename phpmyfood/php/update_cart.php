<?php
error_reporting(0);
include_once("dbconnect.php");

$user_email = $_POST['user_email'];
$prid = $_POST['prid'];
$cart_qty = $_POST['cart_qty'];
$op = $_POST['op'];

if ($op == "addcart"){
    $sqlupdate = "UPDATE tbl_cart SET cart_qty = cart_qty+1 WHERE prid = '$prid' AND user_email = '$user_email'";
    if ($conn->query($sqlupdate) === TRUE){
        echo "success";
    }else{
        echo "failed";
    }
}
if ($op == "removecart") {
    if ($cart_qty == 1) {
        echo "failed";
    }else {
        $sqlupdate = "UPDATE tbl_cart SET cart_qty = cart_qty-1 WHERE prid = '$prid' AND user_email = '$user_email'";
        if ($conn->query($sqlupdate) === TRUE){
            echo "success";
        }else{
            echo "failed";
        }
    }
}
$conn->close();
?>