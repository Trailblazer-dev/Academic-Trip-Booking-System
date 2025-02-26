package com.academictrip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.academictrip.model.Incharge;
import com.academictrip.util.DatabaseUtil;

public class InchargeDAO {
    // Generate incharge_id (e.g., INC001)
    private String generateInchargeId() throws SQLException {
        String prefix = "INC";
        String sql = "SELECT MAX(incharge_id) AS max_id FROM Incharge";
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

    public void insertIncharge(Incharge incharge) throws SQLException {
        String inchargeId = generateInchargeId();
        incharge.setInchargeId(inchargeId);
        String sql = "INSERT INTO Incharge (incharge_id, first_name, last_name, phone_number, email, faculty_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, incharge.getInchargeId());
            stmt.setString(2, incharge.getFirstName());
            stmt.setString(3, incharge.getLastName());
            stmt.setInt(4, incharge.getPhoneNumber());
            stmt.setString(5, incharge.getEmail());
            stmt.setString(6, incharge.getFacultyId());
            stmt.executeUpdate();
        }
    }

    public Incharge findInchargeByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM Incharge WHERE email = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Incharge(
                        rs.getString("incharge_id"),
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getInt("phone_number"),
                        rs.getString("email"),
                        rs.getString("faculty_id")
                    );
                }
                return null;
            }
        }
    }
}