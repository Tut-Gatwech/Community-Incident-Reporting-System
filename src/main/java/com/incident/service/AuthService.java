package com.incident.service;

import com.incident.dao.UserDAO;
import com.incident.model.User;

public class AuthService {
    private UserDAO userDAO;
    
    public AuthService() {
        this.userDAO = new UserDAO();
    }
    
    public User login(String username, String password) {
        return userDAO.authenticate(username, password);
    }
    
    public boolean register(User user) {
        // Check if username already exists
        if (userDAO.checkUsernameExists(user.getUsername())) {
            return false;
        }
        
        // Check if email already exists
        if (userDAO.checkEmailExists(user.getEmail())) {
            return false;
        }
        
        // Register the user
        return userDAO.registerUser(user);
    }
    
    public boolean isUsernameAvailable(String username) {
        return !userDAO.checkUsernameExists(username);
    }
    
    public boolean isEmailAvailable(String email) {
        return !userDAO.checkEmailExists(email);
    }
}
