<?php

// get the HTTP method, path and body of the request
$method = $_SERVER['REQUEST_METHOD'];

$connection = new MongoClient("mongodb://localhost:27017");
$dbname = $connection->selectDB('skad');
$attempts = $dbname->attempts;

switch ($method) {
  case 'GET':
	$results = $attempts->find();
	foreach ($results as $result) {
		foreach ($result as $item) {
			echo "$item,";
		}		
		echo "<BR>\n";
	}	
        break;
  case 'PUT':
        break;
  case 'POST':
	$debugfile = '/tmp/skad_dog.debug.txt';

	// Get the git branch this code is running from
	// This will be used below to restrict tweets to the main twitter accound only
	// occuring when running in prod
	$gitbranch = shell_exec("/usr/bin/git branch");	
	$index = strpos($gitbranch, "*");
	$gitbranch = substr($gitbranch, $index + 2);
	$index = strpos($gitbranch, "\n");
	$gitbranch = substr($gitbranch, 0, $index - strlen($gitbranch));

	$pathInfo = $_SERVER['PATH_INFO'];
	$remoteAddr = $_SERVER['REMOTE_ADDR'];
	$httpXForwardedFor = $_SERVER['HTTP_X_FORWARDED_FOR'];
	$request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
	$jsonInput = file_get_contents('php://input');
	$input = json_decode(file_get_contents('php://input'),true);
	$input['remoteAddr'] = $remoteAddr;
	$input['httpXForwardedFor'] = $httpXForwardedFor;

	$attempts->insert($input);

	// Right now I'm just going to tweet everything out but in the future this will be a bit more selective

	$ipaddress = $input['rhost'];

	$sourceJson = file_get_contents("http://ip-api.com/json/".$ipaddress);
	$source = json_decode($sourceJson, true);

	// Temporary fix
	$device = "";
	$tweets = false;

	$dogs = $dbname->dogs;
	$key = $input["key"];
	$names = iterator_to_array($dogs->find(array("key" => "$key")));
	
	file_put_contents($debugfile, "############################\n", FILE_APPEND | LOCK_EX);

	if (!empty($names)) {
		$dog = array_values($names)[0];
		$device = $dog["name"];
		$tweets = ($dog["tweets"] == Y);
		file_put_contents($debugfile, "Retrieved name from database: $device (tweets=$tweets)\n", FILE_APPEND | LOCK_EX);
	}
	else {
		$device = "Anonymous";
		file_put_contents($debugfile, "Name not found in database so using: $device\n", FILE_APPEND | LOCK_EX);
	}

	if ($source['message'] !== 'invalid query') {		
		$tweet = $source['org']." ($ipaddress) tried to logon as [".$input['user']."] from ".$source['city']." in ".$source['country']. " #alerted =".$device."=";
	}
	else {
		$tweet = "($ipaddress) tried to logon as [".$input['user']."] from local network #alerted =".$device."=";
	}

	$shellExec = "/usr/bin/sudo ";
	$twitterExec = $shellExec."/usr/local/bin/t";

	// This code assumes that prod has been set up to tweet both SKAD_Dog & SKAD_Test
	// It also assumes that all non-prod servers have been set up to only tweet to SKAD_Test
	// On all non-prod servers every attempt will be tweeted to SKAD_Test
	// For prod server it will tweet to the following
	// - SKAD_Test when the userid is skadtest
	// - SKAD_Dog for all other userids 

	if ($input['user'] === 'skadtest' && $gitbranch == "prod") {
		file_put_contents($debugfile, "Switching twitter account to SKAD_Test\n", FILE_APPEND | LOCK_EX);
		$command = $twitterExec." set active SKAD_Test tmv9q0pmITaLbNZG2PkeH80t1";
		file_put_contents($debugfile, "command=".$command."\n", FILE_APPEND | LOCK_EX);		
		$output = shell_exec($command." 2>&1");
		file_put_contents($debugfile, "shell_exec output=".$output."\n", FILE_APPEND | LOCK_EX);
	}
	
	$command = $twitterExec." update \"".$tweet."\"";
	
	file_put_contents($debugfile, "Tweet: ".$tweet."\n", FILE_APPEND | LOCK_EX);		
	file_put_contents($debugfile, "command: ".$command."\n", FILE_APPEND | LOCK_EX);

	if ($tweets) {
		file_put_contents($debugfile, "Dog is allowed to tweet so calling above command\n", FILE_APPEND | LOCK_EX);		
		$output = shell_exec($command." 2>&1");
	}
	else {
		file_put_contents($debugfile, "NOT TWEETING - this dog needs [tweets = Y] set in the database\n", FILE_APPEND | LOCK_EX);
	}

	file_put_contents($debugfile, "shell_exec output=".$output."\n", FILE_APPEND | LOCK_EX);	
	
	if ($input['user'] === 'skadtest' && $gitbranch == "prod") {
		file_put_contents($debugfile, "Switching twitter account back to SKAD_Dog\n", FILE_APPEND | LOCK_EX);
		$command = $twitterExec." set active SKAD_Dog 8FLtRR906YYAFq7wmFaYCmDMA";
		file_put_contents($debugfile, "command=".$command."\n", FILE_APPEND | LOCK_EX);		
		$output = shell_exec($command." 2>&1");
		file_put_contents($debugfile, "shell_exec output=".$output."\n", FILE_APPEND | LOCK_EX);
	}

        break;
    case 'DELETE':
        break;
}

?>
