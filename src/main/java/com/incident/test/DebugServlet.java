package com.incident.test;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import com.incident.dao.DatabaseConnection;

public class DebugServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        
        String action = request.getParameter("action");
        
        if ("test_login".equals(action)) {
            testLogin(out);
            return;
        }
        
        if ("reset".equals(action)) {
            resetPasswords(out);
            return;
        }

        out.println("=== DEBUG CONSOLE v4 ===");
        
        // 1. Check Database
        checkDatabase(out);
        
        // 2. Check BCrypt
        checkBCrypt(out);
        
        // 3. Navigation
        out.println("\n--- DIAGNOSTIC TOOLS ---");
        out.println("1. [RUN THIS] Test Login Logic (citizen/citizen123):");
        out.println("   " + request.getContextPath() + "/debug?action=test_login");
        out.println("\n2. Reset Passwords (if login fails):");
        out.println("   " + request.getContextPath() + "/debug?action=reset");
        
        // 4. List Users
        listUsers(out);
    }
    
    private void testLogin(PrintWriter out) {
        out.println("=== DEEP DIAGNOSTIC (citizen) ===");
        
        String username = "citizen";
        String plainPassword = "citizen123";
        
        // 1. Generate Local Hash
        String generatedHash = "";
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(plainPassword.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append("0");
                hexString.append(hex);
            }
            generatedHash = hexString.toString();
            out.println("Expected Hash (SHA-256): " + generatedHash);
            out.println("Expected Length: " + generatedHash.length());
        } catch (Exception e) {
            e.printStackTrace(out);
        }
        
        out.println("\n--- DATABASE ROW INSPECTION ---");
        
        // 2. Fetch Raw Row
        String sql = "SELECT * FROM users WHERE username = 'citizen'";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                String dbPass = rs.getString("password");
                boolean isActive = rs.getBoolean("is_active");
                String role = rs.getString("role");
                
                out.println("User Found: YES");
                out.println("Role: " + role);
                out.println("Is Active: " + isActive + " (Raw: " + rs.getString("is_active") + ")");
                
                if (dbPass != null) {
                    out.println("DB Password: " + dbPass);
                    out.println("DB Password Length: " + dbPass.length());
                    
                    if (dbPass.length() != generatedHash.length()) {
                        out.println(">>> FATAL ERROR: LENGTH MISMATCH! expected=64, actual=" + dbPass.length());
                        out.println("This means there are likely hidden spaces in the database.");
                    }
                    
                    if (dbPass.equals(generatedHash)) {
                        out.println(">>> HASH MATCH: YES (Strings are identical)");
                    } else {
                        out.println(">>> HASH MATCH: NO");
                        // Compare chars
                        /*
                        for (int i = 0; i < Math.min(dbPass.length(), generatedHash.length()); i++) {
                            if (dbPass.charAt(i) != generatedHash.charAt(i)) {
                                out.println("First diff at index " + i + ": DB='" + dbPass.charAt(i) + "' vs GEN='" + generatedHash.charAt(i) + "'");
                                break;
                            }
                        }
                        */
                    }
                } else {
                    out.println("DB Password: NULL");
                }
                
            } else {
                out.println("User Found: NO (User 'citizen' does not exist in DB!)");
            }
            
        } catch (Exception e) {
            out.println("DB Query Failed:");
            e.printStackTrace(out);
        }
        
        out.println("\n--- FIX ATTEMPT ---");
        // If length mismatch, fix it automatically
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            // Trim password column just in case
            int rows = stmt.executeUpdate("UPDATE users SET password = TRIM(password) WHERE username = 'citizen'");
             if (rows > 0) out.println("Ran TRIM(password) on user 'citizen'.");
             
             // Ensure active
             stmt.executeUpdate("UPDATE users SET is_active = 1 WHERE username = 'citizen'");
             out.println("Ensured is_active = 1.");
             
             // Reset to known good hash explicitly again to be sure
             stmt.executeUpdate("UPDATE users SET password = '" + generatedHash + "' WHERE username = 'citizen'");
             out.println("Force-updated password to correct hash.");
             
        } catch (Exception e) {
             e.printStackTrace(out);
        }
        
        out.println("\n>>> DONE. PLEASE TRY LOGIN AGAIN NOW. <<<");
    }

    private void resetPasswords(PrintWriter out) {
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // admin123
            stmt.executeUpdate("UPDATE users SET password = '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9' WHERE username = 'admin'");
            // officer123
            stmt.executeUpdate("UPDATE users SET password = '118b8d35a17bcf2c7d2d790509e12308dc6332c5d234f0098d2d6be6700bebb1' WHERE username = 'officer'");
            // citizen123
            stmt.executeUpdate("UPDATE users SET password = '4b4b4c19fdc4b422ca5a52085c3ba8fd2087c62afb06dae791f8fb9c51c56b4b' WHERE username = 'citizen'");
            
            out.println("SUCCESS: Passwords reset to defaults.");
        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }

    private void checkDatabase(PrintWriter out) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            out.println("Database: CONNECTED (" + conn.getMetaData().getDriverName() + ")");
        } catch (Exception e) {
            out.println("Database: FAILED");
            e.printStackTrace(out);
        }
    }

    private void checkBCrypt(PrintWriter out) {
        try {
            Class.forName("org.mindrot.jbcrypt.BCrypt");
            out.println("BCrypt: FOUND");
        } catch (ClassNotFoundException e) {
            out.println("BCrypt: MISSING");
        }
    }

    private void listUsers(PrintWriter out) {
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT username, password FROM users")) {
            
            out.println("\nExisting Users & Hashes:");
            while (rs.next()) {
                String p = rs.getString("password");
                String shortP = (p != null && p.length() > 10) ? p.substring(0, 10) + "..." : p;
                out.println(rs.getString("username") + ": " + shortP);
            }
        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }
}
