package com.academictrip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

    /**
     * Retrieve a destination by its ID
     * @param destinationId The ID of the destination
     * @return The destination object or null if not found
     * @throws SQLException if a database access error occurs
     */
    public Destination getDestinationById(String destinationId) throws SQLException {
        String sql = "SELECT * FROM Destination WHERE destination_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, destinationId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Destination destination = new Destination();
                    destination.setDestinationId(rs.getString("destination_id"));
                    destination.setName(rs.getString("name"));

                    // Handle optional fields that may not exist in the database schema
                    try {
                        destination.setLocation(rs.getString("location"));
                    } catch (SQLException e) {
                        // Column doesn't exist, set a default or leave as null
                        destination.setLocation("Unknown");
                    }

                    try {
                        destination.setDistance(rs.getInt("distance"));
                    } catch (SQLException e) {
                        // Column doesn't exist, set a default value
                        destination.setDistance(0);
                    }

                    return destination;
                }
            }
        }

        return null;
    }

    /**
     * Get all destinations
     * @return List of all destinations
     * @throws SQLException if a database error occurs
     */
    public List<Destination> getAllDestinations() throws SQLException {
        List<Destination> destinations = new ArrayList<>();
        String sql = "SELECT * FROM Destination ORDER BY name";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Destination destination = new Destination(
                    rs.getString("destination_id"),
                    rs.getString("name")
                );

                // Handle optional fields that may not exist in the database schema
                try {
                    destination.setLocation(rs.getString("location"));
                } catch (SQLException e) {
                    destination.setLocation("Unknown");
                }

                try {
                    destination.setDistance(rs.getInt("distance"));
                } catch (SQLException e) {
                    destination.setDistance(0);
                }

                destinations.add(destination);
            }
        }

        return destinations;
    }

    /**
     * Insert a new destination
     * @param destination the destination to insert
     * @throws SQLException if a database error occurs
     */
        /**
     * Update an existing destination
     * @param destination the destination with updated values
     * @return true if update successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updateDestination(Destination destination) throws SQLException {
        String sql = "UPDATE Destination SET name = ? WHERE destination_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, destination.getName());
            stmt.setString(2, destination.getDestinationId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Delete a destination by ID
     * @param id the ID of the destination to delete
     * @return true if deletion successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean deleteDestination(String id) throws SQLException {
        // First check if any trips use this destination
        String checkSql = "SELECT COUNT(*) FROM Trip WHERE destination_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            checkStmt.setString(1, id);

            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Destination is in use, cannot delete
                    return false;
                }
            }

            // If not in use, proceed with deletion
            String deleteSql = "DELETE FROM Destination WHERE destination_id = ?";

            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setString(1, id);
                int rowsAffected = deleteStmt.executeUpdate();
                return rowsAffected > 0;
            }
        }
    }
}