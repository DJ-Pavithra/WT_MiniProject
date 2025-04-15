<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, java.security.MessageDigest, java.io.FileWriter, java.io.IOException, java.util.logging.Logger, java.net.URLEncoder" %>

<%
    // Logger for debugging
    Logger logger = Logger.getLogger("SignupLogger");

    // Get parameters from the signup form
    String redirect = request.getParameter("redirect");
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String message = "";
    boolean success = false;

    if (redirect != null && username != null && email != null && password != null) {
        // Forward data to signup.php
        String url = "http://localhost/Nexus/" + redirect;
        response.sendRedirect(url + "?username=" + URLEncoder.encode(username, "UTF-8") + "&email=" + URLEncoder.encode(email, "UTF-8") + "&password=" + URLEncoder.encode(password, "UTF-8"));
    } else if (email != null && password != null && username != null) {
        try {
            // Hash the password
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedPassword = md.digest(password.getBytes());
            
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedPassword) {
                sb.append(String.format("%02x", b));
            }
            String passwordHash = sb.toString();
            
            // Get or create users HashMap
            HashMap<String, HashMap<String, String>> users = 
                (HashMap<String, HashMap<String, String>>) application.getAttribute("users");
            
            if (users == null) {
                users = new HashMap<>();
                application.setAttribute("users", users);
            }
            
            // Debug output
            out.println("Current users in system: " + users.keySet()); // Use 'out' instead of System.out
            out.println("Attempting to register: " + email);
            
            // Check if email already exists
            if (users.containsKey(email)) {
                message = "Email already registered";
                out.println("Registration failed: Email exists");
            } else {
                // Store user information
                HashMap<String, String> userInfo = new HashMap<>();
                userInfo.put("username", username);
                userInfo.put("password", passwordHash);
                userInfo.put("registrationDate", new java.util.Date().toString());
                users.put(email, userInfo);
                
                // Debug output
                out.println("Registration successful for: " + email);
                out.println("Updated users in system: " + users.keySet());
                
                // Set registration cookies
                Cookie emailCookie = new Cookie("lastRegisteredEmail", email);
                Cookie usernameCookie = new Cookie("lastRegisteredUser", username);
                emailCookie.setMaxAge(60*60*24*30); // 30 days
                usernameCookie.setMaxAge(60*60*24*30);
                response.addCookie(emailCookie);
                response.addCookie(usernameCookie);
                
                success = true;
                message = "Registration successful!";
            }
        } catch (Exception e) {
            message = "Registration failed: " + e.getMessage();
            out.println("Registration error: " + e.getMessage());
        }
    }
    
    if (!message.isEmpty()) {
        if (success) {
%>
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <title>Registration Success</title>
                <style>
                    .success-message {
                        background-color: #4CAF50;
                        color: white;
                        padding: 20px;
                        border-radius: 5px;
                        text-align: center;
                        margin: 20px;
                    }
                </style>
            </head>
            <body>
                <div class="success-message">
                    <%= message %>
                </div>
                <script>
                    setTimeout(function() {
                        window.location.href = "login1.html";
                    }, 2000);
                </script>
            </body>
            </html>
<%
        } else {
%>
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <title>Registration Error</title>
                <style>
                    .error-message {
                        background-color: #f44336;
                        color: white;
                        padding: 20px;
                        border-radius: 5px;
                        text-align: center;
                        margin: 20px;
                    }
                </style>
            </head>
            <body>
                <div class="error-message">
                    <%= message %>
                </div>
                <script>
                    setTimeout(function() {
                        window.location.href = "register.html";
                    }, 2000);
                </script>
            </body>
            </html>
<%
        }
    }
%>
<form action="http://localhost/Nexus/signup.php" method="POST">
    <input type="text" name="username" placeholder="Enter your username" required>
    <input type="email" name="email" placeholder="Enter your email" required>
    <input type="password" name="password" placeholder="Enter your password" required>
    <button type="submit">Sign Up</button>
</form>
