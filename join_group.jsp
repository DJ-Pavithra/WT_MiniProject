<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String groupId = request.getParameter("groupId");
    String loggedInUser = (String) session.getAttribute("loggedInUser");

    if (loggedInUser == null) {
        response.sendRedirect("login1.html");
        return;
    }

    if (groupId == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String jdbcURL = "jdbc:mysql://localhost:3307/studybuddies";
    String dbUser = "root";
    String dbPassword = "";

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        String query = "INSERT INTO group_members (group_id, user_email) VALUES (?, ?)";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, groupId);
        stmt.setString(2, loggedInUser);
        stmt.executeUpdate();

        response.sendRedirect("group_details.jsp?groupId=" + groupId);
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>