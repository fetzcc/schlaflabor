<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '../vendor/autoload.php';

$post_json = file_get_contents("php://input");
parse_str($post_json, $post_data);

$subject = 'Kontakt';

$text = '<p><b>Name</b>:' . $post_data['name'] . '</p><p><b>Nachricht</b>:' . $post_data['text'] . '</p>';

$mail = new PHPMailer(true);   

try {
  $mail->CharSet  = 'UTF-8';
  $mail->Encoding = 'base64';
  $mail->isMail();
  $mail->From     = 'noreply@fetz.cc';
  $mail->FromName = 'office@helios-schlaflabor.at';
  $mail->isHTML(); 

  $mail->addAddress('office@helios-schlaflabor.at');
  $mail->addCC('smotzart@yandex.ru');
  if (isset($post_data['email']) && !empty($post_data['email'])) {
    $text .= '<p><b>Email</b>:' . $post_data['email'] . '</p>';
    $mail->AddReplyTo($post_data['email'], $post_data['name']);
  }
  
  //Content                             
  $mail->Subject = $subject;
  $mail->Body    = $text;
  $mail->AltBody = $text;

  $mail->send();
  http_response_code(200);
} catch (Exception $e) {
  http_response_code(400);
  echo 'Message could not be sent. Mailer Error: ', $mail->ErrorInfo;
}

?>