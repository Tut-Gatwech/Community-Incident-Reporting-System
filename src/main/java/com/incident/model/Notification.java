package com.incident.model;

import java.sql.Timestamp;

public class Notification {
    private int notificationId;
    private int userId;
    private String message;
    private String type;
    private boolean isRead;
    private Timestamp createdAt;
    private Integer relatedIncidentId;
    private String incidentTitle;
    
    public Notification() {}
    
    public Notification(int notificationId, int userId, String message, 
                       String type, boolean isRead, Timestamp createdAt,
                       Integer relatedIncidentId) {
        this.notificationId = notificationId;
        this.userId = userId;
        this.message = message;
        this.type = type;
        this.isRead = isRead;
        this.createdAt = createdAt;
        this.relatedIncidentId = relatedIncidentId;
    }
    
    // Getters and Setters
    public int getNotificationId() { return notificationId; }
    public void setNotificationId(int notificationId) { this.notificationId = notificationId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public boolean isRead() { return isRead; }
    public void setRead(boolean isRead) { this.isRead = isRead; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Integer getRelatedIncidentId() { return relatedIncidentId; }
    public void setRelatedIncidentId(Integer relatedIncidentId) { 
        this.relatedIncidentId = relatedIncidentId; 
    }
    
    public String getIncidentTitle() { return incidentTitle; }
    public void setIncidentTitle(String incidentTitle) { this.incidentTitle = incidentTitle; }
}
