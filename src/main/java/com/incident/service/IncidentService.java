package com.incident.service;

import com.incident.dao.IncidentDAO;
import com.incident.dao.IncidentUpdateDAO;
import com.incident.dao.NotificationDAO;
import com.incident.dao.UserDAO;
import com.incident.dao.AttachmentDAO;
import com.incident.model.Attachment;
import com.incident.model.Incident;
import com.incident.model.IncidentUpdate;
import com.incident.model.User;
import java.util.List;

public class IncidentService {
    private IncidentDAO incidentDAO;
    private NotificationDAO notificationDAO;
    private UserDAO userDAO;
    private IncidentUpdateDAO incidentUpdateDAO;
    private AttachmentDAO attachmentDAO;

    public IncidentService() {
        this.incidentDAO = new IncidentDAO();
        this.notificationDAO = new NotificationDAO();
        this.userDAO = new UserDAO();
        this.incidentUpdateDAO = new IncidentUpdateDAO();
        this.attachmentDAO = new AttachmentDAO();
    }

    public int reportIncident(Incident incident) {
        int incidentId = incidentDAO.createIncident(incident);

        // Notify officers about new incident
        if (incidentId > 0) {
            notificationDAO.notifyOfficersForNewIncident(incidentId, incident.getTitle());
        }

        return incidentId;
    }

    public List<Incident> getAllIncidents() {
        return incidentDAO.getAllIncidents();
    }

    public List<Incident> getUserIncidents(int userId) {
        return incidentDAO.getIncidentsByUser(userId);
    }

    public List<Incident> getOfficerIncidents(int officerId) {
        return incidentDAO.getIncidentsByOfficer(officerId);
    }

    public Incident getIncidentById(int incidentId) {
        return incidentDAO.getIncidentById(incidentId);
    }

    public List<User> getOfficers() {
        return userDAO.getUsersByRole("OFFICER");
    }

    public List<IncidentUpdate> getUpdatesByIncident(int incidentId) {
        return incidentUpdateDAO.getUpdatesByIncident(incidentId);
    }

    public void addIncidentUpdate(IncidentUpdate update) {
        incidentUpdateDAO.createUpdate(update);
    }

    public List<Attachment> getAttachmentsByIncident(int incidentId) {
        return attachmentDAO.getAttachmentsByIncident(incidentId);
    }

    public boolean addAttachment(Attachment attachment) {
        return attachmentDAO.createAttachment(attachment);
    }

    public boolean archiveIncident(int incidentId) {
        Incident incident = incidentDAO.getIncidentById(incidentId);
        if (incident != null) {
            incident.setStatus("CLOSED");
            return incidentDAO.updateIncident(incident);
        }
        return false;
    }

    public boolean updateIncident(Incident incident) {
        boolean updated = incidentDAO.updateIncident(incident);

        // Notify assigned officer if assignment changed
        if (updated && incident.getAssignedTo() != null) {
            notificationDAO.notifyIncidentUpdate(
                    incident.getIncidentId(),
                    incident.getTitle(),
                    incident.getAssignedTo());
        }

        return updated;
    }

    public boolean deleteIncident(int incidentId) {
        return incidentDAO.deleteIncident(incidentId);
    }

    public List<Incident> searchIncidents(String keyword, String category, String status, String severity) {
        return incidentDAO.searchIncidents(keyword, category, status, severity);
    }

    public List<Incident> getIncidentsByStatus(String status) {
        return incidentDAO.getIncidentsByStatus(status);
    }

    public int getTotalIncidents() {
        return incidentDAO.getIncidentCount();
    }

    public int getIncidentsCountByStatus(String status) {
        return incidentDAO.getIncidentCountByStatus(status);
    }
}
