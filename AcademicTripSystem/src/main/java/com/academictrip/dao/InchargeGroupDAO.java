package com.academictrip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.academictrip.model.InchargeGroup;
import com.academictrip.util.DatabaseUtil;

public class InchargeGroupDAO {

    // Generate incharge_group_id (e.g., ING001)
    private String generateInchargeGroupId() throws SQLException {
        String prefix = "ING";
        String sql = "SELECT MAX(incharge_group_id) AS max_id FROM Incharge_Group";
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

    // Insert a new incharge group
    public void insertInchargeGroup(InchargeGroup group) throws SQLException {
        String inchargeGroupId = generateInchargeGroupId();
        group.setInchargeGroupId(inchargeGroupId);
        String sql = "INSERT INTO Incharge_Group (incharge_group_id, incharge_id, group_id) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, group.getInchargeGroupId());
            stmt.setString(2, group.getInchargeId());
            stmt.setString(3, group.getGroupId());
            stmt.executeUpdate();
        }
    }

    // Find incharge group by incharge_id (optional)
    public InchargeGroup findInchargeGroupByInchargeId(String inchargeId) throws SQLException {
        String sql = "SELECT * FROM Incharge_Group WHERE incharge_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, inchargeId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new InchargeGroup(
                        rs.getString("incharge_group_id"),
                        rs.getString("incharge_id"),
                        rs.getString("group_id")
                    );
                }
                return null;
            }
        }
    }

    // Retrieve InchargeGroup by ID
    public InchargeGroup getInchargeGroupById(String inchargeGroupId) throws SQLException {
        String sql = "SELECT * FROM Incharge_Group WHERE incharge_group_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, inchargeGroupId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    InchargeGroup inchargeGroup = new InchargeGroup();
                    inchargeGroup.setInchargeGroupId(rs.getString("incharge_group_id"));
                    inchargeGroup.setInchargeId(rs.getString("incharge_id"));
                    inchargeGroup.setGroupId(rs.getString("group_id"));
                    return inchargeGroup;
                }
            }
        }
        return null;
    }
}