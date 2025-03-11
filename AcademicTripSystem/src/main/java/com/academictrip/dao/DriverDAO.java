package com.academictrip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.academictrip.model.Driver;
import com.academictrip.util.DatabaseUtil;

public class DriverDAO {

    // Generate driver_id (e.g., DRI001)
    private String generateDriverId() throws SQLException {
        String prefix = "DRI";
        String sql = "SELECT MAX(driver_id) FROM Driver";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                String maxId = rs.getString(1);
                if (maxId == null) {
					return prefix + "001";
				}
                int numericPart = Integer.parseInt(maxId.replace(prefix, ""));
                return String.format("%s%03d", prefix, numericPart + 1);
            }
            return prefix + "001";
        }
    }

    public void insertDriver(Driver driver) throws SQLException {
        String driverId = generateDriverId();
        driver.setDriverId(driverId);

        String sql = "INSERT INTO Driver (driver_id, firstname, lastname, phone_number, email) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, driver.getDriverId());
            stmt.setString(2, driver.getFirstname());
            stmt.setString(3, driver.getLastname());
            stmt.setString(4, driver.getPhoneNumber());
            stmt.setString(5, driver.getEmail());

            stmt.executeUpdate();
        }
    }

    public Driver getDefaultDriver() throws SQLException {
        String sql = "SELECT * FROM Driver WHERE driver_id = 'DEFAULT'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return new Driver(
                    rs.getString("driver_id"),
                    rs.getString("firstname"),
                    rs.getString("lastname"),
                    rs.getString("phone_number"),
                    rs.getString("email")
                );
            }
            return null;
        }
    }
    public List<Driver> getAllDrivers() throws SQLException {
        List<Driver> drivers = new ArrayList<>();
        String sql = "SELECT * FROM Driver";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                drivers.add(new Driver(
                    rs.getString("driver_id"),
                    rs.getString("firstname"),
                    rs.getString("lastname"),
                    rs.getString("phone_number"),
                    rs.getString("email")
                ));
            }
        }
        return drivers;
    }

    /**
     * Get all drivers who are not currently assigned to any vehicle
     * @return List of available drivers
     * @throws SQLException if a database error occurs
     */
    public List<Driver> getAllAvailableDrivers() throws SQLException {
        List<Driver> availableDrivers = new ArrayList<>();

        String sql = "SELECT d.* FROM Driver d " +
                     "LEFT JOIN Driver_Vehicle dv ON d.driver_id = dv.driver_id " +
                     "AND CURRENT_DATE BETWEEN dv.assignment_start AND dv.assigment_end " +
                     "WHERE dv.driver_id IS NULL";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Driver driver = new Driver(
                    rs.getString("driver_id"),
                    rs.getString("firstname"),
                    rs.getString("lastname"),
                    rs.getString("phone_number"),
                    rs.getString("email")
                );
                availableDrivers.add(driver);
            }
        }

        return availableDrivers;
    }

    /**
     * Get a driver by ID
     * @param id the driver ID
     * @return Driver object or null if not found
     * @throws SQLException if a database error occurs
     */
    public Driver getDriverById(String id) throws SQLException {
        String sql = "SELECT * FROM Driver WHERE driver_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Driver driver = new Driver();
                    driver.setDriverId(rs.getString("driver_id"));
                    driver.setFirstname(rs.getString("firstname"));
                    driver.setLastname(rs.getString("lastname"));
                    driver.setPhoneNumber(rs.getString("phone_number"));
                    driver.setEmail(rs.getString("email"));
                    return driver;
                }
            }
        }
        return null;
    }

    /**
     * Get multiple drivers by their IDs
     * @param driverIds Set of driver IDs to fetch
     * @return Map of driver ID to Driver object
     * @throws SQLException if database error occurs
     */
    public Map<String, Driver> getDriversByIds(Set<String> driverIds) throws SQLException {
        Map<String, Driver> driversMap = new HashMap<>();

        if (driverIds == null || driverIds.isEmpty()) {
            return driversMap;
        }

        // Create SQL with placeholders for each ID
        StringBuilder sql = new StringBuilder("SELECT * FROM driver WHERE driver_id IN (");
        for (int i = 0; i < driverIds.size(); i++) {
            sql.append(i > 0 ? ", ?" : "?");
        }
        sql.append(")");

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Set all the IDs as parameters
            int i = 1;
            for (String id : driverIds) {
                stmt.setString(i++, id);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Driver driver = new Driver();
                    driver.setDriverId(rs.getString("driver_id"));
                    driver.setFirstname(rs.getString("firstname"));
                    driver.setLastname(rs.getString("lastname"));
                    driver.setPhoneNumber(rs.getString("phone_number"));
                    driver.setEmail(rs.getString("email"));
                    driversMap.put(driver.getDriverId(), driver);
                }
            }
        }

        return driversMap;
    }

    /**
     * Check if a driver is currently assigned to a trip
     * @param driverId The ID of the driver to check
     * @return true if driver is assigned, false otherwise
     * @throws SQLException if a database access error occurs
     */
    public boolean isDriverAssigned(String driverId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Driver_Vehicle dv " +
                     "JOIN Trip t ON t.driver_vehicle_id = dv.driver_vehicle_id " +
                     "WHERE dv.driver_id = ? AND " +
                     "CURRENT_DATE BETWEEN dv.assignment_start AND dv.assigment_end";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, driverId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Delete a driver from the database by ID
     * @param driverId The ID of the driver to delete
     * @return boolean indicating success or failure
     * @throws SQLException if a database access error occurs
     */
    public boolean deleteDriver(String driverId) throws SQLException {
        // Check if driver is assigned to any driver-vehicle assignments first
        String checkSql = "SELECT COUNT(*) FROM Driver_Vehicle WHERE driver_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            checkStmt.setString(1, driverId);

            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Driver is still assigned, cannot delete
                    return false;
                }
            }

            // If not assigned, proceed with deletion
            String deleteSql = "DELETE FROM Driver WHERE driver_id = ?";

            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setString(1, driverId);
                int rowsAffected = deleteStmt.executeUpdate();
                return rowsAffected > 0;
            }
        }
    }
}