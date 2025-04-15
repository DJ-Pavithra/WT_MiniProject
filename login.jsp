<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Date, java.text.SimpleDateFormat, java.io.FileWriter, java.io.IOException" %>
<%@ page import="java.util.HashMap, java.util.Map, java.util.ArrayList" %>
<%@ page import="java.security.MessageDigest" %>
<%
    // Define admin credentials
    final String ADMIN_EMAIL = "admin@gmail.com";
    final String ADMIN_PASSWORD = "adminpass";
    
    // Get parameters from the login form
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    boolean isValid = false;
    
    try {
        if (email != null && password != null) {
            // Special case for admin login
            if (email.equals(ADMIN_EMAIL) && password.equals(ADMIN_PASSWORD)) {
                isValid = true;
            } else {
                // Hash the password for regular users
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                byte[] hashedPassword = md.digest(password.getBytes());
                StringBuilder sb = new StringBuilder();
                for (byte b : hashedPassword) {
                    sb.append(String.format("%02x", b));
                }
                String passwordHash = sb.toString();
                
                // Get users HashMap from application scope
                HashMap<String, HashMap<String, String>> users = 
                    (HashMap<String, HashMap<String, String>>) application.getAttribute("users");
                
                // Initialize users map if it doesn't exist
                if (users == null) {
                    users = new HashMap<>();
                    application.setAttribute("users", users);
                }

                // Validate regular user
                if (users.containsKey(email)) {
                    HashMap<String, String> userInfo = users.get(email);
                    if (userInfo.get("password").equals(passwordHash)) {
                        isValid = true;
                    }
                }
            }

            if (isValid) {
                // Track login time and date
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String loginTime = sdf.format(new Date());
                
                // Store login information in session
                session.setAttribute("loggedInUser", email);
                session.setAttribute("loginTime", loginTime);
                session.setAttribute("isAdmin", email.equals(ADMIN_EMAIL));
                
                // Store login information for admin
                if (application.getAttribute("loginHistory") == null) {
                    application.setAttribute("loginHistory", new ArrayList<String>());
                }
                
                ArrayList<String> loginHistory = 
                    (ArrayList<String>)application.getAttribute("loginHistory");
                
                // Add login record with IP address
                String ipAddress = request.getRemoteAddr();
                String userAgent = request.getHeader("User-Agent");
                loginHistory.add(email + " | " + loginTime + " | " + ipAddress + " | " + userAgent);
                
                // Keep only the last 100 logins
                if (loginHistory.size() > 100) {
                    loginHistory.remove(0);
                }
                
                // Track active users
                if (application.getAttribute("activeUsers") == null) {
                    application.setAttribute("activeUsers", new HashMap<String, Long>());
                }
                HashMap<String, Long> activeUsers = (HashMap<String, Long>)application.getAttribute("activeUsers");
                activeUsers.put(email, new Date().getTime());
                
                response.sendRedirect("dashboard.jsp");
                return;
            }
        }
    } catch (Exception e) {
        // Log the error to the server logs for debugging
        e.printStackTrace();
        out.println("<p>Login error: " + e.getMessage() + "</p>");
    } finally {
        // Ensure the output stream is properly flushed and closed
        out.flush();
    }
    
    if (email != null && !isValid) {
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Failed</title>
    <script>
        alert("Invalid email or password");
        window.location.href = "login1.html";
    </script>
</head>
<body>
</body>
</html>
<%
    }
%>