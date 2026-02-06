<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.incident.model.User" %>
        <%@ page import="java.util.List" %>
            <%@ page import="com.incident.service.NotificationService" %>

                <% User user=(User) session.getAttribute("user"); if (user==null || !user.getRole().equals("ADMIN")) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } List<User> userList =
                    (List<User>) request.getAttribute("users");
                        NotificationService notificationService = new NotificationService();
                        int unreadNotifications = notificationService.getUnreadNotificationCount(user.getUserId());
                        %>

                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Manage Users - Incident Reporting System</title>
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

                                .status-badge {
                                    font-size: 0.8rem;
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
                                    <a class="nav-link" href="<%=request.getContextPath()%>/admin/dashboard.jsp">
                                        <i class="fas fa-home"></i> Dashboard
                                    </a>
                                    <a class="nav-link" href="<%=request.getContextPath()%>/incident/list">
                                        <i class="fas fa-list"></i> All Incidents
                                    </a>
                                    <a class="nav-link active" href="<%=request.getContextPath()%>/admin-user/list">
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
                                    <h1>Manage Users</h1>
                                    <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                                        data-bs-target="#createUserModal">
                                        <i class="fas fa-user-plus me-2"></i>Create New User
                                    </button>
                                </div>

                                <% String success=request.getParameter("success"); String error=(String)
                                    request.getAttribute("error"); if (success !=null) { %>
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        <%= success %>
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                aria-label="Close"></button>
                                    </div>
                                    <% } if (error !=null) { %>
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <%= error %>
                                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                        </div>
                                        <% } %>

                                            <div class="card">
                                                <div class="card-body">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover">
                                                            <thead>
                                                                <tr>
                                                                    <th>ID</th>
                                                                    <th>Full Name</th>
                                                                    <th>Username</th>
                                                                    <th>Email</th>
                                                                    <th>Role</th>
                                                                    <th>Phone</th>
                                                                    <th>Actions</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% if (userList !=null) { for (User u : userList) { %>
                                                                    <tr>
                                                                        <td>#<%= u.getUserId() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= u.getFullName() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= u.getUsername() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= u.getEmail() %>
                                                                        </td>
                                                                        <td>
                                                                            <span class="badge <%= u.getRole().equals("
                                                                                ADMIN") ? "bg-danger" :
                                                                                (u.getRole().equals("OFFICER")
                                                                                ? "bg-info" : "bg-success" ) %>">
                                                                                <%= u.getRole() %>
                                                                            </span>
                                                                        </td>
                                                                        <td>
                                                                            <%= u.getPhone() !=null ? u.getPhone() : "-"
                                                                                %>
                                                                        </td>
                                                                        <td>
                                                                            <a href="<%=request.getContextPath()%>/admin-user/delete?id=<%= u.getUserId() %>"
                                                                                class="btn btn-sm btn-outline-danger"
                                                                                onclick="return confirm('Are you sure you want to deactivate this user?')">
                                                                                <i class="fas fa-user-slash"></i>
                                                                            </a>
                                                                        </td>
                                                                    </tr>
                                                                    <% } } else { %>
                                                                        <tr>
                                                                            <td colspan="7" class="text-center">No users
                                                                                found.</td>
                                                                        </tr>
                                                                        <% } %>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                            </div>

                            <!-- Create User Modal -->
                            <div class="modal fade" id="createUserModal" tabindex="-1"
                                aria-labelledby="createUserModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="createUserModalLabel">Create New User</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                aria-label="Close"></button>
                                        </div>
                                        <form action="<%=request.getContextPath()%>/admin-user/create" method="POST">
                                            <div class="modal-body">
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Full Name *</label>
                                                        <input type="text" class="form-control" name="fullName"
                                                            required>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Username *</label>
                                                        <input type="text" class="form-control" name="username"
                                                            required>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Email Address *</label>
                                                    <input type="email" class="form-control" name="email" required>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Password *</label>
                                                        <input type="password" class="form-control" name="password"
                                                            required>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Role</label>
                                                        <input type="text" class="form-control bg-light" value="OFFICER"
                                                            readonly>
                                                        <input type="hidden" name="role" value="OFFICER">
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Phone</label>
                                                    <input type="text" class="form-control" name="phone">
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Address</label>
                                                    <textarea class="form-control" name="address" rows="2"></textarea>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-primary">Create User</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                        </body>

                        </html>