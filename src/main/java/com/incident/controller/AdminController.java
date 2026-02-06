package com.incident.controller;

import com.incident.dao.UserDAO;
import com.incident.model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AdminController extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        System.out.println("=== AdminController INIT: UserDAO created ===");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        System.out.println("=== AdminController doGet pathInfo: " + pathInfo + " ===");

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
            handleListUsers(request, response);
        } else if (pathInfo.equals("/delete")) {
            handleDeleteUser(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getPathInfo();
        if ("/create".equals(action)) {
            handleCreateUser(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            return user != null && "ADMIN".equals(user.getRole().toUpperCase());
        }
        return false;
    }

    private void handleListUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/manage-users.jsp").forward(request, response);
    }

    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setFullName(fullName);
        user.setRole(role);
        user.setPhone(phone);
        user.setAddress(address);

        boolean success = userDAO.registerUser(user);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin-user/list?success=Officer created successfully");
        } else {
            request.setAttribute("error", "Failed to create officer");
            handleListUsers(request, response);
        }
    }

    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            userDAO.deleteUser(userId);
            response.sendRedirect(request.getContextPath() + "/admin-user/list?success=User deactivated");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin-user/list?error=Invalid user ID");
        }
    }
}
