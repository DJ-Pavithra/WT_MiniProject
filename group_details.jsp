<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String groupId = request.getParameter("groupId");
    if (groupId == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String jdbcURL = "jdbc:mysql://localhost:3307/studybuddies";
    String dbUser = "root";
    String dbPassword = "";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Group Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            margin: 0;
            padding: 20px;
        }
        .group-details {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .group-details h1 {
            margin: 0 0 10px;
        }
        .group-details p {
            margin: 5px 0;
        }
    </style>
</head>
<body>
    <div class="group-details">
        <% try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            String query = "SELECT * FROM groups WHERE id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, groupId);
            rs = stmt.executeQuery();

            if (rs.next()) {
        %>
        <h1><%= rs.getString("group_name") %></h1>
        <p><strong>Description:</strong> <%= rs.getString("description") %></p>
        <p><strong>Created On:</strong> <%= rs.getString("created_at") %></p>
        <p><strong>WhatsApp Group:</strong> 
            <% String whatsappLink = rs.getString("whatsapp_link"); %>
            <% if (whatsappLink != null && !whatsappLink.isEmpty()) { %>
                <a href="<%= whatsappLink %>" target="_blank">Join WhatsApp Group</a>
            <% } else { %>
                Not available
            <% } %>
        </p>

        <p><a href="group_discussion.jsp?groupId=<%= groupId %>">Go to Discussion Board</a></p>
        <% } else { %>
        <p>Group not found.</p>
        <% } %>
        <% } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } %>
    </div>
</body>
</html>