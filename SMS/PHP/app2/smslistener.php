<!-- 
Licensed by AT&T under 'Software Development Kit Tools Agreement.' September 2011
TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION: http://developer.att.com/sdk_agreement/
Copyright 2011 AT&T Intellectual Property. All rights reserved. http://developer.att.com
For more information contact developer.support@att.com
   -->

   <?php
$path_is = __FILE__;
$folder = dirname($path_is);
$folder = $folder . "/" . "tally";
if(!is_dir($folder))
  {
    echo "tally  folder is missing";
    exit();
  }
$db_filename = $folder . "/". "smslistner.db";
$post_body = file_get_contents('php://input');
//$post_body = file_get_contents( "full_message3.mm");

if ( file_exists( $db_filename) ){
  $messages = unserialize(file_get_contents($db_filename)); 
 }else{
  $messages = null;
 }

$local_post_body = $post_body;
$ini = strpos($local_post_body,"<SenderAddress>tel:+");
if ($ini == 0 )
  {
    exit();
  }else{
  preg_match("@<SenderAddress>tel:(.*)</SenderAddress>@i",$local_post_body,$matches);
  $message["address"] = $matches[1];
  preg_match("@<subject>(.*)</subject>@i",$local_post_body,$matches);
  $message["subject"] = $matches[1];
  $message["date"]= date("D M j G:i:s T Y");
 }

if( $messages !=null ){
  $last=end($messages);
  $message['id']=$last['id']+1;
 }else{
    $message['id'] = 0;
 }

mkdir($folder.'/'.$message['id']);


if( $messages !=null ){
  $messages_stored=array_push($messages,$message);
  if ( $messages_stored > 10 ){
    $old_message = array_shift($messages);
    // remove old message folder 
  }
 }else{
    $messages = array($message);
 }

$fp = fopen($db_filename, 'w+') or die("I could not open $filename.");
fwrite($fp, serialize($messages));
fclose($fp);
//print_r($messages);


?>

