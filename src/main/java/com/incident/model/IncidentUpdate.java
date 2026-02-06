package com.incident.model;

import java.sql.Timestamp;

public class IncidentUpdate {
    private int updateId;
    private int incidentId;
    private String updateText;
    private int updatedBy;
    private Timestamp createdAt;
    private String updatedByName;
    
    // Constructors
    public IncidentUpdate() {}
    
    public IncidentUpdate(int updateId, int incidentId, String updateText, 
                         int updatedBy, Timestamp createdAt) {
        this.updateId = updateId;
        this.incidentId = incidentId;
        this.updateText = updateText;
        this.updatedBy = updatedBy;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getUpdateId() { return updateId; }
    public void setUpdateId(int updateId) { this.updateId = updateId; }
    
    public int getIncidentId() { return incidentId; }
    public void setIncidentId(int incidentId) { this.incidentId = incidentId; }
    
    public String getUpdateText() { return updateText; }
    public void setUpdateText(String updateText) { this.updateText = updateText; }
    
    public int getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(int updatedBy) { this.updatedBy = updatedBy; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getUpdatedByName() { return updatedByName; }
    public void setUpdatedByName(String updatedByName) { this.updatedByName = updatedByName; }
}
