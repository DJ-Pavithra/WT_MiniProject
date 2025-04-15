<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

if (isset($_POST['query'])) {
    $query = strtolower(trim($_POST['query']));
    
    $questions = [
        "hi",
        "name",
        "bye",
        "how are you",
        "what is nexus",
        "how do i create a study group",
        "how do i join a study group",
        "how can i edit my profile",
        "how do i contact support",
        "what are study sessions",
        "how do i track my login history",
        "what is the purpose of study groups",
        "can i leave a study group",
        "how do i reset my password",
        "what subjects are available",
        "how do i delete my account",
        "can i create multiple study groups",
        "what is the admin dashboard"
    ];

    $matches = array_filter($questions, function($q) use ($query) {
        return strpos($q, $query) !== false;
    });

    echo json_encode(array_values($matches));
}
?>
