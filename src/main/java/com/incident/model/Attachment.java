package com.incident.model;

import java.sql.Timestamp;

public class Attachment {
    private int attachmentId;
    private int incidentId;
    private String fileName;
    private String filePath;
    private String fileType;
    private int uploadedBy;
    private Timestamp uploadedAt;

    public Attachment() {}

    public Attachment(int attachmentId, int incidentId, String fileName, String filePath, String fileType, int uploadedBy, Timestamp uploadedAt) {
        this.attachmentId = attachmentId;
        this.incidentId = incidentId;
        this.fileName = fileName;
        this.filePath = filePath;
        this.fileType = fileType;
        this.uploadedBy = uploadedBy;
        this.uploadedAt = uploadedAt;
    }

    // Getters and Setters
    public int getAttachmentId() { return attachmentId; }
    public void setAttachmentId(int attachmentId) { this.attachmentId = attachmentId; }

    public int getIncidentId() { return incidentId; }
    public void setIncidentId(int incidentId) { this.incidentId = incidentId; }

    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public String getFileType() { return fileType; }
    public void setFileType(String fileType) { this.fileType = fileType; }

    public int getUploadedBy() { return uploadedBy; }
    public void setUploadedBy(int uploadedBy) { this.uploadedBy = uploadedBy; }

    public Timestamp getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(Timestamp uploadedAt) { this.uploadedAt = uploadedAt; }
}
