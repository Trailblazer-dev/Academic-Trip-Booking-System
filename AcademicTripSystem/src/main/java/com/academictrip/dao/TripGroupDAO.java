package com.academictrip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.academictrip.model.TripGroup;
import com.academictrip.util.DatabaseUtil;

public class TripGroupDAO {

    // Generate group_id (e.g., GRP001)
    private String generateGroupId() throws SQLException {
        String prefix = "GRP";
        String sql = "SELECT MAX(group_id) AS max_id FROM Trip_Group";
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

    public void insertTripGroup(TripGroup tripGroup) throws SQLException {
        String groupId = generateGroupId();
        tripGroup.setGroupId(groupId);
        String sql = "INSERT INTO Trip_Group (group_id, group_name, student_number, course_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, tripGroup.getGroupId());
            stmt.setString(2, tripGroup.getGroupName());
            stmt.setInt(3, tripGroup.getStudentNumber());
            stmt.setString(4, tripGroup.getCourseId());
            stmt.executeUpdate();
        }
    }

    public TripGroup findGroupByName(String groupName) throws SQLException {
        String sql = "SELECT * FROM Trip_Group WHERE group_name = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, groupName);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new TripGroup(
                        rs.getString("group_id"),
                        rs.getString("group_name"),
                        rs.getInt("student_number"),
                        rs.getString("course_id")
                    );
                }
                return null;
            }
        }
    }

    public TripGroup getTripGroupById(String groupId) throws SQLException {
        String sql = "SELECT * FROM Trip_Group WHERE group_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, groupId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    TripGroup group = new TripGroup();
                    group.setGroupId(rs.getString("group_id"));
                    group.setGroupName(rs.getString("group_name"));
                    group.setStudentNumber(rs.getInt("student_number"));
                    group.setCourseId(rs.getString("course_id"));
                    return group;
                }
            }
        }
        return null;
    }

    /**
     * Retrieve a trip group by its ID
     * @param groupId The ID of the trip group
     * @return The trip group object or null if not found
     * @throws SQLException if a database access error occurs
     */
    public TripGroup getGroupById(String groupId) throws SQLException {
        String sql = "SELECT * FROM Trip_Group WHERE group_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, groupId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    TripGroup group = new TripGroup();
                    group.setGroupId(rs.getString("group_id"));
                    group.setGroupName(rs.getString("group_name"));
                    group.setStudentNumber(rs.getInt("student_number"));
                    group.setCourseId(rs.getString("course_id"));
                    return group;
                }
            }
        }
        return null;
    }
}