<%@ page import="com.incident.model.User" %>
    <% User user=(User) session.getAttribute("user"); if (user==null || !user.getRole().equals("CITIZEN")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Report Incident - Citizen Dashboard</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <style>
                :root {
                    --primary-color: #667eea;
                    --secondary-color: #764ba2;
                }

                .sidebar {
                    background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                    color: white;
                    min-height: 100vh;
                    position: fixed;
                    width: 250px;
                }

                .main-content {
                    margin-left: 250px;
                    padding: 20px;
                }

                .form-container {
                    background: white;
                    border-radius: 10px;
                    padding: 30px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }

                .form-header {
                    border-bottom: 2px solid #e5e7eb;
                    padding-bottom: 20px;
                    margin-bottom: 30px;
                }

                .form-control:focus,
                .form-select:focus {
                    border-color: var(--primary-color);
                    box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
                }

                .btn-submit {
                    background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                    border: none;
                    color: white;
                    padding: 12px 30px;
                    font-weight: 600;
                }

                .btn-submit:hover {
                    color: white;
                    transform: translateY(-2px);
                    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
                }

                .sidebar-header {
                    padding: 20px;
                    text-align: center;
                    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                }

                .nav-link {
                    color: rgba(255, 255, 255, 0.8);
                    padding: 12px 20px;
                    transition: all 0.3s;
                }

                .nav-link:hover,
                .nav-link.active {
                    color: white;
                    background: rgba(255, 255, 255, 0.1);
                }
            </style>
        </head>

        <body>
            <div class="sidebar">
                <div class="sidebar-header">
                    <h4><i class="fas fa-shield-alt me-2"></i>Incident Reporting</h4>
                    <small>Citizen Dashboard</small>
                </div>

                <nav class="nav flex-column">
                    <a class="nav-link" href="dashboard.jsp">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                    <a class="nav-link active" href="report-incident.jsp">
                        <i class="fas fa-plus-circle"></i> Report Incident
                    </a>
                    <a class="nav-link" href="my-reports.jsp">
                        <i class="fas fa-file-alt"></i> My Reports
                    </a>
                    <a class="nav-link" href="#">
                        <i class="fas fa-bell"></i> Notifications
                    </a>
                    <a class="nav-link" href="#">
                        <i class="fas fa-user-cog"></i> Profile Settings
                    </a>
                    <a class="nav-link" href="<%=request.getContextPath()%>/auth/logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </nav>
            </div>

            <div class="main-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1>Report New Incident</h1>
                    <div>
                        <a href="dashboard.jsp" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>
                </div>

                <div class="form-container">
                    <div class="form-header">
                        <h2>Incident Details</h2>
                        <p class="text-muted">Please provide complete and accurate information about the incident</p>
                    </div>

                    <% String error=(String) request.getAttribute("error"); String success=(String)
                        request.getAttribute("success"); if (error !=null) { %>
                        <div class="alert alert-danger" role="alert">
                            <%= error %>
                        </div>
                        <% } if (success !=null) { %>
                            <div class="alert alert-success" role="alert">
                                <%= success %>
                            </div>
                            <% } %>

                                <form action="<%=request.getContextPath()%>/incident/create" method="POST"
                                    enctype="multipart/form-data">
                                    <div class="row">
                                        <div class="col-md-12 mb-3">
                                            <label for="title" class="form-label">Incident Title *</label>
                                            <input type="text" class="form-control" id="title" name="title"
                                                placeholder="Brief title of the incident" required>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="category" class="form-label">Category *</label>
                                            <select class="form-select" id="category" name="category" required>
                                                <option value="">Select category</option>
                                                <option value="THEFT">Theft</option>
                                                <option value="ACCIDENT">Accident</option>
                                                <option value="FIRE">Fire</option>
                                                <option value="VANDALISM">Vandalism</option>
                                                <option value="NOISE_COMPLAINT">Noise Complaint</option>
                                                <option value="PUBLIC_SAFETY">Public Safety</option>
                                                <option value="OTHER">Other</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="severity" class="form-label">Severity Level *</label>
                                            <select class="form-select" id="severity" name="severity" required>
                                                <option value="MEDIUM" selected>Medium</option>
                                                <option value="LOW">Low</option>
                                                <option value="HIGH">High</option>
                                                <option value="CRITICAL">Critical</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="location" class="form-label">Location *</label>
                                        <input type="text" class="form-control" id="location" name="location"
                                            placeholder="Enter exact location or address" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="description" class="form-label">Detailed Description *</label>
                                        <textarea class="form-control" id="description" name="description" rows="6"
                                            placeholder="Provide detailed description of the incident..."
                                            required></textarea>
                                    </div>

                                    <div class="mb-3">
                                        <label for="attachments" class="form-label">Attachments (Optional)</label>
                                        <input type="file" class="form-control" id="attachments" name="attachment"
                                            multiple accept=".jpg,.jpeg,.png,.pdf,.doc,.docx">
                                        <small class="text-muted">You can upload images or documents related to the
                                            incident</small>
                                    </div>

                                    <div class="alert alert-info" role="alert">
                                        <i class="fas fa-info-circle me-2"></i>
                                        <strong>Important:</strong> Please ensure all information provided is accurate.
                                        False reporting may lead to account suspension.
                                    </div>

                                    <div class="d-flex justify-content-between">
                                        <button type="reset" class="btn btn-outline-secondary">
                                            <i class="fas fa-redo me-2"></i>Reset Form
                                        </button>
                                        <button type="submit" class="btn btn-submit">
                                            <i class="fas fa-paper-plane me-2"></i>Submit Report
                                        </button>
                                    </div>
                                </form>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>