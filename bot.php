<?php
// Allow CORS from Tomcat (important!)
header("Access-Control-Allow-Origin: *");

if (isset($_POST['message'])) {
    $message = strtolower(trim($_POST['message']));
    $response = "I don't understand that.";

    $map = [
        "hi" => "Hello from PHP!",
        "name" => "I'm a PHP bot hosted in htdocs!",
        "bye" => "Goodbye from PHP!",
        "how are you" => "I'm doing great, thanks!",
        "what is nexus" => "Nexus is a platform to find and join study groups for collaborative learning.",
        "how do i create a study group" => "To create a study group, go to the 'Create Group' section and fill in the required details.",
        "how do i join a study group" => "To join a study group, browse the available groups and click on the 'Join' button.",
        "how can i edit my profile" => "You can edit your profile by navigating to the 'Profile' section and clicking on 'Edit Preferences'.",
        "how do i contact support" => "You can contact support by emailing support@nexus.com.",
        "what are study sessions" => "Study sessions are scheduled group meetings where members can collaborate on specific topics.",
        "how do i track my login history" => "Your login history is available in the admin dashboard if you are an admin user.",
        "what is the purpose of study groups" => "Study groups help students collaborate, share knowledge, and learn together effectively.",
        "can i leave a study group" => "Yes, you can leave a study group by navigating to the group page and clicking on 'Leave Group'.",
        "how do i reset my password" => "To reset your password, go to the login page and click on 'Forgot Password'.",
        "what subjects are available" => "Subjects vary based on user-created groups. You can browse available groups to see the subjects.",
        "how do i delete my account" => "To delete your account, go to the 'Profile' section and select 'Delete Account'.",
        "can i create multiple study groups" => "Yes, you can create as many study groups as you like, provided they follow the platform's guidelines.",
        "what is the admin dashboard" => "The admin dashboard provides tools for managing users, groups, and platform analytics."
    ];

    foreach ($map as $key => $reply) {
        if (strpos($message, $key) !== false) {
            $response = $reply;
            break;
        }
    }

    echo $response;
}
?>
