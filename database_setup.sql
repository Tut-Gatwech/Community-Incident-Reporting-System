-- ============================================
-- Community Incident Reporting System
-- Database Setup Script
-- ============================================

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS incident_reporting_system;
USE incident_reporting_system;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('CITIZEN', 'OFFICER', 'ADMIN') DEFAULT 'CITIZEN',
    phone VARCHAR(20),
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    is_active BOOLEAN DEFAULT TRUE
);

-- Incidents table
CREATE TABLE IF NOT EXISTS incidents (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category ENUM('THEFT', 'ACCIDENT', 'FIRE', 'VANDALISM', 'NOISE_COMPLAINT', 'PUBLIC_SAFETY', 'OTHER') NOT NULL,
    location VARCHAR(255) NOT NULL,
    severity ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') DEFAULT 'MEDIUM',
    status ENUM('PENDING', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') DEFAULT 'PENDING',
    reported_by INT NOT NULL,
    assigned_to INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_date TIMESTAMP NULL,
    FOREIGN KEY (reported_by) REFERENCES users(user_id),
    FOREIGN KEY (assigned_to) REFERENCES users(user_id)
);

-- Incident updates table
CREATE TABLE IF NOT EXISTS incident_updates (
    update_id INT PRIMARY KEY AUTO_INCREMENT,
    incident_id INT NOT NULL,
    update_text TEXT NOT NULL,
    updated_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (incident_id) REFERENCES incidents(incident_id),
    FOREIGN KEY (updated_by) REFERENCES users(user_id)
);

-- Incident attachments table
CREATE TABLE IF NOT EXISTS incident_attachments (
    attachment_id INT PRIMARY KEY AUTO_INCREMENT,
    incident_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_type VARCHAR(50),
    uploaded_by INT NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (incident_id) REFERENCES incidents(incident_id),
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    type ENUM('NEW_INCIDENT', 'ASSIGNMENT', 'UPDATE', 'RESOLVED') NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    related_incident_id INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (related_incident_id) REFERENCES incidents(incident_id)
);

-- ============================================
-- Insert Default Data
-- ============================================

-- Insert admin user (password: admin123)
INSERT INTO users (username, password, email, full_name, role) VALUES
('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'admin@incident.com', 'System Administrator', 'ADMIN')
ON DUPLICATE KEY UPDATE username = username;

-- Insert officer (password: officer123)
INSERT INTO users (username, password, email, full_name, role) VALUES
('officer', '118b8d35a17bcf2c7d2d790509e12308dc6332c5d234f0098d2d6be6700bebb1', 'officer@incident.com', 'Police Officer', 'OFFICER')
ON DUPLICATE KEY UPDATE username = username;

-- Insert citizen (password: citizen123)
INSERT INTO users (username, password, email, full_name, role) VALUES
('citizen', '4b4b4c19fdc4b422ca5a52085c3ba8fd2087c62afb06dae791f8fb9c51c56b4b', 'citizen@incident.com', 'John Citizen', 'CITIZEN')
ON DUPLICATE KEY UPDATE username = username;

-- ============================================
-- Verification Queries
-- ============================================

SELECT '✅ Database Setup Complete!' as message;
SELECT ' ' as space;
SELECT 'Database: incident_reporting_system' as info;
SELECT 'Tables created: 5 tables' as info;
SELECT ' ' as space;
SELECT '👥 Default Users Created:' as users;
SELECT username, role, email FROM users;
SELECT ' ' as space;
SELECT '🔐 Login Credentials:' as credentials;
SELECT 'Admin: admin / admin123' as admin_login;
SELECT 'Officer: officer / officer123' as officer_login;
SELECT 'Citizen: citizen / citizen123' as citizen_login;
SELECT ' ' as space;
SELECT '📊 All tables are ready for data storage!' as final_message;
