package com.incident.test;

import com.incident.util.DatabaseConnection;
import java.sql.Connection;

public class TestDBConnection {
    public static void main(String[] args) {
        try {
            Connection conn = DatabaseConnection.getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("SUCCESS: Database connection working!");
                conn.close();
            } else {
                System.out.println("ERROR: Database connection failed!");
            }
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
        }
    }
}
