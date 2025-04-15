<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");


$servername = "localhost";
$username = "root";
$password = "";
$dbname = "studybuddies";
$port = 3307; // Adjust the port if necessary
$conn = new mysqli($servername, $username, $password, $dbname, $port);

if ($conn->connect_error) {
    echo json_encode(["error" => "Connection failed: " . $conn->connect_error]);
    exit;
}

$sql = "SELECT course_name, description, price FROM courses";
$result = $conn->query($sql);

$courses = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $courses[] = $row;
    }
}

$conn->close();

echo json_encode($courses);
?>