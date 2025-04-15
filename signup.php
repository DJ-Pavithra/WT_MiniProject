<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $host = "localhost";
    $dbname = "studybuddies";
    $username = "root";
    $password = "";
    $username1 = $_POST['username'];
    $email = $_POST['email'];
    $password1 = $_POST['password'];
    $port = 3307;

    // Hash the password
    $hashedPassword = password_hash($password1, PASSWORD_BCRYPT);

    // Database connection
    try {
        // Database connection
        $conn = new PDO("mysql:host=$host;port=$port;dbname=$dbname;charset=utf8", $username, $password);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    } catch (PDOException $e) {
        die("Database error: " . $e->getMessage());
    }
    // Insert user into the database
    $stmt = $conn->prepare("INSERT INTO users (username, email, password, created_at) VALUES (?, ?, ?, NOW())");
    $stmt->bind_param('sss', $username1, $email, $hashedPassword);

    if ($stmt->execute()) {
        echo 'Registration successful!';
    } else {
        echo 'Error: ' . $stmt->error;
    }

    $stmt->close();
    $conn->close();
}
?>