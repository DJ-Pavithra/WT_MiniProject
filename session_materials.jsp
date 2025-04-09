<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String sessionId = request.getParameter("sessionId");
    String loggedInUser = (String) session.getAttribute("loggedInUser");

    if (loggedInUser == null || sessionId == null) {
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
        String materialName = request.getParameter("material_name");
        String materialLink = request.getParameter("material_link");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            String query = "INSERT INTO session_materials (session_id, material_name, material_link, uploaded_at) VALUES (?, ?, ?, NOW())";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, sessionId);
            stmt.setString(2, materialName);
            stmt.setString(3, materialLink);
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
    <title>Session Materials</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            margin: 0;
            padding: 20px;
        }
        .material {
            background: #fff;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .material h3 {
            margin: 0 0 10px;
        }
        .material p {
            margin: 5px 0;
        }
        .form {
            margin-bottom: 20px;
        }
        .form input {
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
    <h1>Session Materials</h1>
    <form method="post" class="form">
        <input type="text" name="material_name" placeholder="Material Name" required>
        <input type="url" name="material_link" placeholder="Material Link" required>
        <button type="submit">Upload</button>
    </form>
    <div>
        <% try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            String query = "SELECT * FROM session_materials WHERE session_id = ? ORDER BY uploaded_at DESC";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, sessionId);
            rs = stmt.executeQuery();

            while (rs.next()) {
        %>
        <div class="material">
            <h3><%= rs.getString("material_name") %></h3>
            <p><a href="<%= rs.getString("material_link") %>" target="_blank">View Material</a></p>
            <p><small>Uploaded on: <%= rs.getString("uploaded_at") %></small></p>
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