package com.incident.dao;

import com.incident.model.Attachment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AttachmentDAO {

    public boolean createAttachment(Attachment attachment) {
        String sql = "INSERT INTO incident_attachments (incident_id, file_name, file_path, file_type, uploaded_by) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, attachment.getIncidentId());
            pstmt.setString(2, attachment.getFileName());
            pstmt.setString(3, attachment.getFilePath());
            pstmt.setString(4, attachment.getFileType());
            pstmt.setInt(5, attachment.getUploadedBy());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Attachment> getAttachmentsByIncident(int incidentId) {
        List<Attachment> attachments = new ArrayList<>();
        String sql = "SELECT * FROM incident_attachments WHERE incident_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, incidentId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                attachments.add(new Attachment(
                        rs.getInt("attachment_id"),
                        rs.getInt("incident_id"),
                        rs.getString("file_name"),
                        rs.getString("file_path"),
                        rs.getString("file_type"),
                        rs.getInt("uploaded_by"),
                        rs.getTimestamp("uploaded_at")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return attachments;
    }
}
