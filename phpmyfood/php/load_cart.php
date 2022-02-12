<?php
include_once("dbconnect.php");
$email = $_POST['user_email'];

$sqlloadcart= "SELECT * FROM tbl_cart INNER JOIN tbl_products ON tbl_cart.prid = tbl_products.prid WHERE tbl_cart.user_email = '$email'";
$result = $conn->query($sqlloadcart);

if ($result->num_rows > 0){
    $products["cart"] = array();
    while ($row = $result -> fetch_assoc()){
        $cartList = array();
        $cartList['prid'] = $row['prid'];
        $cartList['prname'] = $row['prname'];
        $cartList['cart_qty'] = $row['cart_qty'];
        $cartList['prprice'] = $row['prprice'];
        $cartList['totalprice'] = $row['prprice'] * $row['cart_qty'];

        array_push($products["cart"],$cartList);
    }
    $response = array('status' => 'success', 'data' => $products);
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>