<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login1.html");
        return;
    }

    String jdbcURL = "jdbc:mysql://localhost:3307/studybuddies";
    String dbUser = "root";
    String dbPassword = "";
    String port="3307";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Study Sessions</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            margin: 0;
            padding: 20px;
        }
        .session {
            background: #fff;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .session h3 {
            margin: 0 0 10px;
        }
        .session p {
            margin: 5px 0;
        }
        .manage-sessions {
            margin-top: 20px;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            font-size: 16px;
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 5px;
            text-decoration: none;
        }
        .btn-primary {
            background-color: #007bff;
        }
    </style>
</head>
<body>
    <h1>Study Sessions</h1>
    <div>
        <% try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            String query = "SELECT * FROM study_sessions WHERE user_email = ?";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, loggedInUser);
            rs = stmt.executeQuery();

            while (rs.next()) {
        %>
        <div class="session">
            <h3><%= rs.getString("session_name") %></h3>
            <p><strong>Date:</strong> <%= rs.getString("session_date") %></p>
            <p><strong>Time:</strong> <%= rs.getString("session_time") %></p>
            <p><strong>Description:</strong> <%= rs.getString("description") %></p>
            <p><a href="session_materials.jsp?sessionId=<%= rs.getString("id") %>">View Materials</a></p>
        </div>
        <% 
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } %>
    </div>
    <div class="manage-sessions">
        <a href="http://localhost/Nexus/manage_sessions.php" class="btn btn-primary">Manage Sessions</a>
    </div>
</body>
</html>