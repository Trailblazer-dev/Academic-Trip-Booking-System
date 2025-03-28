package com.academictrip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.academictrip.model.Course;
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
                    return mapTripGroupFromResultSet(rs);
                }
                return null;
            }
        }
    }

    public TripGroup getTripGroupById(String groupId) throws SQLException {
        String sql = "SELECT tg.*, c.course_name " +
                     "FROM Trip_Group tg " +
                     "LEFT JOIN Course c ON tg.course_id = c.course_id " +
                     "WHERE tg.group_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, groupId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    TripGroup group = mapTripGroupFromResultSet(rs);

                    // Add course name if available
                    if (rs.getString("course_name") != null) {
                        Course course = new Course();
                        course.setCourseId(rs.getString("course_id"));
                        course.setCourseName(rs.getString("course_name"));
                        group.setCourse(course);
                    }

                    return group;
                }
            }
        }
        return null;
    }

    // Helper method to map ResultSet to TripGroup object based on the actual schema
    private TripGroup mapTripGroupFromResultSet(ResultSet rs) throws SQLException {
        TripGroup group = new TripGroup();
        group.setGroupId(rs.getString("group_id"));
        group.setGroupName(rs.getString("group_name"));
        group.setStudentNumber(rs.getInt("student_number"));
        group.setCourseId(rs.getString("course_id"));
        return group;
    }

    // Get trip group by trip ID - this uses a relationship in your new schema
    public TripGroup getTripGroupByTripId(String tripId) throws SQLException {
        String sql = "SELECT tg.*, c.course_name " +
                     "FROM Trip_Group tg " +
                     "JOIN Incharge_Group ig ON tg.group_id = ig.group_id " +
                     "JOIN Trip t ON t.incharge_group_id = ig.incharge_group_id " +
                     "LEFT JOIN Course c ON tg.course_id = c.course_id " +
                     "WHERE t.trip_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, tripId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    TripGroup group = mapTripGroupFromResultSet(rs);

                    // Add course name if available
                    if (rs.getString("course_name") != null) {
                        Course course = new Course();
                        course.setCourseId(rs.getString("course_id"));
                        course.setCourseName(rs.getString("course_name"));
                        group.setCourse(course);
                    }

                    return group;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving trip group by trip ID: " + e.getMessage());
            throw e;
        }
        return null;
    }

    // Get all trip groups
    public List<TripGroup> getAllTripGroups() throws SQLException {
        String sql = "SELECT tg.*, c.course_name " +
                     "FROM Trip_Group tg " +
                     "LEFT JOIN Course c ON tg.course_id = c.course_id " +
                     "ORDER BY tg.group_name";
        List<TripGroup> tripGroups = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                TripGroup group = mapTripGroupFromResultSet(rs);

                // Add course name if available
                if (rs.getString("course_name") != null) {
                    Course course = new Course();
                    course.setCourseId(rs.getString("course_id"));
                    course.setCourseName(rs.getString("course_name"));
                    group.setCourse(course);
                }

                tripGroups.add(group);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving all trip groups: " + e.getMessage());
            throw e;
        }

        return tripGroups;
    }

    // Update trip group
    public boolean updateTripGroup(TripGroup tripGroup) throws SQLException {
        String sql = "UPDATE Trip_Group SET group_name = ?, student_number = ?, course_id = ? WHERE group_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, tripGroup.getGroupName());
            stmt.setInt(2, tripGroup.getStudentNumber());
            stmt.setString(3, tripGroup.getCourseId());
            stmt.setString(4, tripGroup.getGroupId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating trip group: " + e.getMessage());
            throw e;
        }
    }

    // Delete trip group
    public boolean deleteTripGroup(String groupId) throws SQLException {
        String sql = "DELETE FROM Trip_Group WHERE group_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, groupId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting trip group: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Get a trip group by ID, including associated course
     * @param groupId the group ID to look up
     * @return TripGroup object or null if not found
     * @throws SQLException if database error occurs
     */
    public TripGroup getGroupById(String groupId) throws SQLException {
        String sql = "SELECT g.*, c.* FROM Trip_Group g " +
                    "LEFT JOIN Course c ON g.course_id = c.course_id " +
                    "WHERE g.group_id = ?";

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

                    // Load course data if available
                    String courseId = rs.getString("course_id");
                    if (courseId != null) {
                        Course course = new Course();
                        course.setCourseId(courseId);
                        course.setCourseName(rs.getString("course_name"));
                        course.setFacultyId(rs.getString("faculty_id"));

                        group.setCourse(course);
                    }

                    return group;
                }
            }
        }
        return null;
    }

    // Add this method if it doesn't already exist:
    public void loadCourse(TripGroup tripGroup) throws SQLException {
        if (tripGroup != null && tripGroup.getCourseId() != null && !tripGroup.getCourseId().isEmpty()) {
            CourseDAO courseDAO = new CourseDAO();
            Course course = courseDAO.getCourseById(tripGroup.getCourseId());
            if (course != null) {
                tripGroup.setCourse(course);
            }
        }
    }
}