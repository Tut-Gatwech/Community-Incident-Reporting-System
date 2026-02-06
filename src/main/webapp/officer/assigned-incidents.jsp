<%@ page import="com.incident.model.User" %>
    <%@ page import="com.incident.model.Incident" %>
        <%@ page import="java.util.List" %>
            <% User user=(User) session.getAttribute("user"); if (user==null || !user.getRole().equals("OFFICER")) {
                response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } List<Incident> incidents =
                (List<Incident>) request.getAttribute("incidents");
                    if (incidents == null) {
                    response.sendRedirect(request.getContextPath() + "/incident/list");
                    return;
                    }
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Assigned Incidents - Officer Dashboard</title>
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

                            .main-content {
                                margin-left: 250px;
                                padding: 20px;
                            }

                            .card {
                                border: none;
                                border-radius: 10px;
                                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                            }
                        </style>
                    </head>

                    <body>
                        <div class="sidebar">
                            <div class="sidebar-header">
                                <h4><i class="fas fa-shield-alt me-2"></i>Incident Reporting</h4>
                                <small>Officer Dashboard</small>
                            </div>
                            <nav class="nav flex-column">
                                <a class="nav-link" href="dashboard.jsp">
                                    <i class="fas fa-home"></i> Dashboard
                                </a>
                                <a class="nav-link active" href="<%=request.getContextPath()%>/incident/list">
                                    <i class="fas fa-tasks"></i> Assigned Incidents
                                </a>
                                <a class="nav-link" href="#">
                                    <i class="fas fa-bell"></i> Notifications
                                </a>
                                <a class="nav-link" href="<%=request.getContextPath()%>/auth/logout">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </a>
                            </nav>
                        </div>

                        <div class="main-content">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h1>Assigned Incidents</h1>
                            </div>

                            <div class="card">
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Date</th>
                                                    <th>Title</th>
                                                    <th>Reporter</th>
                                                    <th>Severity</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% if (incidents !=null && !incidents.isEmpty()) { %>
                                                    <% for (Incident incident : incidents) { %>
                                                        <tr>
                                                            <td>#<%= incident.getIncidentId() %>
                                                            </td>
                                                            <td>
                                                                <%= incident.getCreatedAt() %>
                                                            </td>
                                                            <td>
                                                                <%= incident.getTitle() %>
                                                            </td>
                                                            <td>
                                                                <%= incident.getReporterName() %>
                                                            </td>
                                                            <td>
                                                                <% String severityClass="bg-info" ; if
                                                                    ("HIGH".equals(incident.getSeverity()))
                                                                    severityClass="bg-warning" ; else if
                                                                    ("CRITICAL".equals(incident.getSeverity()))
                                                                    severityClass="bg-danger" ; %>
                                                                    <span class="badge <%= severityClass %>">
                                                                        <%= incident.getSeverity() %>
                                                                    </span>
                                                            </td>
                                                            <td>
                                                                <% String statusClass="bg-primary" ; if
                                                                    ("PENDING".equals(incident.getStatus()))
                                                                    statusClass="bg-secondary" ; else if
                                                                    ("RESOLVED".equals(incident.getStatus()))
                                                                    statusClass="bg-success" ; %>
                                                                    <span class="badge <%= statusClass %>">
                                                                        <%= incident.getStatus() %>
                                                                    </span>
                                                            </td>
                                                            <td>
                                                                <a href="<%=request.getContextPath()%>/incident/view?id=<%= incident.getIncidentId() %>"
                                                                    class="btn btn-sm btn-outline-primary">
                                                                    <i class="fas fa-eye"></i> View
                                                                </a>
                                                            </td>
                                                        </tr>
                                                        <% } %>
                                                            <% } else { %>
                                                                <tr>
                                                                    <td colspan="7" class="text-center py-4">No
                                                                        incidents assigned to you.</td>
                                                                </tr>
                                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </body>

                    </html>