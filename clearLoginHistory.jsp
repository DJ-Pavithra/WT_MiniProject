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

    // Clear login history from application scope
    application.setAttribute("loginHistory", new ArrayList<String>());

    // Redirect back to the admin panel
    response.sendRedirect("admin.jsp");
%>
