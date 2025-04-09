<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    String loggedInUser = (String) session.getAttribute("loggedInUser");

    if (loggedInUser != null) {
        // Get login history from application scope
        ArrayList<String> loginHistory = (ArrayList<String>) application.getAttribute("loginHistory");
        if (loginHistory == null) {
            loginHistory = new ArrayList<>();
        }

        // Find user's login record and update it with logout time
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String logoutTime = sdf.format(new Date());

        for (int i = 0; i < loginHistory.size(); i++) {
            String[] parts = loginHistory.get(i).split(" \\| ");
            if (parts.length >= 5 && parts[0].equals(loggedInUser) && parts[4].isEmpty()) {
                // Update record with logout time
                loginHistory.set(i, parts[0] + " | " + parts[1] + " | " + parts[2] + " | " + parts[3] + " | " + logoutTime);
                break;
            }
        }

        // Update the session attributes
        application.setAttribute("loginHistory", loginHistory);

        // Remove user from active users list
        Map<String, Long> activeUsers = (Map<String, Long>) application.getAttribute("activeUsers");
        if (activeUsers != null) {
            activeUsers.remove(loggedInUser);
            application.setAttribute("activeUsers", activeUsers);
        }
    }

    // Invalidate session
    session.invalidate();

    // Redirect to login page
    response.sendRedirect("login1.html");
%>
