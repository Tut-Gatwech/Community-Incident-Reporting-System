package com.incident.dao;

import com.incident.model.User;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;
import java.security.MessageDigest;
import java.util.List;
import java.util.ArrayList;

public class UserDAO {

    public User authenticate(String username, String password) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username = ? AND is_active = TRUE";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            System.out.println("=== UserDAO: Authenticating " + username + " ===");
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                String dbRole = rs.getString("role");
                System.out.println("=== User Found: " + username + " | Role: " + dbRole + " ===");

                if (hashedPassword != null) {
                    System.out.println("=== DB Hash Length: " + hashedPassword.length() + " ===");
                    System.out.println("=== DB Hash Snippet: "
                            + (hashedPassword.length() > 10 ? hashedPassword.substring(0, 10) : hashedPassword)
                            + "... ===");

                    boolean match = false;
                    if (hashedPassword.length() == 64) {
                        // SHA-256 hash
                        String inputHash = hashSHA256(password);
                        System.out
                                .println("=== Checking SHA-256. Input Hash: " + inputHash.substring(0, 10) + "... ===");
                        if (inputHash.equals(hashedPassword)) {
                            System.out.println("=== MATCH: SHA-256 ===");
                            match = true;
                        } else {
                            System.out.println("=== MISMATCH: SHA-256 ===");
                        }
                    } else if (hashedPassword.startsWith("$2a$")) {
                        // BCrypt hash
                        System.out.println("=== Checking BCrypt ===");
                        if (BCrypt.checkpw(password, hashedPassword)) {
                            System.out.println("=== MATCH: BCrypt ===");
                            match = true;
                        } else {
                            System.out.println("=== MISMATCH: BCrypt ===");
                        }
                    } else {
                        System.out.println("=== UNKNOWN HASH FORMAT ===");
                        // Attempt fallback BCrypt check just in case
                        if (BCrypt.checkpw(password, hashedPassword)) {
                            match = true;
                        }
                    }

                    if (match) {
                        user = extractUserFromResultSet(rs);
                    }
                } else {
                    System.out.println("=== ERROR: Password in DB is NULL ===");
                }
            } else {
                System.out.println("=== UserDAO: No user found with username: " + username + " ===");
            }
        } catch (SQLException e) {
            System.err.println("=== UserDAO SQL ERROR: " + e.getMessage() + " ===");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("=== UserDAO ERROR: " + e.getMessage() + " ===");
        }
        return user;
    }

    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setFullName(rs.getString("full_name"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));
        return user;
    }

    private String hashSHA256(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1)
                hexString.append("0");
            hexString.append(hex);
        }
        return hexString.toString();
    }

    public List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? AND is_active = TRUE";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, role);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("getUsersByRole ERROR: " + e.getMessage());
        }
        return users;
    }

    public boolean checkUsernameExists(String username) {
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(
                        "SELECT COUNT(*) FROM users WHERE username = ?")) {
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException e) {
            System.err.println("checkUsernameExists ERROR: " + e.getMessage());
            return false;
        }
    }

    public boolean checkEmailExists(String email) {
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(
                        "SELECT COUNT(*) FROM users WHERE email = ?")) {
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException e) {
            System.err.println("checkEmailExists ERROR: " + e.getMessage());
            return false;
        }
    }

    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (username, password, email, full_name, phone, address, role) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getUsername());

            // Hash password with BCrypt
            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            pstmt.setString(2, hashedPassword);

            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getFullName());
            pstmt.setString(5, user.getPhone());
            pstmt.setString(6, user.getAddress());
            pstmt.setString(7, user.getRole());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("registerUser ERROR: " + e.getMessage());
            return false;
        }
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("getAllUsers ERROR: " + e.getMessage());
        }
        return users;
    }

    public boolean deleteUser(int userId) {
        String sql = "UPDATE users SET is_active = FALSE WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("deleteUser ERROR: " + e.getMessage());
            return false;
        }
    }
}