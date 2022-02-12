<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home11/projectm/norsyahira.projectmuu.com/PHPMailer/src/Exception.php';
require '/home11/projectm/norsyahira.projectmuu.com/PHPMailer/src/PHPMailer.php';
require '/home11/projectm/norsyahira.projectmuu.com/PHPMailer/src/SMTP.php';

include_once ("dbconnect.php");

$email = $_POST['email'];
$newpass = random_password(10);
$passha2 = sha1($newpass);
$newotp = rand(10000,99999);

$sql = "SELECT * FROM tbl_users WHERE user_email ='$email' AND verify ='1'";
    $result = $conn->query($sql);
if ($result->num_rows > 0){
    $sqlupdate = "UPDATE tbl_users SET otp = '$newotp' , user_password = '$passha2' WHERE user_email = '$email'";
        if ($conn->query($sqlupdate) === true){
            random_password($length);
            sendEmail($newotp, $newpass, $email);
            echo "success";
            }
            else{
                echo "failed";
            }
} else {
    echo "failed";
}

function sendEmail($newotp,$newpass,$email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                                               //Disable verbose debug output
    $mail->isSMTP();                                                    //Send using SMTP
    $mail->Host       = 'mail.projectmuu.com';                          //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                           //Enable SMTP authentication
    $mail->Username   = 'szulaikha@projectmuu.com';  
    $mail->Password   = 'Syahira123';
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    $from = "szulaikha@projectmuu.com";
    $to = $email;
    $subject = "From InaMaju. Reset Your Account";
    $message = "<p>Account successfully reset. Login again using the new password given below.</p><br><br><h3>Password:".$newpass."</h3><br><br><a href='https://norsyahira.projectmuu.com/kakpahnasiberlauk/php/verify_account.php?email=$email&key=$newotp'></a>";
    
    $mail->setFrom($from,"InaMaju");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}

function random_password($length){
    $characters= '01234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $password = '';
    $characterListLength = mb_strlen($characters, '8bit') - 1;
    //loop from 1-$length that was specified
    foreach(range(1, $length) as $i){
        $password .= $characters[rand(0, $characterListLength)];
    }
    return $password;
}

?>