<?php
    error_reporting(0);

    $email = $_GET['email']; //email
    $phone = $_GET['phone']; 
    $name = $_GET['name']; 
    $amount = $_GET['amount']; 

    $api_key = '74b990c3-ef85-4825-8b17-7fb00e209c74';
    $collection_id = 'x7x1ikos';
    $host = 'https://billplz-staging.herokuapp.com/api/v3/bills';

    $data = array(
        'collection_id' => $collection_id,
        'email' => $email, 
        'phone' => $phone,
        'name' => $name, 
        'amount' => $amount * 100 , 
        'description' => 'Payment for order: ',
        'callback_url' => "https://szulaikha.projectmuu.com/inamaju/php/return_url",
        'redirect_url' => "https://szulaikha.projectmuu.com/inamaju/php/payment_update.php?email=$email&phone=$phone&amount=$amount" 
    );

    $process = curl_init($host );
    curl_setopt($process, CURLOPT_HEADER, 0);
    curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
    curl_setopt($process, CURLOPT_TIMEOUT, 30);
    curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
    curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 
    $return = curl_exec($process);

    curl_close($process);
    $bill = json_decode($return, true);
    echo "<pre>".print_r($bill, true)."</pre>";
    header("Location: {$bill['url']}");
?>
