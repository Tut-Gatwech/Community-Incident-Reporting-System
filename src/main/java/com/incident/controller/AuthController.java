package com.incident.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import com.incident.dao.UserDAO;
import com.incident.model.User;

public class AuthController extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        try {
            userDAO = new UserDAO();
            System.out.println("=== AuthController INIT: UserDAO created ===");
        } catch (Exception e) {
            System.err.println("=== AuthController INIT ERROR: " + e.getMessage() + " ===");
            throw new ServletException("Failed to initialize AuthController", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        System.out.println("=== AuthController.doGet() called ===");
        System.out.println("Action: " + action);
        System.out.println("Request URI: " + request.getRequestURI());

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            switch (action) {
                case "/login":
                    showLoginForm(request, response);
                    break;
                case "/logout":
                    logout(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("=== AuthController.doGet() ERROR: " + e.getMessage() + " ===");
            showErrorPage(request, response, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        System.out.println("=== AuthController.doPost() called ===");
        System.out.println("Action: " + action);
        System.out.println("Parameters:");
        request.getParameterMap().forEach((key, values) -> {
            System.out.println("  " + key + " = " + String.join(", ", values));
        });

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            switch (action) {
                case "/login":
                    login(request, response);
                    break;
                case "/register":
                    register(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("=== AuthController.doPost() ERROR: " + e.getMessage() + " ===");
            showErrorPage(request, response, e);
        }
    }

    private void showLoginForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
        dispatcher.forward(request, response);
    }

    private void logDebug(String message) {
        try (java.io.PrintWriter out = new java.io.PrintWriter(new java.io.FileWriter("debug_auth.txt", true))) {
            out.println(new java.util.Date() + ": " + message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        logDebug("Login attempt for user: " + username);

        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Username and password are required");
            return;
        }

        User user = userDAO.authenticate(username, password);
        logDebug("Authentication result for " + username + ": " + (user != null ? "SUCCESS" : "FAILED"));

        if (user != null) {
            logDebug("User role: " + user.getRole());

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole().toUpperCase());
            session.setAttribute("fullName", user.getFullName());

            // Redirect based on role
            String redirectPath = "";
            switch (user.getRole().toUpperCase()) {
                case "ADMIN":
                    redirectPath = "/admin/dashboard.jsp";
                    break;
                case "OFFICER":
                    redirectPath = "/officer/dashboard.jsp";
                    break;
                case "CITIZEN":
                    redirectPath = "/citizen/dashboard.jsp";
                    break;
                default:
                    redirectPath = "/login.jsp?error=Invalid role: " + user.getRole();
            }
            logDebug("Redirecting to: " + redirectPath);
            response.sendRedirect(request.getContextPath() + redirectPath);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid username or password");
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Extract parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        String address = request.getParameter("address");

        System.out.println("=== Attempting registration ===");
        System.out.println("Username: " + username);
        System.out.println("Email: " + email);
        System.out.println("Full Name: " + fullName);
        System.out.println("Role: " + role);
        System.out.println("Phone: " + phone);
        System.out.println("Address: " + address);

        // Validate required fields (role is optional, defaults to CITIZEN)
        java.util.List<String> missing = new java.util.ArrayList<>();
        if (username == null || username.trim().isEmpty())
            missing.add("username");
        if (password == null || password.trim().isEmpty())
            missing.add("password");
        if (email == null || email.trim().isEmpty())
            missing.add("email");
        if (fullName == null || fullName.trim().isEmpty())
            missing.add("fullName");

        if (!missing.isEmpty()) {
            String errorMsg = "Missing required fields: " + String.join(", ", missing);
            System.out.println("Registration Failed: " + errorMsg);
            response.sendRedirect(
                    request.getContextPath() + "/register.jsp?error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
            return;
        }

        // Default role if missing
        if (role == null || role.trim().isEmpty()) {
            System.out.println("Role missing, defaulting to CITIZEN");
            role = "CITIZEN";
        }

        // Create user object
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setFullName(fullName);
        user.setPhone(phone != null ? phone : "");
        user.setRole(role);
        user.setAddress(address != null ? address : "");

        // Check if username or email already exists
        if (userDAO.checkUsernameExists(username)) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=Username already exists");
            return;
        }

        if (userDAO.checkEmailExists(email)) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=Email already exists");
            return;
        }

        // Register user
        boolean success = userDAO.registerUser(user);
        System.out.println("Registration result: " + (success ? "SUCCESS" : "FAILED"));

        if (success) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp?success=Registration successful. Please login.");
        } else {
            response.sendRedirect(
                    request.getContextPath() + "/register.jsp?error=Registration failed. Please try again.");
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/index.jsp?message=Logged out successfully");
    }

    private void showErrorPage(HttpServletRequest request, HttpServletResponse response, Exception e)
            throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h1>Error</h1>");
        out.println("<p>" + e.getMessage() + "</p>");
        out.println("<p>Check Tomcat logs for details.</p>");
        out.println("<a href='" + request.getContextPath() + "/login.jsp'>Back to Login</a>");
        out.println("</body></html>");
    }
}
