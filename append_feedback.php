<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Get the JSON input
$input = json_decode(file_get_contents('php://input'), true);

if (!$input || !isset($input['CustomerName'], $input['Rating'], $input['Comments'], $input['Date'])) {
    echo json_encode(["success" => false, "error" => "Invalid input data"]);
    exit;
}

$customerName = htmlspecialchars($input['CustomerName']);
$rating = htmlspecialchars($input['Rating']);
$comments = htmlspecialchars($input['Comments']);
$date = htmlspecialchars($input['Date']);

$xmlFile = 'c:/xampp/tomcat/webapps/Nexus/feedback.xml';

if (!file_exists($xmlFile)) {
    echo json_encode(["success" => false, "error" => "Feedback file not found"]);
    exit;
}

// Load the XML file
$xml = simplexml_load_file($xmlFile);
if (!$xml) {
    echo json_encode(["success" => false, "error" => "Failed to load XML file"]);
    exit;
}

// Append new feedback data
$newFeedback = $xml->addChild('Feedback');
$newFeedback->addChild('CustomerName', $customerName);
$newFeedback->addChild('Rating', $rating);
$newFeedback->addChild('Comments', $comments);
$newFeedback->addChild('Date', $date);

// Save the updated XML back to the file
if ($xml->asXML($xmlFile)) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "error" => "Failed to save feedback"]);
}

