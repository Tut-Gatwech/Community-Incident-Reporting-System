package com.incident.model;

import java.sql.Timestamp;

public class Incident {
    private int incidentId;
    private String title;
    private String description;
    private String category;
    private String location;
    private String severity;
    private String status;
    private int reportedBy;
    private Integer assignedTo;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp resolvedDate;
    private String reporterName;
    private String assignedOfficerName;
    
    public Incident() {}
    
    public Incident(int incidentId, String title, String description, 
                   String category, String location, String severity, 
                   String status, int reportedBy, Integer assignedTo,
                   Timestamp createdAt, Timestamp updatedAt, Timestamp resolvedDate) {
        this.incidentId = incidentId;
        this.title = title;
        this.description = description;
        this.category = category;
        this.location = location;
        this.severity = severity;
        this.status = status;
        this.reportedBy = reportedBy;
        this.assignedTo = assignedTo;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.resolvedDate = resolvedDate;
    }
    
    // Getters and Setters
    public int getIncidentId() { return incidentId; }
    public void setIncidentId(int incidentId) { this.incidentId = incidentId; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public int getReportedBy() { return reportedBy; }
    public void setReportedBy(int reportedBy) { this.reportedBy = reportedBy; }
    
    public Integer getAssignedTo() { return assignedTo; }
    public void setAssignedTo(Integer assignedTo) { this.assignedTo = assignedTo; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public Timestamp getResolvedDate() { return resolvedDate; }
    public void setResolvedDate(Timestamp resolvedDate) { this.resolvedDate = resolvedDate; }
    
    public String getReporterName() { return reporterName; }
    public void setReporterName(String reporterName) { this.reporterName = reporterName; }
    
    public String getAssignedOfficerName() { return assignedOfficerName; }
    public void setAssignedOfficerName(String assignedOfficerName) { 
        this.assignedOfficerName = assignedOfficerName; 
    }
}
