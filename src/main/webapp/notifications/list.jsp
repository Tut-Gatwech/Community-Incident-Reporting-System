<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.incident.model.User" %>
        <%@ page import="com.incident.model.Notification" %>
            <%@ page import="java.util.List" %>
                <% User user=(User) session.getAttribute("user"); if (user==null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } List<Notification>
                    notifications = (List<Notification>) request.getAttribute("notifications");
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>My Notifications - Incident Reporting System</title>
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                            <style>
                                :root {
                                    --primary-color: #4f46e5;
                                    --secondary-color: #4338ca;
                                }

                                .container {
                                    max-width: 800px;
                                    margin-top: 50px;
                                }

                                .notification-card {
                                    border: none;
                                    border-radius: 10px;
                                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                                    margin-bottom: 15px;
                                    transition: all 0.3s;
                                    border-left: 5px solid transparent;
                                }

                                .notification-card.unread {
                                    border-left-color: var(--primary-color);
                                    background-color: #f8fafc;
                                }

                                .notification-card:hover {
                                    transform: translateY(-2px);
                                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                                }

                                .type-icon {
                                    width: 40px;
                                    height: 40px;
                                    border-radius: 50%;
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    margin-right: 15px;
                                }

                                .bg-new {
                                    background-color: #dcfce7;
                                    color: #166534;
                                }

                                .bg-update {
                                    background-color: #dbeafe;
                                    color: #1e40af;
                                }

                                .bg-resolved {
                                    background-color: #fef9c3;
                                    color: #854d0e;
                                }

                                .bg-assign {
                                    background-color: #f5f3ff;
                                    color: #5b21b6;
                                }
                            </style>
                        </head>

                        <body class="bg-light">
                            <div class="container pb-5">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2><i class="fas fa-bell me-2 text-primary"></i>My Notifications</h2>
                                    <div>
                                        <a href="<%=request.getContextPath()%>/notifications/mark-all-read"
                                            class="btn btn-outline-secondary btn-sm">Mark All as Read</a>
                                        <a href="<%=request.getContextPath()%>/<%=user.getRole().toLowerCase()%>/dashboard.jsp"
                                            class="btn btn-primary btn-sm">Back to Dashboard</a>
                                    </div>
                                </div>

                                <% if (notifications !=null && !notifications.isEmpty()) { %>
                                    <% for (Notification n : notifications) { String icon="fa-info-circle" ; String
                                        bgClass="bg-update" ; if ("NEW_INCIDENT".equals(n.getType())) {
                                        icon="fa-plus-circle" ; bgClass="bg-new" ; } else if
                                        ("ASSIGNMENT".equals(n.getType())) { icon="fa-user-check" ; bgClass="bg-assign"
                                        ; } else if ("RESOLVED".equals(n.getType())) { icon="fa-check-circle" ;
                                        bgClass="bg-resolved" ; } %>
                                        <div class="card notification-card <%= n.isRead() ? "" : " unread" %>">
                                            <div class="card-body d-flex align-items-center">
                                                <div class="type-icon <%= bgClass %>">
                                                    <i class="fas <%= icon %>"></i>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <div class="d-flex justify-content-between">
                                                        <h6 class="mb-1">
                                                            <%= n.getMessage() %>
                                                        </h6>
                                                        <small class="text-muted">
                                                            <%= n.getCreatedAt() %>
                                                        </small>
                                                    </div>
                                                    <% if (n.getRelatedIncidentId() !=null) { %>
                                                        <div class="mt-2">
                                                            <a href="<%=request.getContextPath()%>/notifications/mark-read?id=<%= n.getNotificationId() %>&redirect=/incident/view?id=<%= n.getRelatedIncidentId() %>"
                                                                class="btn btn-sm btn-link p-0 text-decoration-none">
                                                                View Related Incident #<%= n.getRelatedIncidentId() %>
                                                            </a>
                                                        </div>
                                                        <% } else if (!n.isRead()) { %>
                                                            <a href="<%=request.getContextPath()%>/notifications/mark-read?id=<%= n.getNotificationId() %>"
                                                                class="btn btn-sm btn-link p-0 text-decoration-none">Mark
                                                                as Read</a>
                                                            <% } %>
                                                </div>
                                            </div>
                                        </div>
                                        <% } %>
                                            <% } else { %>
                                                <div class="text-center py-5">
                                                    <i class="fas fa-bell-slash fa-3x text-muted mb-3"></i>
                                                    <p class="text-muted">You have no notifications at this time.</p>
                                                </div>
                                                <% } %>
                            </div>
                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                        </body>

                        </html>