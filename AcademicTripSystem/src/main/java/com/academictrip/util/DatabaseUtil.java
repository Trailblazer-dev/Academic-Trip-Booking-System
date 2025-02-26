package com.academictrip.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/Academic_Trip_Database";
    private static final String USER = "jsp";
    private static final String PASSWORD = "jsp1";

    static {
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
    	 System.out.println("Attempting connection to: " + URL);
    	    Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
    	    System.out.println("Connection successful! Schema: " + conn.getSchema());
    	    return conn;
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}