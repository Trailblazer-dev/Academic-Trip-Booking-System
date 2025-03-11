package com.academictrip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.academictrip.model.Faculty;
import com.academictrip.util.DatabaseUtil;

public class FacultyDAO {

    // Generate faculty_id (e.g., FAC001)
    private String generateFacultyId() throws SQLException {
        String prefix = "FAC";
        String sql = "SELECT MAX(faculty_id) AS max_id FROM Faculty";
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

    // Insert a new faculty
    public void insertFaculty(Faculty faculty) throws SQLException {
        String facultyId = generateFacultyId();
        faculty.setFacultyId(facultyId);
        String sql = "INSERT INTO Faculty (faculty_id, name) VALUES (?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, faculty.getFacultyId());
            stmt.setString(2, faculty.getName());
            stmt.executeUpdate();
        }
    }

    // Find faculty by name
    public Faculty findFacultyByName(String name) throws SQLException {
        String sql = "SELECT * FROM Faculty WHERE name = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Faculty(
                        rs.getString("faculty_id"),
                        rs.getString("name")
                    );
                }
                return null;
            }
        }
    }

    // Get all faculties
    public List<Faculty> getAllFaculties() throws SQLException {
        List<Faculty> faculties = new ArrayList<>();
        String sql = "SELECT * FROM Faculty ORDER BY name";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Faculty faculty = new Faculty();
                faculty.setFacultyId(rs.getString("faculty_id"));
                faculty.setName(rs.getString("name"));
                faculties.add(faculty);
            }
        }
        return faculties;
    }

    /**
     * Get faculty by ID
     * @param facultyId the faculty ID to lookup
     * @return Faculty object if found, null otherwise
     * @throws SQLException if database error occurs
     */
    public Faculty getFacultyById(String facultyId) throws SQLException {
        String sql = "SELECT * FROM Faculty WHERE faculty_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, facultyId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Faculty faculty = new Faculty();
                    faculty.setFacultyId(rs.getString("faculty_id"));
                    faculty.setName(rs.getString("name"));
                    return faculty;
                }
            }
        }
        
        return null;
    }
}