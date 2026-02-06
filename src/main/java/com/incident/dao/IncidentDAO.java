package com.incident.dao;

import com.incident.model.Incident;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IncidentDAO {
    
    public int createIncident(Incident incident) {
        String sql = "INSERT INTO incidents (title, description, category, location, severity, reported_by) VALUES (?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, incident.getTitle());
            pstmt.setString(2, incident.getDescription());
            pstmt.setString(3, incident.getCategory());
            pstmt.setString(4, incident.getLocation());
            pstmt.setString(5, incident.getSeverity());
            pstmt.setInt(6, incident.getReportedBy());
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return generatedId;
    }
    
    public List<Incident> getAllIncidents() {
        List<Incident> incidents = new ArrayList<>();
        String sql = "SELECT i.*, u1.full_name as reporter_name, u2.full_name as officer_name " +
                    "FROM incidents i " +
                    "LEFT JOIN users u1 ON i.reported_by = u1.user_id " +
                    "LEFT JOIN users u2 ON i.assigned_to = u2.user_id " +
                    "ORDER BY i.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Incident incident = new Incident(
                    rs.getInt("incident_id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getString("category"),
                    rs.getString("location"),
                    rs.getString("severity"),
                    rs.getString("status"),
                    rs.getInt("reported_by"),
                    rs.getInt("assigned_to"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("updated_at"),
                    rs.getTimestamp("resolved_date")
                );
                incident.setReporterName(rs.getString("reporter_name"));
                incident.setAssignedOfficerName(rs.getString("officer_name"));
                incidents.add(incident);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return incidents;
    }
    
    public List<Incident> getIncidentsByUser(int userId) {
        List<Incident> incidents = new ArrayList<>();
        String sql = "SELECT i.*, u1.full_name as reporter_name, u2.full_name as officer_name " +
                    "FROM incidents i " +
                    "LEFT JOIN users u1 ON i.reported_by = u1.user_id " +
                    "LEFT JOIN users u2 ON i.assigned_to = u2.user_id " +
                    "WHERE i.reported_by = ? " +
                    "ORDER BY i.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Incident incident = new Incident(
                    rs.getInt("incident_id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getString("category"),
                    rs.getString("location"),
                    rs.getString("severity"),
                    rs.getString("status"),
                    rs.getInt("reported_by"),
                    rs.getInt("assigned_to"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("updated_at"),
                    rs.getTimestamp("resolved_date")
                );
                incident.setReporterName(rs.getString("reporter_name"));
                incident.setAssignedOfficerName(rs.getString("officer_name"));
                incidents.add(incident);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return incidents;
    }
    
    public List<Incident> getIncidentsByOfficer(int officerId) {
        List<Incident> incidents = new ArrayList<>();
        String sql = "SELECT i.*, u1.full_name as reporter_name, u2.full_name as officer_name " +
                    "FROM incidents i " +
                    "LEFT JOIN users u1 ON i.reported_by = u1.user_id " +
                    "LEFT JOIN users u2 ON i.assigned_to = u2.user_id " +
                    "WHERE i.assigned_to = ? " +
                    "ORDER BY i.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, officerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Incident incident = new Incident(
                    rs.getInt("incident_id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getString("category"),
                    rs.getString("location"),
                    rs.getString("severity"),
                    rs.getString("status"),
                    rs.getInt("reported_by"),
                    rs.getInt("assigned_to"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("updated_at"),
                    rs.getTimestamp("resolved_date")
                );
                incident.setReporterName(rs.getString("reporter_name"));
                incident.setAssignedOfficerName(rs.getString("officer_name"));
                incidents.add(incident);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return incidents;
    }
    
    public Incident getIncidentById(int incidentId) {
        Incident incident = null;
        String sql = "SELECT i.*, u1.full_name as reporter_name, u2.full_name as officer_name " +
                    "FROM incidents i " +
                    "LEFT JOIN users u1 ON i.reported_by = u1.user_id " +
                    "LEFT JOIN users u2 ON i.assigned_to = u2.user_id " +
                    "WHERE i.incident_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, incidentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                incident = new Incident(
                    rs.getInt("incident_id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getString("category"),
                    rs.getString("location"),
                    rs.getString("severity"),
                    rs.getString("status"),
                    rs.getInt("reported_by"),
                    rs.getInt("assigned_to"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("updated_at"),
                    rs.getTimestamp("resolved_date")
                );
                incident.setReporterName(rs.getString("reporter_name"));
                incident.setAssignedOfficerName(rs.getString("officer_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return incident;
    }
    
    public boolean updateIncident(Incident incident) {
        String sql = "UPDATE incidents SET title = ?, description = ?, category = ?, location = ?, " +
                    "severity = ?, status = ?, assigned_to = ?, resolved_date = ? " +
                    "WHERE incident_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, incident.getTitle());
            pstmt.setString(2, incident.getDescription());
            pstmt.setString(3, incident.getCategory());
            pstmt.setString(4, incident.getLocation());
            pstmt.setString(5, incident.getSeverity());
            pstmt.setString(6, incident.getStatus());
            pstmt.setObject(7, incident.getAssignedTo(), Types.INTEGER);
            
            if (incident.getResolvedDate() != null) {
                pstmt.setTimestamp(8, incident.getResolvedDate());
            } else {
                pstmt.setNull(8, Types.TIMESTAMP);
            }
            
            pstmt.setInt(9, incident.getIncidentId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteIncident(int incidentId) {
        String sql = "DELETE FROM incidents WHERE incident_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, incidentId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Incident> searchIncidents(String keyword, String category, String status, String severity) {
        List<Incident> incidents = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT i.*, u1.full_name as reporter_name, u2.full_name as officer_name " +
            "FROM incidents i " +
            "LEFT JOIN users u1 ON i.reported_by = u1.user_id " +
            "LEFT JOIN users u2 ON i.assigned_to = u2.user_id " +
            "WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (i.title LIKE ? OR i.description LIKE ? OR i.location LIKE ?)");
            String likeKeyword = "%" + keyword + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
        }
        
        if (category != null && !category.equals("ALL")) {
            sql.append(" AND i.category = ?");
            params.add(category);
        }
        
        if (status != null && !status.equals("ALL")) {
            sql.append(" AND i.status = ?");
            params.add(status);
        }
        
        if (severity != null && !severity.equals("ALL")) {
            sql.append(" AND i.severity = ?");
            params.add(severity);
        }
        
        sql.append(" ORDER BY i.created_at DESC");
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Incident incident = new Incident(
                    rs.getInt("incident_id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getString("category"),
                    rs.getString("location"),
                    rs.getString("severity"),
                    rs.getString("status"),
                    rs.getInt("reported_by"),
                    rs.getInt("assigned_to"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("updated_at"),
                    rs.getTimestamp("resolved_date")
                );
                incident.setReporterName(rs.getString("reporter_name"));
                incident.setAssignedOfficerName(rs.getString("officer_name"));
                incidents.add(incident);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return incidents;
    }
    
    public List<Incident> getIncidentsByStatus(String status) {
        List<Incident> incidents = new ArrayList<>();
        String sql = "SELECT i.*, u1.full_name as reporter_name, u2.full_name as officer_name " +
                    "FROM incidents i " +
                    "LEFT JOIN users u1 ON i.reported_by = u1.user_id " +
                    "LEFT JOIN users u2 ON i.assigned_to = u2.user_id " +
                    "WHERE i.status = ? " +
                    "ORDER BY i.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Incident incident = new Incident(
                    rs.getInt("incident_id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getString("category"),
                    rs.getString("location"),
                    rs.getString("severity"),
                    rs.getString("status"),
                    rs.getInt("reported_by"),
                    rs.getInt("assigned_to"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("updated_at"),
                    rs.getTimestamp("resolved_date")
                );
                incident.setReporterName(rs.getString("reporter_name"));
                incident.setAssignedOfficerName(rs.getString("officer_name"));
                incidents.add(incident);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return incidents;
    }
    
    public int getIncidentCount() {
        String sql = "SELECT COUNT(*) FROM incidents";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getIncidentCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM incidents WHERE status = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
