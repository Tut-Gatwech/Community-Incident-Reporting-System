<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.incident.model.*" %>
        <%@ page import="java.util.List" %>
            <% User user=(User) session.getAttribute("user"); if (user==null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } Incident incident=(Incident)
                request.getAttribute("incident"); List<IncidentUpdate> updates = (List<IncidentUpdate>)
                    request.getAttribute("updates");
                    List<User> officers = (List<User>) request.getAttribute("officers");
                            List<Attachment> attachments = (List<Attachment>) request.getAttribute("attachments");

                                    if (incident == null) {
                                    response.sendRedirect(request.getContextPath() + "/incident/list");
                                    return;
                                    }

                                    String themeColor = "#3b82f6"; // Default blue
                                    String roleName = "Citizen";
                                    if ("ADMIN".equals(user.getRole())) {
                                    themeColor = "#8b5cf6";
                                    roleName = "Administrator";
                                    } else if ("OFFICER".equals(user.getRole())) {
                                    themeColor = "#10b981";
                                    roleName = "Police Officer";
                                    }
                                    %>
                                    <!DOCTYPE html>
                                    <html lang="en">

                                    <head>
                                        <meta charset="UTF-8">
                                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                        <title>Incident #<%= incident.getIncidentId() %> - Details</title>
                                        <link
                                            href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                                            rel="stylesheet">
                                        <link rel="stylesheet"
                                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                                        <link
                                            href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                                            rel="stylesheet">
                                        <style>
                                            :root {
                                                --primary-color: <%=themeColor %>;
                                                --primary-light: <%=themeColor %>22;
                                            }

                                            body {
                                                background-color: #f1f5f9;
                                                font-family: 'Inter', sans-serif;
                                                color: #1e293b;
                                            }

                                            .glass-card {
                                                background: rgba(255, 255, 255, 0.95);
                                                backdrop-filter: blur(10px);
                                                border: 1px solid rgba(255, 255, 255, 0.3);
                                                border-radius: 20px;
                                                box-shadow: 0 10px 40px -10px rgba(0, 0, 0, 0.05);
                                                overflow: hidden;
                                            }

                                            .status-badge {
                                                padding: 8px 20px;
                                                border-radius: 50px;
                                                font-weight: 700;
                                                text-transform: uppercase;
                                                font-size: 0.75rem;
                                                letter-spacing: 0.05em;
                                            }

                                            .status-PENDING {
                                                background-color: #fef3c7;
                                                color: #92400e;
                                            }

                                            .status-IN_PROGRESS {
                                                background-color: #dbeafe;
                                                color: #1e40af;
                                            }

                                            .status-RESOLVED {
                                                background-color: #dcfce7;
                                                color: #166534;
                                            }

                                            .status-CLOSED {
                                                background-color: #f3f4f6;
                                                color: #374151;
                                            }

                                            .severity-badge {
                                                border-radius: 6px;
                                                padding: 4px 12px;
                                                font-size: 0.7rem;
                                                font-weight: 700;
                                            }

                                            .severity-LOW {
                                                background-color: #ecfdf5;
                                                color: #065f46;
                                            }

                                            .severity-MEDIUM {
                                                background-color: #eff6ff;
                                                color: #1e40af;
                                            }

                                            .severity-HIGH {
                                                background-color: #fff7ed;
                                                color: #9a3412;
                                            }

                                            .severity-CRITICAL {
                                                background-color: #fef2f2;
                                                color: #991b1b;
                                            }

                                            .timeline {
                                                border-left: 3px solid var(--primary-light);
                                                padding-left: 25px;
                                                margin-left: 10px;
                                            }

                                            .timeline-item {
                                                margin-bottom: 30px;
                                                position: relative;
                                            }

                                            .timeline-item::before {
                                                content: '';
                                                position: absolute;
                                                left: -38px;
                                                top: 4px;
                                                width: 22px;
                                                height: 22px;
                                                border-radius: 50%;
                                                background: white;
                                                border: 5px solid var(--primary-color);
                                                box-shadow: 0 0 0 4px var(--primary-light);
                                            }

                                            .sidebar {
                                                background: linear-gradient(180deg, var(--primary-color) 0%, #1e293b 100%);
                                                color: white;
                                                min-height: 100vh;
                                                position: fixed;
                                                width: 260px;
                                                z-index: 1000;
                                            }

                                            .main-content {
                                                margin-left: 260px;
                                                padding: 40px;
                                            }

                                            .btn-primary {
                                                background: var(--primary-color);
                                                border: none;
                                                box-shadow: 0 4px 14px 0 var(--primary-light);
                                                transition: all 0.3s;
                                            }

                                            .btn-primary:hover {
                                                transform: translateY(-2px);
                                                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
                                                filter: brightness(110%);
                                            }

                                            .nav-link {
                                                color: rgba(255, 255, 255, 0.7);
                                                padding: 14px 20px;
                                                font-weight: 500;
                                                transition: all 0.2s;
                                                border-radius: 10px;
                                                margin: 4px 15px;
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

                                            .detail-label {
                                                color: #94a3b8;
                                                font-size: 0.75rem;
                                                font-weight: 700;
                                                text-transform: uppercase;
                                                letter-spacing: 0.05em;
                                                margin-bottom: 4px;
                                            }

                                            .detail-value {
                                                color: #334155;
                                                font-weight: 600;
                                                font-size: 1.05rem;
                                            }

                                            .header-section {
                                                margin-bottom: 2rem;
                                                border-bottom: 1px solid #e2e8f0;
                                                padding-bottom: 1.5rem;
                                            }
                                        </style>
                                    </head>

                                    <body>
                                        <div class="sidebar d-none d-md-block">
                                            <div
                                                class="p-4 mb-4 text-center border-bottom border-light border-opacity-10">
                                                <h4 class="mb-0"><i
                                                        class="fas fa-shield-alt me-2 text-warning"></i>IncidentSystem
                                                </h4>
                                                <div class="mt-2 small text-uppercase fw-bold opacity-50"
                                                    style="letter-spacing: 1px;">
                                                    <%= roleName %>
                                                </div>
                                            </div>
                                            <nav class="nav flex-column">
                                                <a class="nav-link"
                                                    href="<%= request.getContextPath() %>/<%= user.getRole().toLowerCase() %>/dashboard.jsp">
                                                    <i class="fas fa-th-large"></i> Dashboard
                                                </a>
                                                <a class="nav-link active"
                                                    href="<%= request.getContextPath() %>/incident/list">
                                                    <i class="fas fa-file-invoice"></i> Reports
                                                </a>
                                                <% if ("ADMIN".equals(user.getRole())) { %>
                                                    <a class="nav-link"
                                                        href="<%= request.getContextPath() %>/admin-user/list">
                                                        <i class="fas fa-users-cog"></i> Users
                                                    </a>
                                                    <% } %>
                                                        <div class="mt-auto p-3 pt-5">
                                                            <div class="p-3 glass-card bg-opacity-10 text-white"
                                                                style="background: rgba(255,255,255,0.05)">
                                                                <small class="opacity-50">Logged in as</small>
                                                                <div class="fw-bold text-truncate">
                                                                    <%= user.getFullName() %>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <a class="nav-link mt-2 text-danger"
                                                            href="<%= request.getContextPath() %>/auth/logout">
                                                            <i class="fas fa-sign-out-alt"></i> Logout
                                                        </a>
                                            </nav>
                                        </div>

                                        <div class="main-content">
                                            <div class="container-fluid">
                                                <!-- Header -->
                                                <div
                                                    class="header-section d-sm-flex justify-content-between align-items-end">
                                                    <div>
                                                        <nav aria-label="breadcrumb">
                                                            <ol class="breadcrumb">
                                                                <li class="breadcrumb-item"><a
                                                                        href="<%= request.getContextPath() %>/incident/list"
                                                                        class="text-decoration-none text-muted">Incidents</a>
                                                                </li>
                                                                <li class="breadcrumb-item active">#<%=
                                                                        incident.getIncidentId() %>
                                                                </li>
                                                            </ol>
                                                        </nav>
                                                        <h1 class="display-6 fw-bold mb-0 text-dark">
                                                            <%= incident.getTitle() %>
                                                        </h1>
                                                    </div>
                                                    <div class="mt-3 mt-sm-0">
                                                        <span class="status-badge status-<%= incident.getStatus() %>">
                                                            <%= incident.getStatus() %>
                                                        </span>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="col-lg-8">
                                                        <!-- Details Card -->
                                                        <div class="glass-card p-4 p-md-5 mb-4 position-relative">
                                                            <div class="position-absolute top-0 end-0 m-4 opacity-10">
                                                                <i class="fas fa-file-alt fa-5x"></i>
                                                            </div>

                                                            <div class="row g-4 mb-5">
                                                                <div class="col-sm-6 col-md-4">
                                                                    <div class="detail-label">Category</div>
                                                                    <div class="detail-value text-primary"><i
                                                                            class="fas fa-folder-open me-2"></i>
                                                                        <%= incident.getCategory() %>
                                                                    </div>
                                                                </div>
                                                                <div class="col-sm-6 col-md-4">
                                                                    <div class="detail-label">Location</div>
                                                                    <div class="detail-value"><i
                                                                            class="fas fa-map-pin me-2 text-danger"></i>
                                                                        <%= incident.getLocation() %>
                                                                    </div>
                                                                </div>
                                                                <div class="col-sm-6 col-md-4">
                                                                    <div class="detail-label">Severity</div>
                                                                    <div>
                                                                        <span
                                                                            class="severity-badge severity-<%= incident.getSeverity() %>">
                                                                            <i class="fas fa-circle me-1 small"></i>
                                                                            <%= incident.getSeverity() %>
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                                <div class="col-sm-6 col-md-4">
                                                                    <div class="detail-label">Reporter</div>
                                                                    <div class="detail-value">
                                                                        <%= incident.getReporterName() %>
                                                                    </div>
                                                                    <small class="text-muted">
                                                                        <%= incident.getCreatedAt() %>
                                                                    </small>
                                                                </div>
                                                                <div class="col-sm-6 col-md-4">
                                                                    <div class="detail-label">Assigned Officer</div>
                                                                    <div class="detail-value">
                                                                        <% if (incident.getAssignedOfficerName() !=null)
                                                                            { %>
                                                                            <span class="text-success"><i
                                                                                    class="fas fa-user-check me-2"></i>
                                                                                <%= incident.getAssignedOfficerName() %>
                                                                            </span>
                                                                            <% } else { %>
                                                                                <span class="text-muted italic"><i
                                                                                        class="fas fa-user-clock me-2"></i>Not
                                                                                    assigned</span>
                                                                                <% } %>
                                                                    </div>
                                                                </div>
                                                                <div class="col-sm-6 col-md-4">
                                                                    <div class="detail-label">Resolved Date</div>
                                                                    <div class="detail-value">
                                                                        <%= (incident.getResolvedDate() !=null) ?
                                                                            incident.getResolvedDate() : "-" %>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <div class="detail-label mb-3 mt-4">Description</div>
                                                            <div class="p-4 rounded-4 mb-4"
                                                                style="background: #f8fafc; border: 1px solid #e2e8f0; line-height: 1.6;">
                                                                <%= incident.getDescription() %>
                                                            </div>

                                                            <% if (attachments !=null && !attachments.isEmpty()) { %>
                                                                <div class="detail-label mb-3 mt-4">Attachments</div>
                                                                <div class="row g-3">
                                                                    <% for (Attachment attachment : attachments) { %>
                                                                        <div class="col-sm-6 col-md-4">
                                                                            <div
                                                                                class="p-3 border rounded-3 bg-light d-flex align-items-center">
                                                                                <i
                                                                                    class="fas fa-file-download me-3 text-primary fa-2x"></i>
                                                                                <div class="text-truncate">
                                                                                    <a href="<%= request.getContextPath() %>/<%= attachment.getFilePath() %>"
                                                                                        target="_blank"
                                                                                        class="text-decoration-none fw-bold text-dark">
                                                                                        <%= attachment.getFileName() %>
                                                                                    </a>
                                                                                    <div class="small text-muted">
                                                                                        <%= attachment.getFileType() %>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <% } %>
                                                                </div>
                                                                <% } %>
                                                        </div>

                                                        <!-- Timeline -->
                                                        <div class="d-flex align-items-center mb-4 mt-5">
                                                            <div class="bg-white p-2 rounded-3 shadow-sm me-3">
                                                                <i class="fas fa-stream text-primary"></i>
                                                            </div>
                                                            <h4 class="mb-0 fw-bold">Case Timeline</h4>
                                                        </div>

                                                        <div class="glass-card p-4 p-md-5">
                                                            <div class="timeline p-2">
                                                                <% if (updates !=null && !updates.isEmpty()) { %>
                                                                    <% for (IncidentUpdate update : updates) { %>
                                                                        <div class="timeline-item">
                                                                            <div
                                                                                class="d-flex justify-content-between align-items-center mb-1">
                                                                                <span class="fw-bold text-dark">
                                                                                    <%= update.getUpdatedByName() %>
                                                                                </span>
                                                                                <span
                                                                                    class="badge bg-light text-muted fw-normal">
                                                                                    <%= update.getCreatedAt() %>
                                                                                </span>
                                                                            </div>
                                                                            <div
                                                                                class="bg-light p-3 rounded-3 mt-2 border-start border-3 border-primary">
                                                                                <%= update.getUpdateText() %>
                                                                            </div>
                                                                        </div>
                                                                        <% } %>
                                                                            <% } %>
                                                                                <div class="timeline-item">
                                                                                    <div
                                                                                        class="d-flex justify-content-between align-items-center mb-1">
                                                                                        <span class="fw-bold text-dark">
                                                                                            <%= incident.getReporterName()
                                                                                                %>
                                                                                        </span>
                                                                                        <span
                                                                                            class="badge bg-light text-muted fw-normal">
                                                                                            <%= incident.getCreatedAt()
                                                                                                %>
                                                                                        </span>
                                                                                    </div>
                                                                                    <div class="text-muted mt-1">
                                                                                        Incident
                                                                                        reported to the system.</div>
                                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-lg-4 mt-4 mt-lg-0">
                                                        <!-- Action Center -->
                                                        <% boolean isAssignedOfficer=(incident.getAssignedTo() !=null &&
                                                            incident.getAssignedTo().equals(user.getUserId())); if
                                                            ("ADMIN".equals(user.getRole()) || isAssignedOfficer) { %>
                                                            <div class="glass-card mb-4">
                                                                <div
                                                                    class="p-4 bg-dark text-white d-flex align-items-center">
                                                                    <i class="fas fa-cogs me-3 text-warning"></i>
                                                                    <h5 class="mb-0">Action Center</h5>
                                                                </div>
                                                                <div class="p-4">
                                                                    <form
                                                                        action="<%= request.getContextPath() %>/incident/update"
                                                                        method="POST">
                                                                        <input type="hidden" name="incidentId"
                                                                            value="<%= incident.getIncidentId() %>">

                                                                        <% if ("ADMIN".equals(user.getRole())) { %>
                                                                            <div class="mb-4">
                                                                                <label
                                                                                    class="form-label detail-label">Assign
                                                                                    Officer</label>
                                                                                <div class="input-group">
                                                                                    <span
                                                                                        class="input-group-text bg-white"><i
                                                                                            class="fas fa-user-plus text-muted"></i></span>
                                                                                    <select name="assignedTo"
                                                                                        class="form-select border-start-0 ps-0">
                                                                                        <option value="">-- Unassigned
                                                                                            --
                                                                                        </option>
                                                                                        <% if (officers !=null) { for
                                                                                            (User officer : officers) {
                                                                                            %>
                                                                                            <option
                                                                                                value="<%= officer.getUserId() %>"
                                                                                                <%=(incident.getAssignedTo()
                                                                                                !=null &&
                                                                                                incident.getAssignedTo()==officer.getUserId())
                                                                                                ? "selected" : "" %>>
                                                                                                <%= officer.getFullName()
                                                                                                    %>
                                                                                            </option>
                                                                                            <% } } %>
                                                                                    </select>
                                                                                </div>
                                                                            </div>
                                                                            <% } %>

                                                                                <div class="mb-4">
                                                                                    <label
                                                                                        class="form-label detail-label">Update
                                                                                        Status</label>
                                                                                    <div class="input-group">
                                                                                        <span
                                                                                            class="input-group-text bg-white"><i
                                                                                                class="fas fa-info-circle text-muted"></i></span>
                                                                                        <select name="status"
                                                                                            class="form-select border-start-0 ps-0">
                                                                                            <option value="PENDING"
                                                                                                <%="PENDING"
                                                                                                .equals(incident.getStatus())
                                                                                                ? "selected" : "" %>
                                                                                                >Pending
                                                                                            </option>
                                                                                            <option value="IN_PROGRESS"
                                                                                                <%="IN_PROGRESS"
                                                                                                .equals(incident.getStatus())
                                                                                                ? "selected" : "" %>>In
                                                                                                Progress
                                                                                            </option>
                                                                                            <option value="RESOLVED"
                                                                                                <%="RESOLVED"
                                                                                                .equals(incident.getStatus())
                                                                                                ? "selected" : "" %>
                                                                                                >Resolved
                                                                                            </option>
                                                                                            <option value="CLOSED"
                                                                                                <%="CLOSED"
                                                                                                .equals(incident.getStatus())
                                                                                                ? "selected" : "" %>
                                                                                                >Closed
                                                                                            </option>
                                                                                        </select>
                                                                                    </div>
                                                                                </div>

                                                                                <div class="mb-4">
                                                                                    <label
                                                                                        class="form-label detail-label">Activity
                                                                                        Note</label>
                                                                                    <textarea name="updateText"
                                                                                        class="form-control" rows="4"
                                                                                        placeholder="Briefly describe the actions taken..."></textarea>
                                                                                </div>

                                                                                <div class="d-grid gap-2">
                                                                                    <button type="submit"
                                                                                        class="btn btn-primary py-3 fw-bold shadow-sm">
                                                                                        Update Case <i
                                                                                            class="fas fa-arrow-right ms-2 mt-1"></i>
                                                                                    </button>

                                                                                    <% if
                                                                                        ("ADMIN".equals(user.getRole()))
                                                                                        { %>
                                                                                        <a href="<%= request.getContextPath() %>/incident/archive?id=<%= incident.getIncidentId() %>"
                                                                                            class="btn btn-outline-secondary py-2 mt-2"
                                                                                            onclick="return confirm('Are you sure you want to archive this incident? This will set status to CLOSED.')">
                                                                                            <i
                                                                                                class="fas fa-archive me-2"></i>Archive
                                                                                            Case
                                                                                        </a>
                                                                                        <% } %>
                                                                                </div>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                            <% } %>

                                                                <!-- Reference Information -->
                                                                <div class="glass-card shadow-sm border-0">
                                                                    <div
                                                                        class="p-4 border-bottom bg-light bg-opacity-50">
                                                                        <h6 class="mb-0 fw-bold">Case Reference</h6>
                                                                    </div>
                                                                    <div class="p-4">
                                                                        <div
                                                                            class="mb-3 d-flex justify-content-between">
                                                                            <span class="text-muted small">Tracking
                                                                                ID</span>
                                                                            <span class="badge bg-dark">#INC-<%=
                                                                                    incident.getIncidentId() %></span>
                                                                        </div>
                                                                        <div
                                                                            class="mb-3 d-flex justify-content-between">
                                                                            <span
                                                                                class="text-muted small">Created</span>
                                                                            <span class="fw-500 small">
                                                                                <%= incident.getCreatedAt().toString().substring(0,
                                                                                    16) %>
                                                                            </span>
                                                                        </div>
                                                                        <div class="d-flex justify-content-between">
                                                                            <span class="text-muted small">DB
                                                                                Sync</span>
                                                                            <span class="text-success small"><i
                                                                                    class="fas fa-check-circle me-1"></i>
                                                                                Connected</span>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <div class="mt-4 text-center">
                                                                    <a href="<%= request.getContextPath() %>/incident/list"
                                                                        class="btn btn-link text-muted text-decoration-none">
                                                                        <i class="fas fa-chevron-left me-2"></i> Back to
                                                                        Incident List
                                                                    </a>
                                                                </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <script
                                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                                    </body>

                                    </html>