package com.warehouse.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Standard JDBC Connection Utility
 * Suited for 2nd Year IP Lab (Internet Programming)
 */
public class DBConnection {
    // Database credentials (adjust according to your local setup, e.g. root/root or root/admin)
    private static final String URL = "jdbc:mysql://localhost:3306/warehouse_db?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "password"; // Replace with your MySQL root password

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // 1. Load the MySQL JDBC Driver class
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 2. Establish connection to warehouse_db
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println(">>> Connected to warehouse_db successfully!");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found. Ensure mysql-connector-j jar is added to your project classpath.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }
}
