<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful | Bakery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --success: #10b981;
            --success-light: #d1fae5;
            --primary: #3b82f6;
            --primary-dark: #2563eb;
            --warning: #f59e0b;
            --warning-dark: #d97706;
            --light: #f9fafb;
            --dark: #1f2937;
            --gray-100: #f3f4f6;
            --gray-200: #e5e7eb;
            --gray-300: #d1d5db;
            --gray-500: #6b7280;
            --gray-600: #4b5563;
            --shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
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
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 1rem;
        }
        
        .success-container {
            background-color: white;
            border-radius: 16px;
            box-shadow: var(--shadow);
            overflow: hidden;
            width: 100%;
            max-width: 500px;
            text-align: center;
        }
        
        .success-header {
            background-color: var(--success-light);
            padding: 2rem 1rem;
            position: relative;
        }
        
        .success-icon {
            width: 80px;
            height: 80px;
            background-color: var(--success);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin: 0 auto 1rem;
        }
        
        .success-title {
            color: var(--success);
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .success-subtitle {
            color: var(--gray-600);
            font-size: 1.1rem;
        }
        
        .success-content {
            padding: 2rem;
        }
        
        .message {
            color: var(--gray-600);
            font-size: 1.1rem;
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        
        .confetti {
            position: absolute;
            width: 10px;
            height: 10px;
            background-color: #f0f;
            border-radius: 50%;
        }
        
        .buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
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
            background-color: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }
        
        .btn-warning {
            background-color: var(--warning);
            color: white;
        }
        
        .btn-warning:hover {
            background-color: var(--warning-dark);
            transform: translateY(-2px);
        }
        
        @media (max-width: 500px) {
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
    <div class="success-container">
        <div class="success-header">
            <div class="success-icon">
                <i class="fas fa-check"></i>
            </div>
            <h1 class="success-title">Payment Successful!</h1>
            <p class="success-subtitle">Your transaction has been completed</p>
        </div>
        
        <div class="success-content">
            <p class="message">
                Thank you for your booking at our Bakery! Your payment has been successfully processed and your order is confirmed. We look forward to serving you soon.
            </p>
            
            <div class="buttons">
                <form action="http://localhost/Nexus/coureses_materials.php" method="get">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-shopping-bag"></i> View Courses
                    </button>
                </form>
                
                <form action="feedback.html" method="get">
                    <button type="submit" class="btn btn-warning">
                        <i class="fas fa-star"></i> Give Feedback
                    </button>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // Create confetti animation
        function createConfetti() {
            const colors = ['#10b981', '#3b82f6', '#f59e0b', '#ec4899', '#8b5cf6'];
            const confettiCount = 50;
            const container = document.querySelector('.success-header');
            
            for (let i = 0; i < confettiCount; i++) {
                const confetti = document.createElement('div');
                confetti.classList.add('confetti');
                
                // Random position, color, and animation delay
                const size = Math.random() * 8 + 6;
                confetti.style.width = `${size}px`;
                confetti.style.height = `${size}px`;
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.left = `${Math.random() * 100}%`;
                confetti.style.top = `${Math.random() * 100}%`;
                confetti.style.opacity = Math.random() + 0.4;
                confetti.style.animation = `fall ${Math.random() * 3 + 2}s linear forwards`;
                confetti.style.animationDelay = `${Math.random() * 2}s`;
                
                container.appendChild(confetti);
            }
        }
        
        // Add CSS animation for confetti
        const style = document.createElement('style');
        style.textContent = `
            @keyframes fall {
                0% {
                    transform: translateY(-50px) rotate(0deg);
                    opacity: 1;
                }
                100% {
                    transform: translateY(200px) rotate(360deg);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
        
        // Run the confetti animation when page loads
        window.addEventListener('load', createConfetti);
    </script>
</body>
</html>