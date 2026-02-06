package com.incident.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.io.InputStream;

public class DatabaseConnection {
    public static Connection getConnection() throws SQLException {
        try {
            Properties props = new Properties();
            InputStream input = DatabaseConnection.class.getClassLoader()
                .getResourceAsStream("database.properties");
            if (input != null) {
                props.load(input);
            }
            
            String url = props.getProperty("db.url", "jdbc:mysql://localhost:3306/incident_reporting_system?useSSL=false&serverTimezone=UTC");
            String user = props.getProperty("db.username", "root");
            String password = props.getProperty("db.password", "root");
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            throw new SQLException("Failed to connect: " + e.getMessage(), e);
        }
    }
}