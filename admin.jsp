<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
    // Check if user is admin
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    
    if (loggedInUser == null || !Boolean.TRUE.equals(isAdmin)) {
        response.sendRedirect("login1.html");
        return;
    }
    
    // Get login history from application scope
    ArrayList<String> loginHistory = (ArrayList<String>) application.getAttribute("loginHistory");
    if (loginHistory == null) {
        loginHistory = new ArrayList<>();
    }
    
    // Get active users
    Map<String, Long> activeUsers = (Map<String, Long>) application.getAttribute("activeUsers");
    if (activeUsers == null) {
        activeUsers = new HashMap<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Panel - Real-time Login History</title>
</head>
<body>
    <h1>Admin Panel - Real-time Login History</h1>
    
    <h2>Total Logins: <%= loginHistory.size() %></h2>
    <h2>Currently Active Users: <%= activeUsers.size() %></h2>
    
    <table border="1">
        <tr>
            <th>Email</th>
            <th>Login Time</th>
            <th>IP Address</th>
            <th>Session ID</th> <!-- Added column for Session ID -->
        </tr>
        <% for (String record : loginHistory) {
            String[] parts = record.split(" \\| ");
            
            if (parts.length >= 4) { // Expecting 4 parts: email, login time, ip address, session ID
        %>
                <tr>
                    <td><%= parts[0] %></td>
                    <td><%= parts[1] %></td>
                    <td><%= parts[2] %></td>
                    <td><%= parts[3] %></td> <!-- Display session ID -->
                </tr>
        <% 
            } 
        } 
        %>
    </table>

    <!-- Clear Button to reset login history -->
    <form action="clearLoginHistory.jsp" method="post">
        <button type="submit">Clear Login History</button>
    </form>

</body>
</html>
