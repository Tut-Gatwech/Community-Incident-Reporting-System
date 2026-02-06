package com.incident.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {
    private static Connection connection = null;
    private static Properties properties = new Properties();
    
    static {
        try {
            // Load database properties
            InputStream input = DatabaseConnection.class.getClassLoader()
                    .getResourceAsStream("database.properties");
            if (input != null) {
                properties.load(input);
            } else {
                // Set default properties if file not found
                properties.setProperty("db.driver", "com.mysql.cj.jdbc.Driver");
                properties.setProperty("db.url", "jdbc:mysql://localhost:3306/incident_reporting_system");
                properties.setProperty("db.username", "root");
                properties.setProperty("db.password", "root");
            }
            
            // Load MySQL driver
            Class.forName(properties.getProperty("db.driver"));
        } catch (ClassNotFoundException | IOException e) {
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            String url = properties.getProperty("db.url");
            String username = properties.getProperty("db.username");
            String password = properties.getProperty("db.password");
            
            connection = DriverManager.getConnection(url, username, password);
        }
        return connection;
    }
    
    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public static String getProperty(String key) {
        return properties.getProperty(key);
    }
}
