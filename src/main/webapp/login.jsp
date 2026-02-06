<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Community Incident Reporting System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            padding: 40px;
            margin: auto;
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-header h2 {
            color: #333;
            font-weight: 600;
        }

        .login-header p {
            color: #666;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 12px;
            font-weight: 600;
            width: 100%;
            border-radius: 5px;
            transition: transform 0.3s;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            color: white;
        }

        .alert {
            margin-top: 20px;
        }

        .system-title {
            text-align: center;
            color: white;
            margin-bottom: 30px;
            font-size: 2.5rem;
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }

        .login-links {
            text-align: center;
            margin-top: 20px;
        }

        .login-links a {
            color: #667eea;
            text-decoration: none;
        }

        .login-links a:hover {
            text-decoration: underline;
        }

        .demo-credentials {
            background: #f8f9fa;
            border-radius: 5px;
            padding: 15px;
            margin-top: 20px;
            font-size: 0.9rem;
        }

        .demo-credentials h6 {
            color: #333;
            margin-bottom: 10px;
        }

        .demo-credentials p {
            margin-bottom: 5px;
            color: #666;
        }
    </style>
</head>

<body>
    <div class="container">
        <h1 class="system-title">Community Incident Reporting System</h1>
        <div class="login-card">
            <div class="login-header">
                <h2>Sign In</h2>
                <p>Access your account to report or manage incidents</p>
            </div>

            <% String error=request.getParameter("error"); String success=request.getParameter("success"); String
                message=request.getParameter("message"); if (error !=null && !error.isEmpty()) { %>
                <div class="alert alert-danger" role="alert">
                    <%= error %>
                </div>
                <% } if (success !=null && !success.isEmpty()) { %>
                    <div class="alert alert-success" role="alert">
                        <%= success %>
                    </div>
                    <% } if (message !=null && !message.isEmpty()) { %>
                        <div class="alert alert-info" role="alert">
                            <%= message %>
                        </div>
                        <% } %>

                            <form action="${pageContext.request.contextPath}/auth/login" method="POST">
                                <div class="mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" name="username"
                                        placeholder="Enter your username" required>
                                </div>
                                <div class="mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="password" name="password"
                                        placeholder="Enter your password" required>
                                </div>
                                <button type="submit" class="btn btn-login">Sign In</button>
                            </form>



                            <div class="login-links">
                                <p>Don't have an account? <a href="register.jsp">Register here</a></p>
                                <p><a href="index.jsp">Back to Home</a></p>
                            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>