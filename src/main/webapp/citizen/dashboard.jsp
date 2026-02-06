<%@ page import="com.incident.model.User" %>
    <%@ page import="com.incident.service.IncidentService" %>
        <%@ page import="com.incident.service.NotificationService" %>
            <% User user=(User) session.getAttribute("user"); if (user==null || !user.getRole().equals("CITIZEN")) {
                response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } IncidentService
                incidentService=new IncidentService(); NotificationService notificationService=new
                NotificationService(); int totalReports=incidentService.getUserIncidents(user.getUserId()).size(); int
                pendingReports=incidentService.getIncidentsCountByStatus("PENDING"); int
                resolvedReports=incidentService.getIncidentsCountByStatus("RESOLVED"); int
                unreadNotifications=notificationService.getUnreadNotificationCount(user.getUserId()); %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Citizen Dashboard - Incident Reporting System</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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

                        .nav-link i {
                            width: 20px;
                            margin-right: 10px;
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

                        .stat-card.reports {
                            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                        }

                        .stat-card.pending {
                            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
                        }

                        .stat-card.resolved {
                            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
                        }

                        .stat-card.notifications {
                            background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
                        }

                        .stat-number {
                            font-size: 2.5rem;
                            font-weight: bold;
                            margin-bottom: 5px;
                        }

                        .quick-actions {
                            background: white;
                            border-radius: 10px;
                            padding: 25px;
                            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                            margin-bottom: 30px;
                        }

                        .recent-activity {
                            background: white;
                            border-radius: 10px;
                            padding: 25px;
                            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                        }

                        .activity-item {
                            padding: 15px;
                            border-bottom: 1px solid #e5e7eb;
                            transition: background 0.3s;
                        }

                        .activity-item:hover {
                            background: #f9fafb;
                        }

                        .user-info {
                            text-align: center;
                            margin-bottom: 30px;
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
                            <small>Citizen Dashboard</small>
                        </div>

                        <div class="user-info">
                            <div class="user-avatar">
                                <i class="fas fa-user"></i>
                            </div>
                            <h5>
                                <%= user.getFullName() %>
                            </h5>
                            <small>
                                <%= user.getEmail() %>
                            </small>
                        </div>

                        <nav class="nav flex-column">
                            <a class="nav-link active" href="dashboard.jsp">
                                <i class="fas fa-home"></i> Dashboard
                            </a>
                            <a class="nav-link" href="report-incident.jsp">
                                <i class="fas fa-plus-circle"></i> Report Incident
                            </a>
                            <a class="nav-link" href="<%=request.getContextPath()%>/incident/list">
                                <i class="fas fa-file-alt"></i> My Reports
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
                                <i class="fas fa-user-cog"></i> Profile Settings
                            </a>
                            <a class="nav-link" href="<%=request.getContextPath()%>/auth/logout">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </nav>
                    </div>

                    <div class="main-content">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h1>Dashboard</h1>
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
                                <span class="text-muted me-3">Welcome, <%= user.getFullName() %></span>
                                <a href="report-incident.jsp" class="btn btn-primary btn-sm">
                                    <i class="fas fa-plus me-2"></i>Report New Incident
                                </a>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                <div class="stat-card reports">
                                    <div class="stat-number">
                                        <%= totalReports %>
                                    </div>
                                    <div>Total Reports</div>
                                    <i class="fas fa-file-alt float-end" style="font-size: 2rem; opacity: 0.5;"></i>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card pending">
                                    <div class="stat-number">
                                        <%= pendingReports %>
                                    </div>
                                    <div>Pending</div>
                                    <i class="fas fa-clock float-end" style="font-size: 2rem; opacity: 0.5;"></i>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card resolved">
                                    <div class="stat-number">
                                        <%= resolvedReports %>
                                    </div>
                                    <div>Resolved</div>
                                    <i class="fas fa-check-circle float-end" style="font-size: 2rem; opacity: 0.5;"></i>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card notifications">
                                    <div class="stat-number">
                                        <%= unreadNotifications %>
                                    </div>
                                    <div>Unread Notifications</div>
                                    <i class="fas fa-bell float-end" style="font-size: 2rem; opacity: 0.5;"></i>
                                </div>
                            </div>
                        </div>

                        <div class="quick-actions">
                            <h4 class="mb-4">Quick Actions</h4>
                            <div class="row">
                                <div class="col-md-3 mb-3">
                                    <a href="report-incident.jsp" class="btn btn-outline-primary w-100">
                                        <i class="fas fa-plus-circle me-2"></i>Report Incident
                                    </a>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <a href="<%=request.getContextPath()%>/incident/list"
                                        class="btn btn-outline-success w-100">
                                        <i class="fas fa-list me-2"></i>View Reports
                                    </a>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <a href="#" class="btn btn-outline-info w-100">
                                        <i class="fas fa-search me-2"></i>Search Incidents
                                    </a>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <a href="#" class="btn btn-outline-warning w-100">
                                        <i class="fas fa-download me-2"></i>Download Reports
                                    </a>
                                </div>
                            </div>
                        </div>

                        <div class="recent-activity">
                            <h4 class="mb-4">Recent Activity</h4>
                            <div class="activity-item">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <i class="fas fa-file-medical text-success me-2"></i>
                                        <strong>New Report Submitted</strong>
                                        <p class="mb-0 text-muted">You reported a noise complaint in your area</p>
                                    </div>
                                    <div class="text-muted">2 hours ago</div>
                                </div>
                            </div>
                            <div class="activity-item">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <i class="fas fa-check-circle text-primary me-2"></i>
                                        <strong>Report Updated</strong>
                                        <p class="mb-0 text-muted">Your theft report status changed to "In Progress"</p>
                                    </div>
                                    <div class="text-muted">1 day ago</div>
                                </div>
                            </div>
                            <div class="activity-item">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <i class="fas fa-user-shield text-warning me-2"></i>
                                        <strong>Officer Assigned</strong>
                                        <p class="mb-0 text-muted">An officer has been assigned to your accident report
                                        </p>
                                    </div>
                                    <div class="text-muted">3 days ago</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>