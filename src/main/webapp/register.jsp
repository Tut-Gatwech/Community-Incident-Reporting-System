<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Community Incident Reporting System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .register-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            padding: 40px;
        }

        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .register-header h2 {
            color: #333;
            font-weight: 600;
        }

        .register-header p {
            color: #666;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 12px;
            font-weight: 600;
            width: 100%;
            border-radius: 5px;
            transition: transform 0.3s;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            color: white;
        }

        .alert {
            margin-top: 20px;
        }

        .register-links {
            text-align: center;
            margin-top: 20px;
        }

        .register-links a {
            color: #667eea;
            text-decoration: none;
        }

        .register-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>
    <div class="register-card">
        <div class="register-header">
            <h2>Create Account</h2>
            <p>Register as a citizen to report incidents</p>
        </div>

        <% String error=request.getParameter("error"); if (error !=null && !error.isEmpty()) { %>
            <div class="alert alert-danger" role="alert">
                <%= error %>
            </div>
            <% } %>

                <form action="${pageContext.request.contextPath}/auth/register" method="POST">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="fullName" class="form-label">Full Name *</label>
                            <input type="text" class="form-control" id="fullName" name="fullName"
                                placeholder="Enter your full name" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="username" class="form-label">Username *</label>
                            <input type="text" class="form-control" id="username" name="username"
                                placeholder="Choose a username" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">Email Address *</label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email"
                            required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="password" class="form-label">Password *</label>
                            <input type="password" class="form-control" id="password" name="password"
                                placeholder="Create a password" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="confirmPassword" class="form-label">Confirm Password *</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                placeholder="Confirm your password" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone Number</label>
                        <input type="tel" class="form-control" id="phone" name="phone" placeholder="Enter phone number">
                    </div>

                    <input type="hidden" name="role" value="CITIZEN">

                    <div class="mb-3">
                        <small class="text-muted">
                            By registering, you agree to our Terms of Service and Privacy Policy.
                        </small>
                    </div>

                    <button type="submit" class="btn btn-register" onclick="return validatePassword()">Create
                        Account</button>
                </form>

                <div class="register-links">
                    <p>Already have an account? <a href="login.jsp">Sign in here</a></p>
                    <p><a href="/">Back to Home</a></p>
                </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function validatePassword() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            if (password != confirmPassword) {
                alert("Passwords do not match!");
                return false;
            }
            return true;
        }
    </script>
</body>

</html>