<?php
include_once("dbconnect.php");
$user_email = $_POST['user_email'];
$prid = $_POST['prid'];
$qty = $_POST['qty'];

$sqlcheck = "SELECT * FROM tbl_products WHERE prid = '$prid'";
$result = $conn->query($sqlcheck);

if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        $prqty = $row['prqty'];
        if($prqty == 0){
            echo "failed";
            return;
        }
        else{
            echo $sqlcheckcart = "SELECT * FROM tbl_cart WHERE prid = '$prid' AND user_email = '$user_email'";
            $resultcart = $conn->query($sqlcheckcart);
            if($resultcart->num_rows == 0){
                echo $sqladdtocart = "INSERT INTO tbl_cart (user_email,prid,cart_qty) VALUES ('$user_email','$prid','$qty')";
                if($conn->query($sqladdtocart) === TRUE){
                    echo "success";
                }
                else{
                    echo "failed";
                }
            } else{
                    echo $sqlupdatecart = "UPDATE tbl_cart SET cartqty= '$qty' WHERE prid = '$prid' AND user_email = '$user_email'";
                    if ($conn->query($sqlupdatecart) === TRUE) {
                      echo "success";
                    }
                      else{
                       echo "failed";
                    }
                }
            }
        }
    }
    else{
        echo "failed";
    }
?>