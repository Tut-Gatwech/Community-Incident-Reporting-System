package com.incident.dao;

import com.incident.model.Notification;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {
    
    public void createNotification(Notification notification) {
        String sql = "INSERT INTO notifications (user_id, message, type, related_incident_id) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, notification.getUserId());
            pstmt.setString(2, notification.getMessage());
            pstmt.setString(3, notification.getType());
            
            if (notification.getRelatedIncidentId() != null) {
                pstmt.setInt(4, notification.getRelatedIncidentId());
            } else {
                pstmt.setNull(4, Types.INTEGER);
            }
            
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List<Notification> getNotificationsByUser(int userId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT n.*, i.title as incident_title " +
                    "FROM notifications n " +
                    "LEFT JOIN incidents i ON n.related_incident_id = i.incident_id " +
                    "WHERE n.user_id = ? " +
                    "ORDER BY n.created_at DESC " +
                    "LIMIT 50";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Notification notification = new Notification(
                    rs.getInt("notification_id"),
                    rs.getInt("user_id"),
                    rs.getString("message"),
                    rs.getString("type"),
                    rs.getBoolean("is_read"),
                    rs.getTimestamp("created_at"),
                    rs.getInt("related_incident_id")
                );
                notification.setIncidentTitle(rs.getString("incident_title"));
                notifications.add(notification);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }
    
    public int getUnreadNotificationCount(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = FALSE";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public boolean markAsRead(int notificationId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE notification_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, notificationId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean markAllAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteNotification(int notificationId) {
        String sql = "DELETE FROM notifications WHERE notification_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, notificationId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public void notifyOfficersForNewIncident(int incidentId, String title) {
        // Get all officers
        UserDAO userDAO = new UserDAO();
        List<com.incident.model.User> officers = userDAO.getUsersByRole("OFFICER");
        
        for (com.incident.model.User officer : officers) {
            Notification notification = new Notification();
            notification.setUserId(officer.getUserId());
            notification.setMessage("New incident reported: " + title);
            notification.setType("NEW_INCIDENT");
            notification.setRelatedIncidentId(incidentId);
            
            createNotification(notification);
        }
    }
    
    public void notifyIncidentUpdate(int incidentId, String title, int assignedTo) {
        Notification notification = new Notification();
        notification.setUserId(assignedTo);
        notification.setMessage("Incident assigned to you: " + title);
        notification.setType("ASSIGNMENT");
        notification.setRelatedIncidentId(incidentId);
        
        createNotification(notification);
    }
}
