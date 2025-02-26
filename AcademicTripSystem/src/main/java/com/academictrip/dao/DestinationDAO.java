package com.academictrip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.academictrip.model.Destination;
import com.academictrip.util.DatabaseUtil;

public class DestinationDAO {
    // Generate destination_id (e.g., DES001)
    private String generateDestinationId() throws SQLException {
        String prefix = "DES";
        String sql = "SELECT MAX(destination_id) AS max_id FROM Destination";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                String maxId = rs.getString("max_id");
                if (maxId == null) {
					return prefix + "001";
				}
                int numericPart = Integer.parseInt(maxId.replace(prefix, ""));
                return String.format("%s%03d", prefix, numericPart + 1);
            }
            return prefix + "001";
        }
    }

    public void insertDestination(Destination destination) throws SQLException {
        String destinationId = generateDestinationId();
        destination.setDestinationId(destinationId);
        String sql = "INSERT INTO Destination (destination_id, name) VALUES (?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, destination.getDestinationId());
            stmt.setString(2, destination.getName());
            stmt.executeUpdate();
        }
    }

    public Destination findDestinationByName(String name) throws SQLException {
        String sql = "SELECT * FROM Destination WHERE name = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Destination(
                        rs.getString("destination_id"),
                        rs.getString("name")
                    );
                }
                return null;
            }
        }
    }
}