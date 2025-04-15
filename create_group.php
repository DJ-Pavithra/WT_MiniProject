<?php
// Database credentials
$host = "localhost";
$dbname = "studybuddies";
$username = "root";
$password = "";
$port = 3307; 

try {
    // Database connection
    $conn = new PDO("mysql:host=$host;port=$port;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Database error: " . $e->getMessage());
}

// Handle Create operation
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["create"])) {
    $groupName = $_POST["group_name"];
    $description = $_POST["description"];
    $whatsappLink = $_POST["whatsapp_link"];

    try {
        $sql = "INSERT INTO groups (group_name, description, whatsapp_link, created_at) VALUES (:group_name, :description, :whatsapp_link, NOW())";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':group_name', $groupName);
        $stmt->bindParam(':description', $description);
        $stmt->bindParam(':whatsapp_link', $whatsappLink);
        $stmt->execute();
    } catch (PDOException $e) {
        $error = "Error creating group: " . $e->getMessage();
    }
}

// Handle Update operation
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["update"])) {
    $groupId = $_POST["group_id"];
    $groupName = $_POST["group_name"];
    $description = $_POST["description"];
    $whatsappLink = $_POST["whatsapp_link"];

    try {
        $sql = "UPDATE groups SET group_name = :group_name, description = :description, whatsapp_link = :whatsapp_link WHERE id = :group_id";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':group_id', $groupId);
        $stmt->bindParam(':group_name', $groupName);
        $stmt->bindParam(':description', $description);
        $stmt->bindParam(':whatsapp_link', $whatsappLink);
        $stmt->execute();
    } catch (PDOException $e) {
        $error = "Error updating group: " . $e->getMessage();
    }
}

// Handle Delete operation
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["delete"])) {
    $groupId = $_POST["group_id"];

    try {
        $sql = "DELETE FROM groups WHERE id = :group_id";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':group_id', $groupId);
        $stmt->execute();
    } catch (PDOException $e) {
        $error = "Error deleting group: " . $e->getMessage();
    }
}

// Fetch all groups (Read operation)
$groups = [];
try {
    $stmt = $conn->prepare("SELECT * FROM groups ORDER BY created_at DESC");
    $stmt->execute();
    $groups = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    $error = "Error fetching groups: " . $e->getMessage();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Manage Study Groups</title>
    <style>
    body {
        font-family: 'Arial', sans-serif;
        background: #F3F4F6;
        color: #333;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: flex-start;
        height: 100vh;
        overflow: auto; /* Enable scroll on body */
    }
    .container {
        background: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        width: 400px;
        text-align: center;
        height: 80vh; /* Set a fixed height for the container */
        overflow-y: auto; /* Enable vertical scrolling */
    }
    h2 {
        color: #4F46E5;
    }
    input, textarea {
        width: 100%;
        padding: 10px;
        margin: 10px 0;
        border: 1px solid #ccc;
        border-radius: 5px;
    }
    button {
        background: #4F46E5;
        color: white;
        padding: 10px;
        width: 100%;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }
    button:hover {
        background: #3730A3;
    }
    a {
        display: block;
        margin-top: 10px;
        color: #4F46E5;
        text-decoration: none;
    }
    .error {
        color: red;
        font-size: 14px;
    }
    .group-list {
        margin-top: 20px;
        text-align: left;
    }
    .group-item {
        background: #ffffff;
        padding: 15px;
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        margin-bottom: 10px;
    }
    .delete-button {
        background: #E53E3E;
        margin-top: 5px;
    }
</style>
</head>
<body>

<div class="container">
    <h2>Manage Study Groups</h2>
    
    <?php if (isset($error)) echo "<p class='error'>$error</p>"; ?>

    <!-- Create Group Form -->
    <form method="post">
        <input type="text" name="group_name" placeholder="Group Name" required>
        <textarea name="description" rows="4" placeholder="Group Description" required></textarea>
        <input type="url" name="whatsapp_link" placeholder="WhatsApp Group Link (Optional)">
        <button type="submit" name="create">Create Group</button>
    </form>

    <!-- Display Existing Groups -->
    <div class="group-list">
        <h3>Existing Groups</h3>
        <?php foreach ($groups as $group) { ?>
            <div class="group-item">
                <strong><?= htmlspecialchars($group['group_name']) ?></strong>
                <p><?= htmlspecialchars($group['description']) ?></p>
                <p><small>Created on: <?= $group['created_at'] ?></small></p>
                <?php if (!empty($group['whatsapp_link'])) { ?>
                    <p><a href="<?= htmlspecialchars($group['whatsapp_link']) ?>" target="_blank">Join WhatsApp Group</a></p>
                <?php } ?>

                <!-- Update Form -->
                <form method="post">
                    <input type="hidden" name="group_id" value="<?= $group['id'] ?>">
                    <input type="text" name="group_name" value="<?= htmlspecialchars($group['group_name']) ?>" required>
                    <textarea name="description" rows="2" required><?= htmlspecialchars($group['description']) ?></textarea>
                    <input type="url" name="whatsapp_link" value="<?= htmlspecialchars($group['whatsapp_link']) ?>" placeholder="WhatsApp Group Link (Optional)">
                    <button type="submit" name="update">Update</button>
                </form>

                <!-- Delete Form -->
                <form method="post">
                    <input type="hidden" name="group_id" value="<?= $group['id'] ?>">
                    <button type="submit" name="delete" class="delete-button">Delete</button>
                </form>
            </div>
        <?php } ?>
    </div>

    <a href="http://localhost:8080/Nexus/dashboard.jsp">🔙 Back to Dashboard</a>
</div>

</body>
</html>
