<%@ page import="com.incident.model.User" %>
    <%@ page import="com.incident.service.IncidentService" %>
        <%@ page import="com.incident.service.NotificationService" %>
            <% User user=(User) session.getAttribute("user"); if (user==null || !user.getRole().equals("OFFICER")) {
                response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } IncidentService
                incidentService=new IncidentService(); NotificationService notificationService=new
                NotificationService(); int assignedCases=incidentService.getOfficerIncidents(user.getUserId()).size();
                int pendingCases=incidentService.getIncidentsCountByStatus("PENDING"); int
                inProgressCases=incidentService.getIncidentsCountByStatus("IN_PROGRESS"); int
                unreadNotifications=notificationService.getUnreadNotificationCount(user.getUserId()); %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Officer Dashboard - Incident Reporting System</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                    <style>
                        :root {
                            --primary-color: #10b981;
                            --secondary-color: #059669;
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

                        .stat-card.assigned {
                            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                        }

                        .stat-card.pending {
                            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
                        }

                        .stat-card.stat-progress {
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
                            <small>Officer Dashboard</small>
                        </div>

                        <div class="user-info">
                            <div class="user-avatar">
                                <i class="fas fa-user-shield"></i>
                            </div>
                            <h5>
                                <%= user.getFullName() %>
                            </h5>
                            <small>Officer ID: <%= user.getUserId() %></small>
                        </div>

                        <nav class="nav flex-column">
                            <a class="nav-link active" href="dashboard.jsp">
                                <i class="fas fa-home"></i> Dashboard
                            </a>
                            <a class="nav-link" href="<%=request.getContextPath()%>/incident/list">
                                <i class="fas fa-tasks"></i> Assigned Incidents
                            </a>
                            <a class="nav-link" href="#">
                                <i class="fas fa-search"></i> Search Incidents
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
                                <i class="fas fa-chart-bar"></i> Reports
                            </a>
                            <a class="nav-link" href="<%=request.getContextPath()%>/auth/logout">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </nav>
                    </div>

                    <div class="main-content">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h1>Officer Dashboard</h1>
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
                                <span class="text-muted me-3">Welcome, Officer <%= user.getFullName() %></span>
                                <a href="<%=request.getContextPath()%>/incident/list" class="btn btn-primary btn-sm">
                                    <i class="fas fa-tasks me-2"></i>View Assigned Cases
                                </a>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                <div class="stat-card assigned">
                                    <div class="stat-number">
                                        <%= assignedCases %>
                                    </div>
                                    <div>Assigned Cases</div>
                                    <i class="fas fa-tasks float-end" style="font-size: 2rem; opacity: 0.5;"></i>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card pending">
                                    <div class="stat-number">
                                        <%= pendingCases %>
                                    </div>
                                    <div>Pending Cases</div>
                                    <i class="fas fa-clock float-end" style="font-size: 2rem; opacity: 0.5;"></i>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card stat-progress">
                                    <div class="stat-number">
                                        <%= inProgressCases %>
                                    </div>
                                    <div>In Progress</div>
                                    <i class="fas fa-spinner float-end" style="font-size: 2rem; opacity: 0.5;"></i>
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

                        <div class="row mt-4">
                            <div class="col-md-8">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="mb-0">Recent Assigned Incidents</h5>
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
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>#1001</td>
                                                        <td>Parking Violation</td>
                                                        <td><span class="badge bg-warning">VANDALISM</span></td>
                                                        <td><span class="badge bg-info">MEDIUM</span></td>
                                                        <td><span class="badge bg-primary">IN_PROGRESS</span></td>
                                                        <td>
                                                            <a href="#" class="btn btn-sm btn-outline-primary">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>#1002</td>
                                                        <td>Traffic Accident</td>
                                                        <td><span class="badge bg-danger">ACCIDENT</span></td>
                                                        <td><span class="badge bg-warning">HIGH</span></td>
                                                        <td><span class="badge bg-secondary">PENDING</span></td>
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
                                                <i class="fas fa-list me-2"></i>View All Cases
                                            </a>
                                            <a href="#" class="btn btn-outline-success">
                                                <i class="fas fa-search me-2"></i>Search Incidents
                                            </a>
                                            <a href="#" class="btn btn-outline-info">
                                                <i class="fas fa-file-export me-2"></i>Generate Report
                                            </a>
                                            <a href="#" class="btn btn-outline-warning">
                                                <i class="fas fa-cog me-2"></i>Settings
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>