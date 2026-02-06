<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.incident.model.User" %>
        <%@ page import="com.incident.model.Incident" %>
            <%@ page import="java.util.List" %>
                <% User user=(User) session.getAttribute("user"); if (user==null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } List<Incident> incidents
                    = (List<Incident>) request.getAttribute("incidents");
                        String keyword = (String) request.getAttribute("searchKeyword");
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Search Results - Incident Reporting System</title>
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                        </head>

                        <body class="bg-light">
                            <div class="container py-5">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2>Search Results</h2>
                                    <a href="<%=request.getContextPath()%>/<%=user.getRole().toLowerCase()%>/dashboard.jsp"
                                        class="btn btn-outline-primary">Back to Dashboard</a>
                                </div>

                                <div class="card mb-4">
                                    <div class="card-body">
                                        <form action="<%=request.getContextPath()%>/incident/search" method="GET"
                                            class="row g-3">
                                            <div class="col-md-4">
                                                <input type="text" name="keyword" class="form-control"
                                                    placeholder="Search by title or description..."
                                                    value="<%= keyword != null ? keyword : "" %>">
                                            </div>
                                            <div class="col-md-2">
                                                <select name="category" class="form-select">
                                                    <option value="">All Categories</option>
                                                    <option value="THEFT">Theft</option>
                                                    <option value="ACCIDENT">Accident</option>
                                                    <option value="FIRE">Fire</option>
                                                    <option value="VANDALISM">Vandalism</option>
                                                    <option value="NOISE_COMPLAINT">Noise Complaint</option>
                                                    <option value="PUBLIC_SAFETY">Public Safety</option>
                                                    <option value="OTHER">Other</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                                <select name="status" class="form-select">
                                                    <option value="">All Statuses</option>
                                                    <option value="PENDING">Pending</option>
                                                    <option value="IN_PROGRESS">In Progress</option>
                                                    <option value="RESOLVED">Resolved</option>
                                                    <option value="CLOSED">Closed</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                                <select name="severity" class="form-select">
                                                    <option value="">All Severities</option>
                                                    <option value="LOW">Low</option>
                                                    <option value="MEDIUM">Medium</option>
                                                    <option value="HIGH">High</option>
                                                    <option value="CRITICAL">Critical</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                                <button type="submit" class="btn btn-primary w-100">Search</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <% if (incidents !=null && !incidents.isEmpty()) { %>
                                    <div class="row">
                                        <% for (Incident incident : incidents) { %>
                                            <div class="col-md-6 mb-4">
                                                <div class="card h-100 border-0 shadow-sm">
                                                    <div class="card-body">
                                                        <div class="d-flex justify-content-between mb-2">
                                                            <h5 class="card-title text-primary">#<%=
                                                                    incident.getIncidentId() %>: <%= incident.getTitle()
                                                                        %>
                                                            </h5>
                                                            <span class="badge bg-secondary">
                                                                <%= incident.getStatus() %>
                                                            </span>
                                                        </div>
                                                        <p class="card-text text-muted small mb-3">
                                                            <%= incident.getDescription().length()> 150 ?
                                                                incident.getDescription().substring(0, 150) + "..." :
                                                                incident.getDescription() %>
                                                        </p>
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <div>
                                                                <span class="badge bg-info text-dark">
                                                                    <%= incident.getCategory() %>
                                                                </span>
                                                                <span class="badge bg-warning text-dark">
                                                                    <%= incident.getSeverity() %>
                                                                </span>
                                                            </div>
                                                            <a href="<%=request.getContextPath()%>/incident/view?id=<%= incident.getIncidentId() %>"
                                                                class="btn btn-sm btn-outline-primary">View Details</a>
                                                        </div>
                                                    </div>
                                                    <div class="card-footer bg-transparent border-0">
                                                        <small class="text-muted">Reported on: <%=
                                                                incident.getCreatedAt() %></small>
                                                    </div>
                                                </div>
                                            </div>
                                            <% } %>
                                    </div>
                                    <% } else { %>
                                        <div class="text-center py-5">
                                            <i class="fas fa-search-minus fa-3x text-muted mb-3"></i>
                                            <p class="text-muted">No incidents found matching your criteria.</p>
                                        </div>
                                        <% } %>
                            </div>
                        </body>

                        </html>