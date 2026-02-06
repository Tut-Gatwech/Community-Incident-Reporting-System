package com.incident.controller;

import com.incident.model.Incident;
import com.incident.model.User;
import com.incident.service.IncidentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/report/export")
public class ReportController extends HttpServlet {

    private IncidentService incidentService;

    public ReportController() {
        this.incidentService = new IncidentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only administrators can access reports");
            return;
        }

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"incident_report_" + System.currentTimeMillis() + ".csv\"");

        try (PrintWriter writer = response.getWriter()) {
            // CSV Header
            writer.println("ID,Title,Category,Severity,Status,Location,Reporter,Assigned To,Created At,Resolved Date");

            List<Incident> incidents = incidentService.getAllIncidents();
            for (Incident i : incidents) {
                StringBuilder sb = new StringBuilder();
                sb.append(i.getIncidentId()).append(",");
                sb.append(escapeCsv(i.getTitle())).append(",");
                sb.append(i.getCategory()).append(",");
                sb.append(i.getSeverity()).append(",");
                sb.append(i.getStatus()).append(",");
                sb.append(escapeCsv(i.getLocation())).append(",");
                sb.append(escapeCsv(i.getReporterName())).append(",");
                sb.append(escapeCsv(i.getAssignedOfficerName() != null ? i.getAssignedOfficerName() : "Unassigned"))
                        .append(",");
                sb.append(i.getCreatedAt()).append(",");
                sb.append(i.getResolvedDate() != null ? i.getResolvedDate() : "");
                writer.println(sb.toString());
            }
        }
    }

    private String escapeCsv(String value) {
        if (value == null)
            return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            value = value.replace("\"", "\"\"");
            return "\"" + value + "\"";
        }
        return value;
    }
}