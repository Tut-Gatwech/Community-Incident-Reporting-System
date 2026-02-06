package com.incident.model;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String username;
    private String password;
    private String email;
    private String fullName;
    private String role;
    private String phone;
    private String address;  // Added address field
    private Timestamp createdAt;
    private boolean isActive;

    public User() {}

    public User(int userId, String username, String password, String email,
                String fullName, String role, String phone, String address,
                Timestamp createdAt, boolean isActive) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.role = role;
        this.phone = phone;
        this.address = address;
        this.createdAt = createdAt;
        this.isActive = isActive;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }
}