<?php
$xmlFile = 'c:/xampp/tomcat/webapps/Nexus/feedback.xml';

// Check if file exists
if (!file_exists($xmlFile)) {
    die("Feedback file not found.");
}

// Load XML data
$xml = simplexml_load_file($xmlFile);
if (!$xml) {
    die("Failed to load XML file.");
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Feedback Table</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; padding: 20px; }
        h2 { color: #333; }
        table { width: 100%; border-collapse: collapse; background-color: #fff; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #333; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
    </style>
</head>
<body>

<h2>Customer Feedback</h2>
<table>
    <thead>
        <tr>
            <th>Customer Name</th>
            <th>Rating</th>
            <th>Comments</th>
            <th>Date</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($xml->Feedback as $entry): ?>
        <tr>
            <td><?= htmlspecialchars($entry->CustomerName) ?></td>
            <td><?= htmlspecialchars($entry->Rating) ?></td>
            <td><?= htmlspecialchars($entry->Comments) ?></td>
            <td><?= htmlspecialchars($entry->Date) ?></td>
        </tr>
        <?php endforeach; ?>
    </tbody>
</table>

</body>
</html>
