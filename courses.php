<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "studybuddies";
$port = 3307;

$conn = new mysqli($servername, $username, $password, $dbname, $port);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Handle view courses
if ($_SERVER['REQUEST_METHOD'] === 'GET' && $_GET['action'] === 'view') {
    header('Content-Type: application/json');
    $sql = "SELECT id, course_name, description, price FROM courses ORDER BY created_at DESC";
    $result = $conn->query($sql);

    $courses = [];
    while ($row = $result->fetch_assoc()) {
        $courses[] = $row;
    }

    echo json_encode($courses);
    exit;
}

// Handle add course
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $course_name = $_POST['course_name'] ?? '';
    $description = $_POST['description'] ?? '';
    $price = $_POST['price'] ?? '';

    if ($course_name && $description && $price) {
        $stmt = $conn->prepare("INSERT INTO courses (course_name, description, price, created_at) VALUES (?, ?, ?, NOW())");
        $stmt->bind_param("ssd", $course_name, $description, $price);

        if ($stmt->execute()) {
            echo "Course added successfully!";
            header("Location: http://localhost:8080/Nexus/dashboard.jsp");
            exit;
        } else {
            echo "Error: " . $stmt->error;
        }

        $stmt->close();
    } else {
        echo "All fields are required.";
    }
} else if (!isset($_GET['action']) || $_GET['action'] !== 'view') {
    echo "Invalid request method or missing action.";
}

$conn->close();
?>
