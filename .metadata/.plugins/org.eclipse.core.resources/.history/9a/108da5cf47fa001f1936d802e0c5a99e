package com.academictrip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
            stmt.setInt(4, driver.getPhoneNumber());
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
                    rs.getInt("phone_number"),
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
                    rs.getInt("phone_number"),
                    rs.getString("email")
                ));
            }
        }
        return drivers;
    }
}