<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.incident.model.User" %>
        <%@ page import="com.incident.service.IncidentService" %>
            <%@ page import="com.incident.service.NotificationService" %>
                <% User user=(User) session.getAttribute("user"); if (user==null || !user.getRole().equals("ADMIN")) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } IncidentService
                    incidentService=new IncidentService(); NotificationService notificationService=new
                    NotificationService(); int totalIncidents=incidentService.getTotalIncidents(); int
                    pendingIncidents=incidentService.getIncidentsCountByStatus("PENDING"); int
                    inProgressIncidents=incidentService.getIncidentsCountByStatus("IN_PROGRESS"); int
                    resolvedIncidents=incidentService.getIncidentsCountByStatus("RESOLVED"); int
                    unreadNotifications=notificationService.getUnreadNotificationCount(user.getUserId()); %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Admin Dashboard - Incident Reporting System</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                        <style>
                            :root {
                                --primary-color: #8b5cf6;
                                --secondary-color: #7c3aed;
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

                            .stat-card {
                                border: none;
                                border-radius: 10px;
                                padding: 20px;
                                color: white;
                                margin-bottom: 20px;
                            }

                            .stat-card.total {
                                background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
                            }

                            .stat-card.pending {
                                background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
                            }

                            .stat-card.stat-progress {
                                background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
                                min-height: 140px;
                                display: flex;
                                flex-direction: column;
                                justify-content: space-between;
                            }

                            .stat-card.resolved {
                                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                            }

                            .stat-number {
                                font-size: 2.5rem;
                                font-weight: bold;
                                margin-bottom: 5px;
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

                            .user-info {
                                text-align: center;
                                margin-bottom: 30px;
                                padding: 20px;
                            }

                            .user-avatar {
                                width: 80px;
                                height: 80px;
                                background: rgba(255, 255, 255, 0.2);
                                border-radius: 50%;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                margin: 0 auto 15px;
                                font-size: 2rem;
                            }
                        </style>
                    </head>

                    <body>
                        <div class="sidebar">
                            <div class="sidebar-header">
                                <h4><i class="fas fa-shield-alt me-2"></i>Incident Reporting</h4>
                                <small>Admin Dashboard</small>
                            </div>

                            <div class="user-info">
                                <div class="user-avatar">
                                    <i class="fas fa-user-tie"></i>
                                </div>
                                <h5>
                                    <%= user.getFullName() %>
                                </h5>
                                <small>System Administrator</small>
                            </div>

                            <nav class="nav flex-column">
                                <a class="nav-link active" href="dashboard.jsp">
                                    <i class="fas fa-home"></i> Dashboard
                                </a>
                                <a class="nav-link" href="<%=request.getContextPath()%>/incident/list">
                                    <i class="fas fa-list"></i> All Incidents
                                </a>
                                <a class="nav-link" href="<%=request.getContextPath()%>/admin-user/list">
                                    <i class="fas fa-users"></i> Manage Users
                                </a>
                                <a class="nav-link" href="#">
                                    <i class="fas fa-chart-bar"></i> Reports & Analytics
                                </a>
                                <a class="nav-link" href="<%=request.getContextPath()%>/notifications/list">
                                    <i class="fas fa-bell"></i> Notifications
                                    <% if (unreadNotifications> 0) { %>
                                        <span class="badge bg-danger float-end">
                                            <%= unreadNotifications %>
                                        </span>
                                        <% } %>
                                </a>
                                <a class="nav-link" href="#">
                                    <i class="fas fa-cog"></i> System Settings
                                </a>
                                <a class="nav-link" href="<%=request.getContextPath()%>/auth/logout">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </a>
                            </nav>
                        </div>

                        <div class="main-content">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h1>Admin Dashboard</h1>
                                <div>
                                    <form action="<%=request.getContextPath()%>/incident/search" method="GET"
                                        class="d-inline-block me-3">
                                        <div class="input-group">
                                            <input type="text" name="keyword" class="form-control form-control-sm"
                                                placeholder="Search incidents...">
                                            <button class="btn btn-primary btn-sm" type="submit"><i
                                                    class="fas fa-search"></i></button>
                                        </div>
                                    </form>
                                    <span class="text-muted me-3">Welcome, Administrator <%= user.getFullName() %>
                                    </span>
                                    <a href="<%=request.getContextPath()%>/incident/list"
                                        class="btn btn-primary btn-sm">
                                        <i class="fas fa-eye me-2"></i>View All Incidents
                                    </a>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-3">
                                    <div class="stat-card total">
                                        <div class="stat-number">
                                            <%= totalIncidents %>
                                        </div>
                                        <div>Total Incidents</div>
                                        <i class="fas fa-file-alt float-end" style="font-size: 2rem; opacity: 0.5;"></i>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card pending">
                                        <div class="stat-number">
                                            <%= pendingIncidents %>
                                        </div>
                                        <div>Pending</div>
                                        <i class="fas fa-clock float-end" style="font-size: 2rem; opacity: 0.5;"></i>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card stat-progress">
                                        <div class="stat-number">
                                            <%= inProgressIncidents %>
                                        </div>
                                        <div>In Progress</div>
                                        <i class="fas fa-spinner float-end" style="font-size: 2rem; opacity: 0.5;"></i>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card resolved">
                                        <div class="stat-number">
                                            <%= resolvedIncidents %>
                                        </div>
                                        <div>Resolved</div>
                                        <i class="fas fa-check-circle float-end"
                                            style="font-size: 2rem; opacity: 0.5;"></i>
                                    </div>
                                </div>
                            </div>

                            <div class="row mt-4">
                                <div class="col-md-8">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0">Recent Incidents</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Title</th>
                                                            <th>Category</th>
                                                            <th>Severity</th>
                                                            <th>Status</th>
                                                            <th>Reporter</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>#1001</td>
                                                            <td>Stolen Bicycle</td>
                                                            <td><span class="badge bg-danger">THEFT</span></td>
                                                            <td><span class="badge bg-warning">HIGH</span></td>
                                                            <td><span class="badge bg-primary">IN_PROGRESS</span></td>
                                                            <td>John Citizen</td>
                                                            <td>
                                                                <a href="#" class="btn btn-sm btn-outline-primary">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                                <a href="#" class="btn btn-sm btn-outline-warning">
                                                                    <i class="fas fa-edit"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>#1002</td>
                                                            <td>Fire in Building</td>
                                                            <td><span class="badge bg-warning">FIRE</span></td>
                                                            <td><span class="badge bg-danger">CRITICAL</span></td>
                                                            <td><span class="badge bg-success">RESOLVED</span></td>
                                                            <td>Jane Doe</td>
                                                            <td>
                                                                <a href="#" class="btn btn-sm btn-outline-primary">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0">Quick Actions</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="d-grid gap-2">
                                                <a href="<%=request.getContextPath()%>/incident/list"
                                                    class="btn btn-outline-primary">
                                                    <i class="fas fa-list me-2"></i>Manage Incidents
                                                </a>
                                                <a href="<%=request.getContextPath()%>/admin-user/list"
                                                    class="btn btn-outline-success">
                                                    <i class="fas fa-users me-2"></i>Manage Users
                                                </a>
                                                <a href="<%=request.getContextPath()%>/report/export"
                                                    class="btn btn-outline-info">
                                                    <i class="fas fa-file-csv me-2"></i>Export Incidents (CSV)
                                                </a>
                                                <a href="#" class="btn btn-outline-secondary">
                                                    <i class="fas fa-chart-bar me-2"></i>View Analytics
                                                </a>
                                                <a href="#" class="btn btn-outline-warning">
                                                    <i class="fas fa-cog me-2"></i>System Settings
                                                </a>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card mt-3">
                                        <div class="card-header">
                                            <h5 class="mb-0">System Status</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="mb-2">
                                                <span class="me-2">Database:</span>
                                                <span class="badge bg-success">Online</span>
                                            </div>
                                            <div class="mb-2">
                                                <span class="me-2">Server:</span>
                                                <span class="badge bg-success">Running</span>
                                            </div>
                                            <div class="mb-2">
                                                <span class="me-2">Users Online:</span>
                                                <span class="badge bg-info">15</span>
                                            </div>
                                            <div>
                                                <span class="me-2">Storage:</span>
                                                <span class="badge bg-warning">75% Used</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                    </body>

                    </html>