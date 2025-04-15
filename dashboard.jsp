<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Check if user is logged in
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    String loginTime = (String) session.getAttribute("loginTime");

    if (loggedInUser == null) {
        response.sendRedirect("login1.html");
        return;
    }

    // Sanitize visitCountKey to ensure it contains valid characters
    String visitCountKey = "visitCount_" + loggedInUser.replaceAll("[^a-zA-Z0-9_]", "_");
    int userVisitCount = 1; // Default visit count

    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals(visitCountKey)) {
                userVisitCount = Integer.parseInt(cookie.getValue()) + 1;
                break;
            }
        }
    }

    // Store the updated visit count in a cookie
    Cookie visitCountCookie = new Cookie(visitCountKey, String.valueOf(userVisitCount));
    visitCountCookie.setMaxAge(60 * 60 * 24 * 365); // 1 year expiry
    response.addCookie(visitCountCookie);

    // Get user preferences from cookies
    String preferredSubject = "";
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("preferredSubject")) {
                preferredSubject = cookie.getValue();
                break;
            }
        }
    }

    // Check if this is an admin user
    boolean isAdmin = loggedInUser.equals("admin@gmail.com");

    // Database connection
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
    <title>Study Group Finder - Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
            --primary-light: #818cf8;
            --secondary: #f59e0b;
            --dark: #1e293b;
            --light: #f1f5f9;
            --gray: #94a3b8;
            --white: #ffffff;
            --danger: #ef4444;
            --success: #22c55e;
            --radius: 10px;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', 'Segoe UI', sans-serif;
        }

        body {
            background-color: #f8fafc;
            color: var(--dark);
            display: flex;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 260px;
            background: var(--white);
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            padding: 1.5rem;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
            z-index: 100;
            transition: var(--transition);
        }

        .sidebar-header {
            display: flex;
            align-items: center;
            margin-bottom: 2rem;
            gap: 10px;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--primary-dark);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .logo-circle {
            width: 36px;
            height: 36px;
            background: var(--primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 18px;
        }

        .nav-list {
            list-style: none;
            margin-top: 1.5rem;
        }

        .nav-item {
            margin-bottom: 0.5rem;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 0.85rem 1rem;
            border-radius: var(--radius);
            text-decoration: none;
            color: var(--dark);
            font-weight: 500;
            transition: var(--transition);
            position: relative;
            gap: 12px;
        }

        .nav-link i {
            font-size: 1.2rem;
            width: 24px;
            display: flex;
            justify-content: center;
            color: var(--gray);
            transition: var(--transition);
        }

        .nav-link.active, .nav-link:hover {
            background: var(--primary-light);
            color: var(--white);
        }

        .nav-link.active i, .nav-link:hover i {
            color: var(--white);
        }

        .sidebar-footer {
            position: absolute;
            bottom: 1.5rem;
            width: calc(100% - 3rem);
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
            margin-left: 260px;
            padding: 2rem;
            transition: var(--transition);
        }

        /* Top Bar Styles */
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .page-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--dark);
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-info {
            text-align: right;
        }

        .user-name {
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 0.15rem;
            font-size: 0.95rem;
        }

        .user-email {
            color: var(--gray);
            font-size: 0.8rem;
        }

        .profile-image {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--primary);
        }

        /* Welcome Section */
        .welcome-section {
            position: relative;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            border-radius: var(--radius);
            color: var(--white);
            padding: 1.75rem;
            margin-bottom: 2rem;
            overflow: hidden;
            box-shadow: var(--shadow);
        }

        .welcome-text {
            max-width: 70%;
            position: relative;
            z-index: 5;
        }

        .welcome-section h2 {
            font-size: 1.6rem;
            margin-bottom: 0.5rem;
            font-weight: 700;
        }

        .welcome-section p {
            opacity: 0.9;
            margin-bottom: 1.2rem;
        }

        .welcome-stats {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.2);
            padding: 0.75rem 1.25rem;
            border-radius: var(--radius);
            backdrop-filter: blur(10px);
            flex-grow: 1;
            max-width: 150px;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
        }

        .stat-label {
            font-size: 0.85rem;
            opacity: 0.9;
        }

        .welcome-decoration {
            position: absolute;
            top: -50px;
            right: -50px;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .welcome-decoration:before {
            content: '';
            position: absolute;
            top: 80px;
            right: 80px;
            width: 100px;
            height: 100px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 50%;
        }

        /* Card Styles */
        .card {
            background: var(--white);
            border-radius: var(--radius);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            margin-bottom: 1.5rem;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.25rem;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark);
        }

        /* Groups Table */
        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        th {
            font-weight: 600;
            color: var(--gray);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background-color: rgba(99, 102, 241, 0.05);
        }

        .group-name {
            font-weight: 600;
            color: var(--dark);
        }

        .date-cell {
            color: var(--gray);
            font-size: 0.9rem;
        }

        /* Action Buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 0.6rem 1.25rem;
            border-radius: var(--radius);
            border: none;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            font-size: 0.95rem;
        }

        .btn-primary {
            background-color: var(--primary);
            color: var(--white);
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid var(--gray);
            color: var(--dark);
        }

        .btn-outline:hover {
            border-color: var(--primary);
            color: var(--primary);
        }

        .btn-sm {
            padding: 0.35rem 0.75rem;
            font-size: 0.85rem;
        }

        .btn-danger {
            background-color: var(--danger);
            color: var(--white);
        }

        .btn-danger:hover {
            background-color: #dc2626;
        }

        /* Admin Panel */
        .admin-panel {
            background: #fff;
            border-radius: var(--radius);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            border-left: 4px solid var(--secondary);
        }

        .admin-panel h3 {
            color: var(--secondary);
            font-size: 1.2rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .admin-panel h3 i {
            font-size: 1.2rem;
        }

        .admin-links {
            list-style: none;
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }

        .admin-link {
            flex: 1;
            text-decoration: none;
            color: var(--dark);
            background: #f8fafc;
            padding: 1rem;
            border-radius: var(--radius);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            transition: var(--transition);
        }

        .admin-link i {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: var(--secondary);
        }

        .admin-link:hover {
            background: var(--secondary);
            color: white;
        }

        .admin-link:hover i {
            color: white;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .main-content {
                margin-left: 0;
            }

            .sidebar.active {
                transform: translateX(0);
            }

            .main-content.active {
                margin-left: 260px;
            }

            .welcome-text {
                max-width: 100%;
            }
        }

        @media (max-width: 768px) {
            .welcome-stats {
                flex-direction: column;
                gap: 0.5rem;
            }

            .stat-card {
                max-width: 100%;
            }

            .welcome-section h2 {
                font-size: 1.4rem;
            }

            .admin-links {
                flex-direction: column;
            }
        }

        .toggle-menu {
            display: none;
            font-size: 1.5rem;
            cursor: pointer;
        }

        @media (max-width: 992px) {
            .toggle-menu {
                display: block;
            }
        }

        .login-badge {
            background: rgba(255,255,255,0.2);
            border-radius: 20px;
            padding: 6px 12px;
            font-size: 0.8rem;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            backdrop-filter: blur(4px);
        }

        .login-badge i {
            font-size: 0.75rem;
        }

        .preference-chip {
            display: inline-flex;
            align-items: center;
            background: var(--primary-light);
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
            margin: 0.5rem 0;
            gap: 5px;
        }

        .empty-state {
            color: var(--gray);
            font-style: italic;
        }

        .action-btn {
            background: none;
            border: none;
            color: var(--primary);
            cursor: pointer;
            font-size: 1rem;
            padding: 0.25rem;
            border-radius: 4px;
            transition: var(--transition);
        }

        .action-btn:hover {
            background: rgba(99, 102, 241, 0.1);
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <div class="logo-circle">N</div>
            <div class="logo">Nexus</div>
        </div>

        <ul class="nav-list">
            <li class="nav-item">
                <a href="#" class="nav-link active">
                    <i class="fas fa-th-large"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="http://localhost/Nexus/create_group.php?user=<%= loggedInUser %>" class="nav-link">
                    <i class="fas fa-plus-circle"></i>
                    <span>Create Group</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="view_courses.html" class="nav-link">
                    <i class="fas fa-graduation-cap"></i>
                    <span>View Courses</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="chatbot.html" class="nav-link" >
                    <i class="fas fa-robot"></i>
                    <span>Chatbot</span>
                </a>
            </li>
        </ul>

        <div class="sidebar-footer">
            <a href="logout.jsp" class="nav-link">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="toggle-menu" id="menu-toggle">
                <i class="fas fa-bars"></i>
            </div>
            <h1 class="page-title">Dashboard</h1>
            <div class="user-menu">
                <div class="user-info">
                    <div class="user-name"><%= loggedInUser.split("@")[0] %></div>
                    <div class="user-email"><%= loggedInUser %></div>
                </div>
                <img src="https://i.pravatar.cc/100?u=<%= loggedInUser.hashCode() %>" 
                     alt="Profile" class="profile-image">
            </div>
        </div>

        <!-- Welcome Banner -->
        <div class="welcome-section">
            <div class="welcome-decoration"></div>
            <div class="welcome-text">
                <h2>Welcome back, <%= loggedInUser.split("@")[0] %>!</h2>
                <p>Find a study group or create one today to accelerate your learning journey.</p>
                
                <% if (loginTime != null) { %>
                    <div class="login-badge">
                        <i class="far fa-clock"></i>
                        Last login: <%= loginTime %>
                    </div>
                <% } %>

                <div class="welcome-stats">
                    <div class="stat-card">
                        <div class="stat-value"><%= userVisitCount %></div>
                        <div class="stat-label">Visits</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">
                            <% if (!preferredSubject.isEmpty()) { %>
                                <i class="fas fa-check"></i>
                            <% } else { %>
                                <i class="fas fa-times"></i>
                            <% } %>
                        </div>
                        <div class="stat-label">Preferences</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Section -->
        <div class="content-grid">
            <!-- Preferences Card -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Your Profile</h3>
                    <button class="btn btn-outline btn-sm">
                        <i class="fas fa-edit"></i>
                        Edit Preferences
                    </button>
                </div>
                <div>
                    <p>Preferred Subject: 
                        <% if (!preferredSubject.isEmpty()) { %>
                            <span class="preference-chip">
                                <i class="fas fa-bookmark"></i>
                                <%= preferredSubject %>
                            </span>
                        <% } else { %>
                            <span class="empty-state">Not set</span>
                        <% } %>
                    </p>
                </div>
                <button style="background-color: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold; transition: background-color 0.3s ease;" onmouseover="this.style.backgroundColor='#45a049';" onmouseout="this.style.backgroundColor='#4CAF50';" onclick="course()">Courses 📘</button>
            </div>

            <% if (isAdmin) { %>
            <!-- Admin Panel -->
            <div class="admin-panel">
                <h3><i class="fas fa-shield-alt"></i> Admin Dashboard</h3>
                <p>Access administrative tools and reports for the platform.</p>
                <ul class="admin-links">
                    <li>
                        <a href="admin.jsp" class="admin-link">
                            <i class="fas fa-search"></i>
                            User Lookup
                        </a>
                    </li>
                    <li>
                        <a href="http://localhost/Nexus/display_feedback.php" class="admin-link">
                            <i class="fas fa-chart-bar"></i>
                            Analytics
                        </a>
                    </li>
                    <li>
                        <a href="#" class="admin-link">
                            <i class="fas fa-cog"></i>
                            Settings
                        </a>
                    </li>
                </ul>
            </div>
            <% } %>

            <!-- Study Groups Table -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Available Study Groups</h3>
                    <a href="http://localhost/Nexus/create_group.php?user=<%= loggedInUser %>" class="btn btn-primary btn-sm">
                        <i class="fas fa-plus"></i>
                        New Group
                    </a>
                </div>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Group Name</th>
                                <th>Description</th>
                                <th>Created On</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                                    String query = "SELECT id, group_name, description, created_at FROM groups";
                                    stmt = conn.prepareStatement(query);
                                    rs = stmt.executeQuery();
                
                                    while (rs.next()) {
                            %>
                            <tr>
                                <td class="group-name"><%= rs.getString("group_name") %></td>
                                <td><%= rs.getString("description") %></td>
                                <td class="date-cell"><%= rs.getString("created_at") %></td>
                                <td>
                                    <button class="action-btn" title="Join Group">
                                        <i class="fas fa-sign-in-alt"></i>
                                    </button>
                                    <button class="action-btn" title="View Details">
                                        <i class="fas fa-info-circle"></i>
                                    </button>
                                    <a href="group_discussion.jsp?groupId=<%= rs.getString("id") %>" class="action-btn" title="Group Discussion">
                                        <i class="fas fa-comments"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    out.println("<tr><td colspan='4'>Error fetching groups: " + e.getMessage() + "</td></tr>");
                                } finally {
                                    if (rs != null) rs.close();
                                    if (stmt != null) stmt.close();
                                    if (conn != null) conn.close();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        function course(){
            window.location.href = "courses.html";
        }
    </script>
    
</body>
</html>