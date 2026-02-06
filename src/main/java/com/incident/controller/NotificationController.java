package com.incident.controller;

import com.incident.model.Notification;
import com.incident.model.User;
import com.incident.service.NotificationService;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class NotificationController extends HttpServlet {
    private NotificationService notificationService;

    @Override
    public void init() {
        notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getPathInfo();

        if (action == null || "/list".equals(action)) {
            handleListNotifications(request, response, user);
        } else if ("/mark-read".equals(action)) {
            handleMarkAsRead(request, response, user);
        } else if ("/mark-all-read".equals(action)) {
            handleMarkAllRead(request, response, user);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleListNotifications(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Notification> notifications = notificationService.getUserNotifications(user.getUserId());
        request.setAttribute("notifications", notifications);
        request.getRequestDispatcher("/notifications/list.jsp").forward(request, response);
    }

    private void handleMarkAsRead(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            int notificationId = Integer.parseInt(request.getParameter("id"));
            notificationService.markNotificationAsRead(notificationId);

            String redirectUrl = request.getParameter("redirect");
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                response.sendRedirect(request.getContextPath() + redirectUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/notifications/list");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/notifications/list");
        }
    }

    private void handleMarkAllRead(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        notificationService.markAllNotificationsAsRead(user.getUserId());
        response.sendRedirect(request.getContextPath() + "/notifications/list");
    }
}
