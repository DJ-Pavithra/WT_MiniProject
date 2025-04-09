<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String groupId = request.getParameter("id");
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login1.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Study Group</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Arial', sans-serif;
        }

        body {
            background-color: #F3F4F6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .group-header {
            background: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .group-title {
            font-size: 24px;
            color: #111827;
            margin-bottom: 10px;
        }

        .group-meta {
            display: flex;
            gap: 20px;
            color: #6B7280;
            font-size: 14px;
        }

        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .tab {
            padding: 10px 20px;
            background: white;
            border-radius: 8px;
            cursor: pointer;
            color: #6B7280;
        }

        .tab.active {
            background: #7C3AED;
            color: white;
        }

        .content-area {
            background: white;
            padding: 20px;
            border-radius: 12px;
            min-height: 400px;
        }

        .discussion-input {
            width: 100%;
            padding: 15px;
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            margin-bottom: 20px;
            resize: vertical;
        }

        .post {
            border-bottom: 1px solid #E5E7EB;
            padding: 15px 0;
        }

        .post-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .post-author {
            font-weight: bold;
            color: #111827;
        }

        .post-time {
            color: #6B7280;
            font-size: 14px;
        }

        .post-content {
            color: #374151;
            margin-bottom: 10px;
        }

        .button {
            background: #7C3AED;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
        }

        .button:hover {
            background: #6D28D9;
        }

        .members-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
        }

        .member-card {
            background: #F9FAFB;
            padding: 15px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .member-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="group-header">
            <h1 class="group-title" id="groupName">Loading...</h1>
            <div class="group-meta">
                <span id="memberCount">0 members</span>
                <span id="createdAt"></span>
            </div>
        </div>

        <div class="tabs">
            <div class="tab active" onclick="switchTab('discussions')">Discussions</div>
            <div class="tab" onclick="switchTab('members')">Members</div>
            <div class="tab" onclick="switchTab('sessions')">Study Sessions</div>
        </div>

        <div class="content-area">
            <div id="discussions-content">
                <textarea class="discussion-input" placeholder="Start a discussion..."></textarea>
                <button class="button" onclick="postDiscussion()">Post</button>
                <div id="posts-container"></div>
            </div>

            <div id="members-content" style="display: none;">
                <div class="members-list" id="members-container"></div>
            </div>

            <div id="sessions-content" style="display: none;">
                <button class="button" onclick="scheduleSession()">Schedule New Session</button>
                <div id="sessions-container"></div>
            </div>
        </div>
    </div>

    <script>
        let currentGroup = null;

        function loadGroupData() {
            fetch('GroupServlet?id=<%= groupId %>')
                .then(response => response.json())
                .then(data => {
                    currentGroup = data;
                    document.getElementById('groupName').textContent = data.name;
                    document.getElementById('memberCount').textContent = 
                        `${data.members.length} members`;
                    document.getElementById('createdAt').textContent = 
                        `Created ${new Date(data.createdAt).toLocaleDateString()}`;
                    renderMembers();
                });
        }

        function switchTab(tabName) {
            document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
            event.target.classList.add('active');
            
            document.getElementById('discussions-content').style.display = 'none';
            document.getElementById('members-content').style.display = 'none';
            document.getElementById('sessions-content').style.display = 'none';
            
            document.getElementById(`${tabName}-content`).style.display = 'block';
        }

        function renderMembers() {
            const container = document.getElementById('members-container');
            container.innerHTML = currentGroup.members.map(member => `
                <div class="member-card">
                    <img src="https://i.pravatar.cc/40?u=${member}" class="member-avatar">
                    <div>
                        <div>${member}</div>
                        <div style="font-size: 12px; color: #6B7280;">
                            ${member === currentGroup.creator ? 'Creator' : 'Member'}
                        </div>
                    </div>
                </div>
            `).join('');
        }

        function postDiscussion() {
            const content = document.querySelector('.discussion-input').value;
            if (!content.trim()) return;

            fetch('GroupServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=post&groupId=<%= groupId %>&content=${encodeURIComponent(content)}`
            })
            .then(response => response.json())
            .then(() => {
                document.querySelector('.discussion-input').value = '';
                loadDiscussions();
            });
        }

        // Initialize
        loadGroupData();
    </script>
</body>
</html> 