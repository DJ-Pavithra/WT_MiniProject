<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Study Group Finder</title>
    <style>
        :root {
            --primary-color: #7C3AED;
            --background-color: ${theme == 'dark' ? '#1a1a1a' : '#f3f4f6'};
            --text-color: ${theme == 'dark' ? '#ffffff' : '#111827'};
            --card-bg: ${theme == 'dark' ? '#2d2d2d' : '#ffffff'};
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
        }

        .profile-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
        }

        .profile-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 30px;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--primary-color);
        }

        .profile-info {
            flex: 1;
        }

        .profile-name {
            font-size: 24px;
            font-weight: bold;
            margin: 0 0 10px 0;
        }

        .profile-email {
            color: #666;
            margin: 0;
        }

        .profile-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--card-bg);
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: var(--primary-color);
        }

        .stat-label {
            color: #666;
            margin-top: 5px;
        }

        .profile-section {
            background: var(--card-bg);
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .section-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            color: var(--primary-color);
        }

        .interests-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .interest-tag {
            background: var(--primary-color);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 14px;
        }

        .edit-button {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            transition: opacity 0.2s;
        }

        .edit-button:hover {
            opacity: 0.9;
        }

        .theme-toggle {
            position: fixed;
            top: 20px;
            right: 20px;
            background: var(--card-bg);
            padding: 10px;
            border-radius: 50%;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <div class="profile-header">
            <img src="https://i.pravatar.cc/120?u=${sessionScope.loggedInUser}" alt="Profile" class="profile-avatar">
            <div class="profile-info">
                <h1 class="profile-name">${sessionScope.loggedInUser.split("@")[0]}</h1>
                <p class="profile-email">${sessionScope.loggedInUser}</p>
                <button class="edit-button" onclick="openEditProfile()">Edit Profile</button>
            </div>
        </div>

        <div class="profile-stats">
            <div class="stat-card">
                <div class="stat-number" id="groupsCount">0</div>
                <div class="stat-label">Study Groups</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="sessionsCount">0</div>
                <div class="stat-label">Sessions Attended</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="postsCount">0</div>
                <div class="stat-label">Discussion Posts</div>
            </div>
        </div>

        <div class="profile-section">
            <h2 class="section-title">Interests</h2>
            <div class="interests-tags" id="interestsTags">
                <!-- Interests will be populated by JavaScript -->
            </div>
        </div>

        <div class="profile-section">
            <h2 class="section-title">Manage Profile</h2>
            <a href="http://localhost/Nexus/user_profile.php?user_id=<%= session.getAttribute("loggedInUser") %>" class="edit-button">Edit Profile</a>
        </div>

        <div class="theme-toggle" onclick="toggleTheme()">
            🌓
        </div>
    </div>

    <script>
        // Load user stats using AJAX
        function loadUserStats() {
            fetch('getUserStats.jsp')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('groupsCount').textContent = data.groupsCount;
                    document.getElementById('sessionsCount').textContent = data.sessionsCount;
                    document.getElementById('postsCount').textContent = data.postsCount;
                });
        }

        // Load interests from cookie
        function loadInterests() {
            const interests = getCookie('userInterests') || '';
            const tags = interests.split(',').filter(tag => tag.trim());
            const container = document.getElementById('interestsTags');
            
            container.innerHTML = tags.map(tag => `
                <span class="interest-tag">${tag.trim()}</span>
            `).join('');
        }

        function getCookie(name) {
            const value = `; ${document.cookie}`;
            const parts = value.split(`; ${name}=`);
            if (parts.length === 2) return parts.pop().split(';').shift();
            return null;
        }

        function toggleTheme() {
            const currentTheme = getCookie('userTheme') || 'light';
            const newTheme = currentTheme === 'light' ? 'dark' : 'light';
            
            document.cookie = `userTheme=${newTheme};path=/;max-age=${60 * 60 * 24 * 30}`;
            location.reload();
        }

        // Initialize profile page
        document.addEventListener('DOMContentLoaded', () => {
            loadUserStats();
            loadInterests();
        });
    </script>
</body>
</html>