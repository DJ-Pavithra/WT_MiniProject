<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String groupId = request.getParameter("groupId");
    String loggedInUser = (String) session.getAttribute("loggedInUser");

    if (loggedInUser == null || groupId == null) {
        response.sendRedirect("login1.html");
        return;
    }

    String jdbcURL = "jdbc:mysql://localhost:3307/studybuddies";
    String dbUser = "root";
    String dbPassword = "";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    if (request.getMethod().equals("POST")) {
        String content = request.getParameter("content");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            String query = "INSERT INTO group_discussions (group_id, user_email, content, created_at) VALUES (?, ?, ?, NOW())";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, groupId);
            stmt.setString(2, loggedInUser);
            stmt.setString(3, content);
            stmt.executeUpdate();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Group Discussion</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            margin: 0;
            padding: 20px;
        }
        .discussion {
            background: #fff;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .discussion h3 {
            margin: 0 0 10px;
        }
        .discussion p {
            margin: 5px 0;
        }
        .form {
            margin-bottom: 20px;
        }
        .form textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .form button {
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h1>Group Discussion</h1>
    <form method="post" class="form">
        <textarea name="content" rows="4" placeholder="Write your message here..." required></textarea>
        <button type="submit">Post</button>
    </form>
    <div>
        <% try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            String query = "SELECT * FROM group_discussions WHERE group_id = ? ORDER BY created_at DESC";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, groupId);
            rs = stmt.executeQuery();

            while (rs.next()) {
        %>
        <div class="discussion">
            <h3><%= rs.getString("user_email") %></h3>
            <p><%= rs.getString("content") %></p>
            <p><small><%= rs.getString("created_at") %></small></p>
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
</body>
</html>