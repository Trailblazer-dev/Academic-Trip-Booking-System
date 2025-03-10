package com.academictrip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.academictrip.model.Course;
import com.academictrip.util.DatabaseUtil;

public class CourseDAO {
    // Generate course_id (e.g., COU001)
    private String generateCourseId() throws SQLException {
        String prefix = "COU";
        String sql = "SELECT MAX(course_id) AS max_id FROM Course";
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

    public void insertCourse(Course course) throws SQLException {
        String courseId = generateCourseId();
        course.setCourseId(courseId);
        String sql = "INSERT INTO Course (course_id, course_name, faculty_id) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, course.getCourseId());
            stmt.setString(2, course.getCourseName());
            stmt.setString(3, course.getFacultyId());
            stmt.executeUpdate();
        }
    }

    public Course findCourseByName(String name) throws SQLException {
        String sql = "SELECT * FROM Course WHERE course_name = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Course(
                        rs.getString("course_id"),
                        rs.getString("course_name"),
                        rs.getString("faculty_id")
                    );
                }
                return null;
            }
        }
    }

    /**
     * Retrieve a course by its ID
     * @param courseId The ID of the course
     * @return The course object or null if not found
     * @throws SQLException if a database access error occurs
     */
    public Course getCourseById(String courseId) throws SQLException {
        String sql = "SELECT * FROM Course WHERE course_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, courseId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Course course = new Course();
                    course.setCourseId(rs.getString("course_id"));
                    course.setCourseName(rs.getString("course_name"));
                    course.setFacultyId(rs.getString("faculty_id"));
                    return course;
                }
            }
        }
        return null;
    }
}