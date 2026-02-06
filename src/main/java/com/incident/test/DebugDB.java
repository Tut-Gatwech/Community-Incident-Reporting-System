package com.incident.test;

import com.incident.dao.UserDAO;
import com.incident.model.User;

public class DebugDB {
    public static void main(String[] args) {
        System.out.println("=== DEBUG: Testing Authentication ===");
        UserDAO dao = new UserDAO();
        try {
            // Test connection first
            if (dao.checkUsernameExists("citizen")) {
                System.out.println("User 'citizen' exists.");
            } else {
                System.out.println("User 'citizen' DOES NOT exist.");
            }

            // Test Auth
            User user = dao.authenticate("citizen", "citizen123");
            if (user != null) {
                System.out.println("SUCCESS: Authenticated as " + user.getRole());
            } else {
                System.out.println("FAILURE: Authentication failed.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
