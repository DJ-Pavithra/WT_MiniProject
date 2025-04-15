<?php
// Define a Course class (Object)
class Course {
    public $name;
    public $instructor;
    public $description;
    public $modules = [];
    public $duration;
    public $level;

    public function __construct($name, $instructor, $description, $modules, $duration, $level) {
        $this->name = $name;
        $this->instructor = $instructor;
        $this->description = $description;
        $this->modules = $modules;
        $this->duration = $duration;
        $this->level = $level;
    }

    public function displayCourse() {
        echo "<div class='course-header'>";
        echo "<h1>{$this->name}</h1>";
        echo "<div class='course-meta'>";
        echo "<p><span class='meta-label'>Instructor:</span> {$this->instructor}</p>";
        echo "<p><span class='meta-label'>Duration:</span> {$this->duration}</p>";
        echo "<p><span class='meta-label'>Level:</span> {$this->level}</p>";
        echo "</div>";
        echo "</div>";
        
        echo "<div class='course-description'>";
        echo "<h2>Course Overview</h2>";
        echo "<p>{$this->description}</p>";
        echo "</div>";
        
        echo "<div class='modules-container'>";
        echo "<h2>Course Curriculum</h2>";
        echo "<div class='modules'>";
        $moduleNum = 1;
        foreach ($this->modules as $moduleName => $moduleContent) {
            echo "<div class='module'>";
            echo "<h3>Module {$moduleNum}: {$moduleName}</h3>";
            echo "<ul>";
            foreach ($moduleContent as $topic) {
                echo "<li>{$topic}</li>";
            }
            echo "</ul>";
            echo "</div>";
            $moduleNum++;
        }
        echo "</div>";
        echo "</div>";
    }
}

// Function to display bonus resources
function showBonus($bonusMaterials) {
    if (!empty($bonusMaterials)) {
        echo "<div class='bonus-section'>";
        echo "<h2>Bonus Materials</h2>";
        echo "<div class='bonus-grid'>";
        
        foreach ($bonusMaterials as $category => $items) {
            echo "<div class='bonus-category'>";
            echo "<h3>{$category}</h3>";
            echo "<ul>";
            foreach ($items as $item) {
                echo "<li>{$item}</li>";
            }
            echo "</ul>";
            echo "</div>";
        }
        
        echo "</div>";
        echo "</div>";
    } else {
        echo "<p class='no-bonus'>No bonus materials available.</p>";
    }
}

// Function to display prerequisites
function showPrerequisites($prerequisites) {
    echo "<div class='prerequisites'>";
    echo "<h2>Prerequisites</h2>";
    echo "<ul>";
    foreach ($prerequisites as $prerequisite) {
        echo "<li>{$prerequisite}</li>";
    }
    echo "</ul>";
    echo "</div>";
}

// Course content (Associative Array with detailed modules)
$modules = [
    "HTML & CSS Fundamentals" => [
        "HTML5 Document Structure and Semantic Tags",
        "CSS Box Model and Layout Techniques",
        "Responsive Design with Media Queries",
        "Flexbox and CSS Grid Systems",
        "CSS Variables and Modern Selectors",
        "Web Accessibility Basics (WCAG)"
    ],
    "JavaScript Essentials" => [
        "JavaScript Syntax and Data Types",
        "DOM Manipulation and Events",
        "Asynchronous JavaScript (Promises, async/await)",
        "ES6+ Features and Best Practices",
        "Error Handling and Debugging",
        "Working with APIs and Fetch"
    ],
    "Frontend Development" => [
        "React Fundamentals and Components",
        "State Management with Context API and Redux",
        "React Hooks and Custom Hooks",
        "Frontend Routing with React Router",
        "Testing React Applications",
        "Performance Optimization Techniques"
    ],
    "Backend Development" => [
        "Node.js Fundamentals and Event Loop",
        "Express.js Framework and Middleware",
        "RESTful API Design Principles",
        "Authentication and Authorization",
        "Data Validation and Error Handling",
        "API Documentation with Swagger/OpenAPI"
    ],
    "Database Systems" => [
        "SQL vs NoSQL Database Concepts",
        "MongoDB Schema Design and CRUD Operations",
        "Mongoose ODM for MongoDB",
        "Data Relationships and Aggregation",
        "Database Indexing and Performance",
        "Redis for Caching and Session Management"
    ],
    "DevOps & Deployment" => [
        "Git Workflow and Collaboration",
        "CI/CD Pipeline Implementation",
        "Docker Containers and Docker Compose",
        "Cloud Deployment (AWS/Azure/GCP)",
        "Application Monitoring and Logging",
        "Security Best Practices for Web Applications"
    ]
];

