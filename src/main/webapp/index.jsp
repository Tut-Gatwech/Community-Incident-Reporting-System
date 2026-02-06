<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Community Incident Reporting System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .hero-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 100px 0;
            text-align: center;
        }
        
        .feature-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            height: 100%;
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.15);
        }
        
        .feature-icon {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 20px;
        }
        
        .how-it-works {
            background: #f8f9fa;
            padding: 80px 0;
        }
        
        .step {
            text-align: center;
            padding: 20px;
        }
        
        .step-number {
            background: var(--primary-color);
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 1.5rem;
            font-weight: bold;
        }
        
        .role-section {
            padding: 80px 0;
        }
        
        .role-card {
            text-align: center;
            padding: 30px;
            border-radius: 10px;
            background: white;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }
        
        .role-card:hover {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            transform: translateY(-5px);
        }
        
        .role-card:hover .role-icon,
        .role-card:hover .btn-outline-primary {
            color: white;
            border-color: white;
        }
        
        .role-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 20px;
        }
        
        .stats-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 60px 0;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .btn-get-started {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            color: white;
            padding: 12px 30px;
            font-weight: 600;
            border-radius: 5px;
            transition: transform 0.3s;
        }
        
        .btn-get-started:hover {
            transform: translateY(-2px);
            color: white;
        }
        
        .footer {
            background: #1a202c;
            color: white;
            padding: 50px 0;
            margin-top: 50px;
        }
        
        .footer-links a {
            color: #cbd5e0;
            text-decoration: none;
            transition: color 0.3s;
        }
        
        .footer-links a:hover {
            color: white;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-shield-alt text-primary me-2"></i>
                <span class="fw-bold">Incident Reporting</span>
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="login.jsp">Login</a>
                <a class="nav-link" href="register.jsp">Register</a>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <h1 class="display-4 fw-bold mb-4">Community Incident Reporting System</h1>
            <p class="lead mb-4">A secure platform for reporting and managing community incidents efficiently</p>
            <a href="register.jsp" class="btn btn-light btn-lg btn-get-started">Get Started</a>
        </div>
    </section>

    <!-- Features Section -->
    <section class="py-5">
        <div class="container">
            <h2 class="text-center mb-5">Key Features</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="feature-card p-4">
                        <div class="feature-icon">
                            <i class="fas fa-bullhorn"></i>
                        </div>
                        <h4>Easy Reporting</h4>
                        <p>Report incidents quickly with detailed descriptions, locations, and attachments.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card p-4">
                        <div class="feature-icon">
                            <i class="fas fa-search"></i>
                        </div>
                        <h4>Real-time Tracking</h4>
                        <p>Track the status of your reported incidents in real-time with updates.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card p-4">
                        <div class="feature-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <h4>Secure Platform</h4>
                        <p>Your data is protected with secure authentication and encrypted storage.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works -->
    <section class="how-it-works">
        <div class="container">
            <h2 class="text-center mb-5">How It Works</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="step">
                        <div class="step-number">1</div>
                        <h4>Register & Login</h4>
                        <p>Create an account and login to access the reporting system.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="step">
                        <div class="step-number">2</div>
                        <h4>Report Incident</h4>
                        <p>Fill out the incident form with all necessary details and submit.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="step">
                        <div class="step-number">3</div>
                        <h4>Track & Follow</h4>
                        <p>Monitor the progress and receive updates on your reported incidents.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Role-Based Access -->
    <section class="role-section">
        <div class="container">
            <h2 class="text-center mb-5">Role-Based Access</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="role-card">
                        <div class="role-icon">
                            <i class="fas fa-user"></i>
                        </div>
                        <h4>Citizen</h4>
                        <p>Report incidents, track status, and receive notifications.</p>
                        <a href="register.jsp" class="btn btn-outline-primary mt-3">Register as Citizen</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="role-card">
                        <div class="role-icon">
                            <i class="fas fa-user-shield"></i>
                        </div>
                        <h4>Officer</h4>
                        <p>Review and update incidents, assigned cases management.</p>
                        <a href="login.jsp" class="btn btn-outline-primary mt-3">Login as Officer</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="role-card">
                        <div class="role-icon">
                            <i class="fas fa-user-tie"></i>
                        </div>
                        <h4>Administrator</h4>
                        <p>Manage users, assign incidents, and generate reports.</p>
                        <a href="login.jsp" class="btn btn-outline-primary mt-3">Login as Admin</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5>Community Incident Reporting</h5>
                    <p>A secure platform for efficient incident management and community safety.</p>
                </div>
                <div class="col-md-2">
                    <h5>Quick Links</h5>
                    <div class="footer-links">
                        <p><a href="login.jsp">Login</a></p>
                        <p><a href="register.jsp">Register</a></p>
                        <p><a href="#">About Us</a></p>
                    </div>
                </div>
                <div class="col-md-3">
                    <h5>Contact</h5>
                    <div class="footer-links">
                        <p><i class="fas fa-envelope me-2"></i> Tuttymachuphyg@gmail.com</p>
                        <p><i class="fas fa-phone me-2"></i> +251951514131</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <h5>Follow Us</h5>
                    <div class="footer-links">
                        <a href="#" class="me-3"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="me-3"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="me-3"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
            </div>
            <hr class="mt-4 mb-4" style="background-color: #4a5568;">
            <div class="text-center">
                <p>&copy; 2024 Community Incident Reporting System. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
