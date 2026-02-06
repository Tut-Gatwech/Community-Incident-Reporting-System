import java.sql.*;

public class TestMySQL {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/incident_reporting_system?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        String user = "root";
        String password = "root";
        
        System.out.println("=== TESTING MYSQL CONNECTION ===");
        System.out.println("URL: " + url);
        
        try {
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("✓ MySQL connection SUCCESSFUL!");
            
            // Check if database exists
            DatabaseMetaData meta = conn.getMetaData();
            ResultSet tables = meta.getTables(null, null, "users", null);
            if (tables.next()) {
                System.out.println("✓ 'users' table exists");
            } else {
                System.out.println("✗ 'users' table does NOT exist");
            }
            
            conn.close();
        } catch (SQLException e) {
            System.out.println("✗ MySQL connection FAILED: " + e.getMessage());
            System.out.println("Error code: " + e.getErrorCode());
            System.out.println("SQL state: " + e.getSQLState());
            
            if (e.getMessage().contains("Unknown database")) {
                System.out.println("\n=== SOLUTION ===");
                System.out.println("Database 'incident_reporting_system' doesn't exist.");
                System.out.println("Create it with: CREATE DATABASE incident_reporting_system;");
            } else if (e.getMessage().contains("Access denied")) {
                System.out.println("\n=== SOLUTION ===");
                System.out.println("Wrong username/password. Try empty password or check MySQL credentials.");
            } else if (e.getMessage().contains("Communications link failure")) {
                System.out.println("\n=== SOLUTION ===");
                System.out.println("MySQL is not running. Start MySQL service.");
            }
        }
    }
}