// Bonus materials
$bonusMaterials = [
    "Career Resources" => [
        "Technical Interview Preparation Guide",
        "Portfolio Development Workshop",
        "Resume and LinkedIn Profile Optimization",
        "Freelancing and Remote Work Tips"
    ],
    "Project Templates" => [
        "MERN Stack Boilerplate with Authentication",
        "E-commerce Platform Starter Kit",
        "Social Media App Template",
        "Progressive Web App (PWA) Template"
    ],
    "Advanced Topics" => [
        "GraphQL API Development",
        "WebSocket Real-time Applications",
        "Serverless Architecture",
        "Microservices Design Patterns"
    ]
];

// Prerequisites
$prerequisites = [
    "Basic understanding of HTML, CSS, and JavaScript",
    "Familiarity with command-line interface",
    "Problem-solving skills and logical thinking",
    "Computer with minimum 8GB RAM recommended"
];

// Course description
$courseDescription = "This comprehensive Full Stack Web Development course will take you from the fundamentals to advanced concepts in both frontend and backend development. Through hands-on projects and real-world examples, you'll build a complete skill set that employers are looking for. By the end of this course, you'll have the knowledge to create, deploy, and maintain modern web applications using the latest industry-standard technologies.";

// Create a course object
$fullStackCourse = new Course(
    "Complete Full Stack Web Development Bootcamp",
    "Sarah Johnson • Senior Software Architect",
    $courseDescription,
    $modules,
    "24 weeks (15-20 hours/week)",
    "Beginner to Advanced"
);

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Full Stack Development Course</title>
    <style>
        :root {
            --primary-color: #3a7bd5;
            --primary-light: #e6f0ff;
            --secondary-color: #00d2ff;
            --text-color: #333;
            --light-gray: #f5f7fa;
            --medium-gray: #e1e5eb;
            --dark-gray: #6c757d;
            --success-color: #28a745;
            --box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            --border-radius: 8px;
            --transition: all 0.3s ease;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            line-height: 1.6;
            color: var(--text-color);
            background: linear-gradient(135deg, #f5f7fa 0%, #eef1f5 100%);
            padding: 0;
            margin: 0;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 1rem 0;
            box-shadow: var(--box-shadow);
        }
        
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }
        
        .logo {
            font-size: 1.5rem;
            font-weight: bold;
        }
        
        nav ul {
            display: flex;
            list-style: none;
        }
        
        nav ul li {
            margin-left: 2rem;
        }
        
        nav ul li a {
            color: white;
            text-decoration: none;
            transition: var(--transition);
        }
        
        nav ul li a:hover {
            opacity: 0.8;
        }
        
        .course-header {
            background-color: white;
            padding: 2rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            box-shadow: var(--box-shadow);
        }
        
        .course-header h1 {
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        
        .course-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            margin-top: 1.5rem;
        }
        
        .meta-label {
            font-weight: bold;
            color: var(--dark-gray);
        }
        
        .course-description {
            background-color: white;
            padding: 2rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            box-shadow: var(--box-shadow);
        }
        
        .course-description h2 {
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        
        .course-description p {
            line-height: 1.8;
        }
        
        .modules-container {
            background-color: white;
            padding: 2rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            box-shadow: var(--box-shadow);
        }
        
        .modules-container h2 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
        }
        
        .modules {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
        }
        
        .module {
            background-color: var(--light-gray);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            transition: var(--transition);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            border-left: 4px solid var(--primary-color);
        }
        
        .module:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        }
        
        .module h3 {
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        
        .module ul {
            padding-left: 1.5rem;
        }
        
        .module li {
            margin-bottom: 0.5rem;
            position: relative;
        }
        
        .prerequisites {
            background-color: white;
            padding: 2rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            box-shadow: var(--box-shadow);
        }
        
        .prerequisites h2 {
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        
        .prerequisites ul {
            padding-left: 1.5rem;
            list-style-type: none;
        }
        
        .prerequisites li {
            margin-bottom: 0.75rem;
            position: relative;
        }
        
        .prerequisites li:before {
            content: "✓";
            color: var(--success-color);
            font-weight: bold;
            display: inline-block;
            width: 1.2rem;
            margin-left: -1.2rem;
        }
        
        .bonus-section {
            background-color: white;
            padding: 2rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            box-shadow: var(--box-shadow);
        }
        
        .bonus-section h2 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
        }
        
        .bonus-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
        }
        
        .bonus-category {
            background-color: var(--primary-light);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            transition: var(--transition);
        }
        
        .bonus-category h3 {
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        
        .bonus-category ul {
            padding-left: 1.5rem;
        }
        
        .bonus-category li {
            margin-bottom: 0.5rem;
        }
        
        .cta-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            padding: 2rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            box-shadow: var(--box-shadow);
            color: white;
            text-align: center;
        }
        
        .cta-section h2 {
            margin-bottom: 1rem;
        }
        
        .cta-btn {
            display: inline-block;
            background-color: white;
            color: var(--primary-color);
            font-weight: bold;
            padding: 0.75rem 2rem;
            border-radius: 30px;
            text-decoration: none;
            margin-top: 1rem;
            transition: var(--transition);
        }
        
        .cta-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        }
        
        footer {
            background-color: #2c3e50;
            color: white;
            padding: 2rem 0;
            margin-top: 3rem;
        }
        
        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
        }
        
        .footer-column {
            flex: 1;
            min-width: 250px;
            margin-bottom: 1.5rem;
        }
        
        .footer-column h3 {
            margin-bottom: 1rem;
        }
        
        .footer-column ul {
            list-style: none;
        }
        
        .footer-column ul li {
            margin-bottom: 0.5rem;
        }
        
        .footer-column ul li a {
            color: #ddd;
            text-decoration: none;
            transition: var(--transition);
        }
        
        .footer-column ul li a:hover {
            color: white;
        }
        
        .copyright {
            max-width: 1200px;
            margin: 0 auto;
            padding: 1.5rem 2rem 0;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
            color: #ddd;
            font-size: 0.9rem;
        }
        
        @media (max-width: 768px) {
            .modules {
                grid-template-columns: 1fr;
            }
            
            .bonus-grid {
                grid-template-columns: 1fr;
            }
            
            .course-meta {
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .header-content {
                flex-direction: column;
                text-align: center;
            }
            
            nav ul {
                margin-top: 1rem;
                justify-content: center;
            }
            
            nav ul li {
                margin: 0 0.75rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="header-content">
            <div class="logo">CodeMasters Academy</div>
            <nav>
                <ul>
                    <li><a href="#">Home</a></li>
                    <li><a href="#">Courses</a></li>
                    <li><a href="#">Resources</a></li>
                    <li><a href="#">Contact</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <div class="container">
        <?php
        // Display course info
        $fullStackCourse->displayCourse();
        
        // Show prerequisites
        showPrerequisites($prerequisites);    
        // Show bonus materials
        showBonus($bonusMaterials);
        ?>
    </div>

    <footer>
        <div class="footer-content">
            <div class="footer-column">
                <h3>About Us</h3>
                <ul>
                    <li><a href="#">Our Story</a></li>
                    <li><a href="#">Instructors</a></li>
                    <li><a href="#">Testimonials</a></li>
                    <li><a href="#">Careers</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h3>Resources</h3>
                <ul>
                    <li><a href="#">Blog</a></li>
                    <li><a href="#">Tutorials</a></li>
                    <li><a href="#">Free Workshops</a></li>
                    <li><a href="#">Community</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h3>Support</h3>
                <ul>
                    <li><a href="#">FAQ</a></li>
                    <li><a href="#">Contact Us</a></li>
                    <li><a href="#">Technical Support</a></li>
                    <li><a href="#">Refund Policy</a></li>
                </ul>
            </div>
        </div>
        <div class="copyright">
            &copy; <?php echo date("Y"); ?> CodeMasters Academy. All rights reserved.
        </div>
    </footer>
</body>
</html>