package com.academictrip.dao;

import com.academictrip.model.Vehicle;
import com.academictrip.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {
    
    // Generate vehicle_id (e.g., VEH001)
    private String generateVehicleId() throws SQLException {
        String prefix = "VEH";
        String sql = "SELECT MAX(vehicle_id) FROM Vehicle";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                String maxId = rs.getString(1);
                if (maxId == null) return prefix + "001";
                int numericPart = Integer.parseInt(maxId.replace(prefix, ""));
                return String.format("%s%03d", prefix, numericPart + 1);
            }
            return prefix + "001";
        }
    }

    public void insertVehicle(Vehicle vehicle) throws SQLException {
        String vehicleId = generateVehicleId();
        vehicle.setVehicleId(vehicleId);
        
        String sql = "INSERT INTO Vehicle (vehicle_id, make, model, year, capacity, plate_number) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, vehicle.getVehicleId());
            stmt.setString(2, vehicle.getMake());
            stmt.setString(3, vehicle.getModel());
            stmt.setDate(4, Date.valueOf(vehicle.getYear()));
            stmt.setInt(5, vehicle.getCapacity());
            stmt.setString(6, vehicle.getPlateNumber());
            
            stmt.executeUpdate();
        }
    }

    public Vehicle getDefaultVehicle() throws SQLException {
        String sql = "SELECT * FROM Vehicle WHERE vehicle_id = 'DEFAULT'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return new Vehicle(
                    rs.getString("vehicle_id"),
                    rs.getString("make"),
                    rs.getString("model"),
                    rs.getDate("year").toLocalDate(),
                    rs.getInt("capacity"),
                    rs.getString("plate_number")
                );
            }
            return null;
        }
    }
    public List<Vehicle> getAllVehicles() throws SQLException {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT * FROM Vehicle";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                vehicles.add(new Vehicle(
                    rs.getString("vehicle_id"),
                    rs.getString("make"),
                    rs.getString("model"),
                    rs.getDate("year").toLocalDate(),
                    rs.getInt("capacity"),
                    rs.getString("plate_number")
                ));
            }
        }
        return vehicles;
    }
}