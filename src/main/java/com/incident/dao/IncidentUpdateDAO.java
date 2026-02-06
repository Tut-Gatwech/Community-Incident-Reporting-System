package com.incident.dao;

import com.incident.model.IncidentUpdate;
import com.incident.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IncidentUpdateDAO {
    
    public int createUpdate(IncidentUpdate update) {
        String sql = "INSERT INTO incident_updates (incident_id, update_text, updated_by) VALUES (?, ?, ?)";
        int generatedId = -1;
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, update.getIncidentId());
            pstmt.setString(2, update.getUpdateText());
            pstmt.setInt(3, update.getUpdatedBy());
            
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
    
    public List<IncidentUpdate> getUpdatesByIncident(int incidentId) {
        List<IncidentUpdate> updates = new ArrayList<>();
        String sql = "SELECT u.*, usr.full_name as updated_by_name " +
                    "FROM incident_updates u " +
                    "JOIN users usr ON u.updated_by = usr.user_id " +
                    "WHERE u.incident_id = ? " +
                    "ORDER BY u.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, incidentId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                IncidentUpdate update = new IncidentUpdate(
                    rs.getInt("update_id"),
                    rs.getInt("incident_id"),
                    rs.getString("update_text"),
                    rs.getInt("updated_by"),
                    rs.getTimestamp("created_at")
                );
                update.setUpdatedByName(rs.getString("updated_by_name"));
                updates.add(update);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return updates;
    }
    
    public IncidentUpdate getUpdateById(int updateId) {
        IncidentUpdate update = null;
        String sql = "SELECT u.*, usr.full_name as updated_by_name " +
                    "FROM incident_updates u " +
                    "JOIN users usr ON u.updated_by = usr.user_id " +
                    "WHERE u.update_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, updateId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                update = new IncidentUpdate(
                    rs.getInt("update_id"),
                    rs.getInt("incident_id"),
                    rs.getString("update_text"),
                    rs.getInt("updated_by"),
                    rs.getTimestamp("created_at")
                );
                update.setUpdatedByName(rs.getString("updated_by_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return update;
    }
    
    public boolean deleteUpdate(int updateId) {
        String sql = "DELETE FROM incident_updates WHERE update_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, updateId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<IncidentUpdate> getRecentUpdates(int limit) {
        List<IncidentUpdate> updates = new ArrayList<>();
        String sql = "SELECT u.*, usr.full_name as updated_by_name " +
                    "FROM incident_updates u " +
                    "JOIN users usr ON u.updated_by = usr.user_id " +
                    "ORDER BY u.created_at DESC " +
                    "LIMIT ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                IncidentUpdate update = new IncidentUpdate(
                    rs.getInt("update_id"),
                    rs.getInt("incident_id"),
                    rs.getString("update_text"),
                    rs.getInt("updated_by"),
                    rs.getTimestamp("created_at")
                );
                update.setUpdatedByName(rs.getString("updated_by_name"));
                updates.add(update);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return updates;
    }
}
