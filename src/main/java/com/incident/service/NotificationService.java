package com.incident.service;

import com.incident.dao.NotificationDAO;
import com.incident.model.Notification;
import java.util.List;

public class NotificationService {
    private NotificationDAO notificationDAO;
    
    public NotificationService() {
        this.notificationDAO = new NotificationDAO();
    }
    
    public List<Notification> getUserNotifications(int userId) {
        return notificationDAO.getNotificationsByUser(userId);
    }
    
    public int getUnreadNotificationCount(int userId) {
        return notificationDAO.getUnreadNotificationCount(userId);
    }
    
    public boolean markNotificationAsRead(int notificationId) {
        return notificationDAO.markAsRead(notificationId);
    }
    
    public boolean markAllNotificationsAsRead(int userId) {
        return notificationDAO.markAllAsRead(userId);
    }
    
    public boolean deleteNotification(int notificationId) {
        return notificationDAO.deleteNotification(notificationId);
    }
    
    public void createNotification(Notification notification) {
        notificationDAO.createNotification(notification);
    }
}
