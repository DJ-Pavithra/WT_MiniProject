<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Your Course Purchase</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --primary-dark: #3a0ca3;
            --success: #10b981;
            --success-dark: #059669;
            --danger: #ef4444;
            --warning: #f59e0b;
            --info: #3b82f6;
            --light: #f9fafb;
            --dark: #1f2937;
            --gray-100: #f3f4f6;
            --gray-200: #e5e7eb;
            --gray-300: #d1d5db;
            --gray-400: #9ca3af;
            --gray-500: #6b7280;
            --gray-600: #4b5563;
            --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--gray-100);
            color: var(--dark);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem 1rem;
        }
        
        .purchase-container {
            width: 100%;
            max-width: 800px;
            background-color: white;
            border-radius: 16px;
            box-shadow: var(--shadow-lg);
            overflow: hidden;
        }
        
        .purchase-header {
            background: linear-gradient(135deg, var(--success), var(--success-dark));
            color: white;
            padding: 2rem;
            text-align: center;
            position: relative;
        }
        
        .purchase-header h1 {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .purchase-header p {
            opacity: 0.9;
            font-size: 1.1rem;
        }
        
        .purchase-header .icon {
            background-color: white;
            color: var(--success);
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            margin: 0 auto 1rem;
        }
        
        .purchase-content {
            padding: 2rem;
        }
        
        .purchase-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }
        
        .details-section {
            border: 1px solid var(--gray-200);
            border-radius: 12px;
            padding: 1.5rem;
        }
        
        .details-section h2 {
            font-size: 1.2rem;
            color: var(--gray-600);
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid var(--gray-200);
        }
        
        .details-item {
            display: flex;
            margin-bottom: 0.75rem;
        }
        
        .details-label {
            font-weight: 600;
            color: var(--gray-500);
            width: 40%;
        }
        
        .details-value {
            width: 60%;
            color: var(--dark);
        }
        
        .course-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary);
            text-align: center;
            margin: 1.5rem 0;
        }
        
        .payment-section {
            margin-top: 2rem;
        }
        
        .section-title {
            font-size: 1.25rem;
            margin-bottom: 1rem;
            color: var(--gray-600);
            text-align: center;
        }
        
        .payment-options {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .payment-option {
            position: relative;
            cursor: pointer;
        }
        
        .payment-option input {
            position: absolute;
            opacity: 0;
            cursor: pointer;
            height: 0;
            width: 0;
        }
        
        .payment-option-label {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 1rem;
            border: 2px solid var(--gray-300);
            border-radius: 12px;
            transition: all 0.3s ease;
            min-width: 120px;
        }
        
        .payment-option input:checked ~ .payment-option-label {
            border-color: var(--primary);
            background-color: rgba(67, 97, 238, 0.05);
        }
        
        .payment-icon {
            font-size: 1.75rem;
            margin-bottom: 0.5rem;
            color: var(--gray-500);
        }
        
        .payment-option input:checked ~ .payment-option-label .payment-icon {
            color: var(--primary);
        }
        
        .payment-name {
            font-weight: 600;
        }
        
        .buttons {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 50px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            font-size: 1rem;
            text-decoration: none;
        }
        
        .btn-primary {
            background-color: var(--success);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--success-dark);
        }
        
        .btn-secondary {
            background-color: white;
            color: var(--gray-600);
            border: 1px solid var(--gray-300);
        }
        
        .btn-secondary:hover {
            background-color: var(--gray-100);
        }
        
        .thank-you {
            text-align: center;
            color: var(--success);
            font-weight: 600;
            margin: 1rem 0;
        }
        
        @media (max-width: 768px) {
            .purchase-details {
                grid-template-columns: 1fr;
            }
            
            .payment-options {
                flex-direction: column;
                align-items: center;
            }
            
            .payment-option-label {
                width: 100%;
                flex-direction: row;
                justify-content: flex-start;
                gap: 1rem;
            }
            
            .buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="purchase-container">
        <div class="purchase-header">
            <div class="icon">
                <i class="fas fa-check"></i>
            </div>
            <h1>Course Purchase Confirmation</h1>
            <p>You're almost done! Please review your order details</p>
        </div>
        
        <div class="purchase-content">
            <div class="purchase-details">
                <div class="details-section">
                    <h2>Course Information</h2>
                    <div class="details-item">
                        <div class="details-label">Course:</div>
                        <div class="details-value"><%= request.getParameter("courseName") %></div>
                    </div>
                    <div class="details-item">
                        <div class="details-label">Description:</div>
                        <div class="details-value"><%= request.getParameter("courseDescription") %></div>
                    </div>
                    <div class="course-price">
                        $<%= request.getParameter("coursePrice") %>
                    </div>
                </div>
                
                
            <div class="payment-section">
                <h2 class="section-title">Select Payment Method</h2>
                <div class="payment-options">
                    <label class="payment-option">
                        <input type="radio" name="paymentMethod" value="GPay" required>
                        <div class="payment-option-label">
                            <i class="fab fa-google-pay payment-icon"></i>
                            <span class="payment-name">GPay</span>
                        </div>
                    </label>
                    
                    <label class="payment-option">
                        <input type="radio" name="paymentMethod" value="PhonePe">
                        <div class="payment-option-label">
                            <i class="fas fa-mobile-alt payment-icon"></i>
                            <span class="payment-name">PhonePe</span>
                        </div>
                    </label>
                    
                    <label class="payment-option">
                        <input type="radio" name="paymentMethod" value="UPI">
                        <div class="payment-option-label">
                            <i class="fas fa-qrcode payment-icon"></i>
                            <span class="payment-name">Other UPI</span>
                        </div>
                    </label>
                    
                    <label class="payment-option">
                        <input type="radio" name="paymentMethod" value="Credit Card">
                        <div class="payment-option-label">
                            <i class="far fa-credit-card payment-icon"></i>
                            <span class="payment-name">Credit Card</span>
                        </div>
                    </label>
                </div>
                
                <div class="buttons">
        
                        <button type="button" style="background-color: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold; transition: background-color 0.3s ease;" onmouseover="this.style.backgroundColor='#45a049';" onmouseout="this.style.backgroundColor='#4CAF50';" onclick="window.location.href='success.jsp'">Confirm Payment</button>
    
                    <a href="view_courses.html" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Courses
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function onPaymentConfirm() {
            // Check if a payment method is selected
            const selectedPayment = document.querySelector('input[name="paymentMethod"]:checked');
            if (!selectedPayment) {
                alert("Please select a payment method");
                return;
            }
            
            // Redirect to a success page or perform further actions
            window.location.href = "success.jsp";
        }
    </script>
</body>
</html>