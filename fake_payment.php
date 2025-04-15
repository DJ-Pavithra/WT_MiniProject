<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $paymentMethod = $_POST['paymentMethod'] ?? '';

    if (in_array($paymentMethod, ['GPay', 'PhonePe', 'UPI', 'Credit Card'])) {
        // Redirect to success.jsp after successful payment
        header('Location: success.jsp');
        exit;
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Invalid payment method.'
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Invalid request method.'
    ]);
}
?>