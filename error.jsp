<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            flex-direction: column;
            background-color: #f5f5f5;
        }
        .error-container {
            text-align: center;
            padding: 30px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 500px;
        }
        h1 {
            color: #d32f2f;
        }
        .back-button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #007AFF;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>Oops! Something went wrong</h1>
        <p>We're sorry, but there was an error processing your request.</p>
        <% if(exception != null) { %>
            <p>Error: <%= exception.getMessage() %></p>
        <% } %>
        <a href="login.html" class="back-button">Back to Login</a>
    </div>
</body>
</html>