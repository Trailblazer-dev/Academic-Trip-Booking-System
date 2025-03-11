package com.academictrip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.academictrip.model.Incharge;
import com.academictrip.util.DatabaseUtil;

public class InchargeDAO {

    // Get incharge by ID
    public Incharge getInchargeById(String inchargeId) {
        String sql = "SELECT * FROM Incharge WHERE incharge_id = ?";
        Incharge incharge = null;

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, inchargeId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    incharge = new Incharge();
                    incharge.setInchargeId(rs.getString("incharge_id"));
                    incharge.setFirstName(rs.getString("first_name"));
                    incharge.setLastName(rs.getString("last_name"));
                    incharge.setPhoneNumber(rs.getInt("phone_number"));
                    incharge.setEmail(rs.getString("email"));
                    incharge.setFacultyId(rs.getString("faculty_id"));

                    // Set the full name for convenience
                    incharge.setName(incharge.getFirstName() + " " + incharge.getLastName());
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving incharge: " + e.getMessage());
            e.printStackTrace();
        }

        return incharge;
    }

    // Get all incharges
    public List<Incharge> getAllIncharges() {
        String sql = "SELECT * FROM Incharge ORDER BY last_name, first_name";
        List<Incharge> incharges = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Incharge incharge = new Incharge();
                incharge.setInchargeId(rs.getString("incharge_id"));
                incharge.setFirstName(rs.getString("first_name"));
                incharge.setLastName(rs.getString("last_name"));
                incharge.setPhoneNumber(rs.getInt("phone_number"));
                incharge.setEmail(rs.getString("email"));
                incharge.setFacultyId(rs.getString("faculty_id"));

                // Set the full name for convenience
                incharge.setName(incharge.getFirstName() + " " + incharge.getLastName());

                incharges.add(incharge);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving all incharges: " + e.getMessage());
            e.printStackTrace();
        }

        return incharges;
    }

    // Add new incharge
    public boolean addIncharge(Incharge incharge) {
        String sql = "INSERT INTO Incharge (incharge_id, first_name, last_name, phone_number, email, faculty_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, incharge.getInchargeId());
            stmt.setString(2, incharge.getFirstName());
            stmt.setString(3, incharge.getLastName());
            stmt.setInt(4, incharge.getPhoneNumber());
            stmt.setString(5, incharge.getEmail());
            stmt.setString(6, incharge.getFacultyId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error adding incharge: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Update incharge
    public boolean updateIncharge(Incharge incharge) {
        String sql = "UPDATE Incharge SET first_name = ?, last_name = ?, phone_number = ?, " +
                     "email = ?, faculty_id = ? WHERE incharge_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, incharge.getFirstName());
            stmt.setString(2, incharge.getLastName());
            stmt.setInt(3, incharge.getPhoneNumber());
            stmt.setString(4, incharge.getEmail());
            stmt.setString(5, incharge.getFacultyId());
            stmt.setString(6, incharge.getInchargeId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating incharge: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Delete incharge
    public boolean deleteIncharge(String inchargeId) {
        String sql = "DELETE FROM Incharge WHERE incharge_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, inchargeId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting incharge: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Find an incharge by their email address
     * @param email Email address to search for
     * @return Incharge object if found, null otherwise
     * @throws SQLException if database error occurs
     */
    public Incharge findInchargeByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM Incharge WHERE email = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Incharge incharge = new Incharge();
                    incharge.setInchargeId(rs.getString("incharge_id"));
                    incharge.setFirstName(rs.getString("first_name"));
                    incharge.setLastName(rs.getString("last_name"));
                    incharge.setPhoneNumber(rs.getInt("phone_number"));
                    incharge.setEmail(rs.getString("email"));
                    incharge.setFacultyId(rs.getString("faculty_id"));
                    return incharge;
                }
            }
        }
        return null;
    }

    /**
     * Insert a new incharge into the database
     * @param incharge Incharge object to insert
     * @return true if successful, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean insertIncharge(Incharge incharge) throws SQLException {
        String sql = "INSERT INTO Incharge (incharge_id, first_name, last_name, phone_number, email, faculty_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, incharge.getInchargeId());
            stmt.setString(2, incharge.getFirstName());
            stmt.setString(3, incharge.getLastName());
            stmt.setInt(4, incharge.getPhoneNumber());
            stmt.setString(5, incharge.getEmail());
            stmt.setString(6, incharge.getFacultyId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
}