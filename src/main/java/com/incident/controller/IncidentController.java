package com.incident.controller;

import com.incident.model.Attachment;
import com.incident.model.Incident;
import com.incident.model.IncidentUpdate;
import com.incident.model.User;
import com.incident.service.IncidentService;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class IncidentController extends HttpServlet {
    private IncidentService incidentService;

    @Override
    public void init() {
        incidentService = new IncidentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getPathInfo();

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (action) {
            case "/view":
                handleViewIncident(request, response, user);
                break;
            case "/archive":
                handleArchiveIncident(request, response, user);
                break;
            case "/create":
                request.getRequestDispatcher("/citizen/report-incident.jsp").forward(request, response);
                break;
            case "/list":
                handleListIncidents(request, response, user);
                break;
            case "/search":
                handleSearchIncidents(request, response, user);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getPathInfo();

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (action) {
            case "/create":
                handleCreateIncident(request, response, user);
                break;
            case "/update":
                handleUpdateIncident(request, response, user);
                break;
            case "/delete":
                handleDeleteIncident(request, response, user);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleViewIncident(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        try {
            int incidentId = Integer.parseInt(request.getParameter("id"));
            Incident incident = incidentService.getIncidentById(incidentId);

            if (incident == null) {
                request.setAttribute("error", "Incident not found");
                redirectToDashboard(user, request, response);
                return;
            }

            // Check permission based on role
            boolean hasPermission = false;
            switch (user.getRole()) {
                case "ADMIN":
                    hasPermission = true;
                    break;
                case "OFFICER":
                    hasPermission = (incident.getAssignedTo() != null &&
                            incident.getAssignedTo() == user.getUserId()) ||
                            user.getUserId() == incident.getReportedBy();
                    break;
                case "CITIZEN":
                    hasPermission = user.getUserId() == incident.getReportedBy();
                    break;
            }

            if (!hasPermission) {
                request.setAttribute("error", "You don't have permission to view this incident");
                redirectToDashboard(user, request, response);
                return;
            }

            request.setAttribute("incident", incident);
            request.setAttribute("updates", incidentService.getUpdatesByIncident(incidentId));
            request.setAttribute("attachments", incidentService.getAttachmentsByIncident(incidentId));

            if (user.getRole().equals("ADMIN")) {
                request.setAttribute("officers", incidentService.getOfficers());
            }

            // Forward to appropriate view page
            String viewPage = "/incidents/incident-details.jsp";
            request.getRequestDispatcher(viewPage).forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid incident ID");
            redirectToDashboard(user, request, response);
        }
    }

    private void handleCreateIncident(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        if (!user.getRole().equals("CITIZEN")) {
            request.setAttribute("error", "Only citizens can report incidents");
            redirectToDashboard(user, request, response);
            return;
        }

        Incident incident = new Incident();
        incident.setTitle(request.getParameter("title"));
        incident.setDescription(request.getParameter("description"));
        incident.setCategory(request.getParameter("category"));
        incident.setLocation(request.getParameter("location"));
        incident.setSeverity(request.getParameter("severity"));
        incident.setStatus("PENDING");
        incident.setReportedBy(user.getUserId());

        int incidentId = incidentService.reportIncident(incident);

        if (incidentId > 0) {
            // Handle file upload
            try {
                Part filePart = request.getPart("attachment");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = getFileName(filePart);
                    String extension = "";
                    int i = fileName.lastIndexOf('.');
                    if (i > 0) {
                        extension = fileName.substring(i);
                    }

                    String newFileName = UUID.randomUUID().toString() + extension;
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists())
                        uploadDir.mkdir();

                    String filePath = uploadPath + File.separator + newFileName;
                    filePart.write(filePath);

                    Attachment attachment = new Attachment();
                    attachment.setIncidentId(incidentId);
                    attachment.setFileName(fileName);
                    attachment.setFilePath("uploads/" + newFileName);
                    attachment.setFileType(filePart.getContentType());
                    attachment.setUploadedBy(user.getUserId());

                    incidentService.addAttachment(attachment);
                }
            } catch (Exception e) {
                System.err.println("Error uploading file: " + e.getMessage());
                // We still reported the incident, so we might just log this error
            }

            request.setAttribute("success", "Incident reported successfully!");
            response.sendRedirect(request.getContextPath() + "/incident/view?id=" + incidentId);
        } else {
            request.setAttribute("error", "Failed to report incident");
            request.getRequestDispatcher("/citizen/report-incident.jsp").forward(request, response);
        }
    }

    private void handleUpdateIncident(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        try {
            int incidentId = Integer.parseInt(request.getParameter("incidentId"));
            Incident incident = incidentService.getIncidentById(incidentId);

            if (incident == null) {
                request.setAttribute("error", "Incident not found");
                redirectToDashboard(user, request, response);
                return;
            }

            // Check permission
            boolean hasPermission = false;
            switch (user.getRole()) {
                case "ADMIN":
                    hasPermission = true;
                    break;
                case "OFFICER":
                    hasPermission = (incident.getAssignedTo() != null &&
                            incident.getAssignedTo() == user.getUserId());
                    break;
                case "CITIZEN":
                    hasPermission = user.getUserId() == incident.getReportedBy();
                    break;
            }

            if (!hasPermission) {
                request.setAttribute("error", "You don't have permission to update this incident");
                redirectToDashboard(user, request, response);
                return;
            }

            String oldStatus = incident.getStatus();
            Integer oldAssignedTo = incident.getAssignedTo();

            // Update fields based on role
            if (user.getRole().equals("ADMIN") || user.getRole().equals("OFFICER")) {
                if (request.getParameter("title") != null)
                    incident.setTitle(request.getParameter("title"));
                if (request.getParameter("description") != null)
                    incident.setDescription(request.getParameter("description"));
                if (request.getParameter("category") != null)
                    incident.setCategory(request.getParameter("category"));
                if (request.getParameter("location") != null)
                    incident.setLocation(request.getParameter("location"));
                if (request.getParameter("severity") != null)
                    incident.setSeverity(request.getParameter("severity"));

                String newStatus = request.getParameter("status");
                if (newStatus != null) {
                    incident.setStatus(newStatus);
                    if ("RESOLVED".equals(newStatus) && incident.getResolvedDate() == null) {
                        incident.setResolvedDate(new java.sql.Timestamp(System.currentTimeMillis()));
                    }
                }

                String assignedToStr = request.getParameter("assignedTo");
                if (assignedToStr != null && !assignedToStr.isEmpty()) {
                    incident.setAssignedTo(Integer.parseInt(assignedToStr));
                }
            } else if (user.getRole().equals("CITIZEN")) {
                // Citizens can only update title, description, and location
                if (request.getParameter("title") != null)
                    incident.setTitle(request.getParameter("title"));
                if (request.getParameter("description") != null)
                    incident.setDescription(request.getParameter("description"));
                if (request.getParameter("location") != null)
                    incident.setLocation(request.getParameter("location"));
            }

            boolean success = incidentService.updateIncident(incident);

            if (success) {
                // Log the update in the timeline
                String updateText = request.getParameter("updateText");
                StringBuilder logText = new StringBuilder();

                if (updateText != null && !updateText.trim().isEmpty()) {
                    logText.append(updateText);
                } else {
                    // Auto-generate status/assignment change log if no text provided
                    if (!oldStatus.equals(incident.getStatus())) {
                        logText.append("Status changed from ").append(oldStatus).append(" to ")
                                .append(incident.getStatus()).append(". ");
                    }
                    if (oldAssignedTo == null && incident.getAssignedTo() != null) {
                        logText.append("Incident assigned to an officer.");
                    } else if (oldAssignedTo != null && !oldAssignedTo.equals(incident.getAssignedTo())) {
                        logText.append("Incident reassigned to another officer.");
                    }
                }

                if (logText.length() > 0) {
                    IncidentUpdate update = new IncidentUpdate();
                    update.setIncidentId(incidentId);
                    update.setUpdatedBy(user.getUserId());
                    update.setUpdateText(logText.toString());
                    incidentService.addIncidentUpdate(update);
                }

                request.setAttribute("success", "Incident updated successfully");
            } else {
                request.setAttribute("error", "Failed to update incident");
            }

            response.sendRedirect(request.getContextPath() + "/incident/view?id=" + incidentId);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid incident ID");
            redirectToDashboard(user, request, response);
        }
    }

    private void handleArchiveIncident(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        if (!"ADMIN".equals(user.getRole())) {
            request.setAttribute("error", "Only administrators can archive incidents");
            redirectToDashboard(user, request, response);
            return;
        }

        try {
            int incidentId = Integer.parseInt(request.getParameter("id"));
            boolean success = incidentService.archiveIncident(incidentId);

            if (success) {
                request.setAttribute("success", "Incident archived successfully");
            } else {
                request.setAttribute("error", "Failed to archive incident");
            }
            response.sendRedirect(request.getContextPath() + "/incident/view?id=" + incidentId);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid incident ID");
            redirectToDashboard(user, request, response);
        }
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    private void handleDeleteIncident(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        if (!user.getRole().equals("ADMIN")) {
            request.setAttribute("error", "Only administrators can delete incidents");
            redirectToDashboard(user, request, response);
            return;
        }

        try {
            int incidentId = Integer.parseInt(request.getParameter("id"));
            boolean success = incidentService.deleteIncident(incidentId);

            if (success) {
                request.setAttribute("success", "Incident deleted successfully");
            } else {
                request.setAttribute("error", "Failed to delete incident");
            }

            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid incident ID");
            redirectToDashboard(user, request, response);
        }
    }

    private void handleListIncidents(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        switch (user.getRole()) {
            case "ADMIN":
                request.setAttribute("incidents", incidentService.getAllIncidents());
                request.getRequestDispatcher("/admin/all-incidents.jsp").forward(request, response);
                break;
            case "OFFICER":
                request.setAttribute("incidents", incidentService.getOfficerIncidents(user.getUserId()));
                request.getRequestDispatcher("/officer/assigned-incidents.jsp").forward(request, response);
                break;
            case "CITIZEN":
                request.setAttribute("incidents", incidentService.getUserIncidents(user.getUserId()));
                request.getRequestDispatcher("/citizen/my-reports.jsp").forward(request, response);
                break;
            default:
                redirectToDashboard(user, request, response);
        }
    }

    private void handleSearchIncidents(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");
        String status = request.getParameter("status");
        String severity = request.getParameter("severity");

        java.util.List<Incident> incidents = incidentService.searchIncidents(keyword, category, status, severity);

        request.setAttribute("incidents", incidents);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("searchCategory", category);
        request.setAttribute("searchStatus", status);
        request.setAttribute("searchSeverity", severity);

        // Forward to appropriate search results page
        request.getRequestDispatcher("/incidents/search-results.jsp").forward(request, response);
    }

    private void redirectToDashboard(User user, HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        switch (user.getRole()) {
            case "ADMIN":
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                break;
            case "OFFICER":
                response.sendRedirect(request.getContextPath() + "/officer/dashboard.jsp");
                break;
            case "CITIZEN":
                response.sendRedirect(request.getContextPath() + "/citizen/dashboard.jsp");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}