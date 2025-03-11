package com.academictrip.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.academictrip.model.Driver;
import com.academictrip.model.DriverVehicle;
import com.academictrip.model.Vehicle;
import com.academictrip.util.DatabaseUtil;

public class DriverVehicleDAO {
	private String generateDriverVehicleId() throws SQLException {
        String prefix = "DV";
        String sql = "SELECT MAX(driver_vehicle_id) AS max_id FROM Driver_Vehicle";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                String maxId = resultSet.getString("max_id");
                if (maxId == null) {
					return prefix + "001";
				}
                int numericPart = Integer.parseInt(maxId.replace(prefix, ""));
                return String.format("%s%03d", prefix, numericPart + 1);
            }
            return prefix + "001";
        }
    }

    // Insert a new assignment - fix column name to assigment_end (note the spelling)
	public String insertAssignment(DriverVehicle assignment) throws SQLException {
        String driverVehicleId = generateDriverVehicleId();
        String sql = "INSERT INTO Driver_Vehicle (driver_vehicle_id, driver_id, vehicle_id, assignment_start, assigment_end) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, driverVehicleId);
            stmt.setString(2, assignment.getDriverId());
            stmt.setString(3, assignment.getVehicleId());
            stmt.setDate(4, assignment.getAssignmentStart() != null ?
                            Date.valueOf(assignment.getAssignmentStart()) :
                            Date.valueOf(LocalDate.now())); // assignment_start
            stmt.setDate(5, assignment.getAssignmentEnd() != null ?
                            Date.valueOf(assignment.getAssignmentEnd()) :
                            Date.valueOf(LocalDate.now().plusDays(7))); // assigment_end (note the spelling)
            stmt.executeUpdate();

            return driverVehicleId;
        }
    }

    // Get all assignments - fix column name to assigment_end (note the spelling)
    public List<DriverVehicle> getAllAssignments() throws SQLException {
        List<DriverVehicle> assignments = new ArrayList<>();
        String sql = "SELECT * FROM Driver_Vehicle";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                DriverVehicle assignment = new DriverVehicle();
                assignment.setDriverVehicleId(resultSet.getString("driver_vehicle_id"));
                assignment.setDriverId(resultSet.getString("driver_id"));
                assignment.setVehicleId(resultSet.getString("vehicle_id"));

                // Properly handle DATE type fields
                Date startDate = resultSet.getDate("assignment_start");
                if (startDate != null) {
                    assignment.setAssignmentStart(startDate.toLocalDate());
                }

                // Use correct column name: assigment_end (note the spelling)
                Date endDate = resultSet.getDate("assigment_end");
                if (endDate != null) {
                    assignment.setAssignmentEnd(endDate.toLocalDate());
                }

                assignments.add(assignment);
            }
        }
        return assignments;
    }

    /**
     * Creates a new driver-vehicle assignment and returns the generated ID
     */
    public String createAssignment(String driverId, String vehicleId) throws SQLException {
        // Generate a new driver_vehicle_id
        String driverVehicleId = generateDriverVehicleId();

        // Make sure to include assignment_start and assigment_end fields as they're NOT NULL
        String sql = "INSERT INTO Driver_Vehicle (driver_vehicle_id, driver_id, vehicle_id, assignment_start, assigment_end) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, driverVehicleId);
            stmt.setString(2, driverId);
            stmt.setString(3, vehicleId);
            // Set default dates for the assignment (current date to one month later)
            LocalDate today = LocalDate.now();
            stmt.setDate(4, Date.valueOf(today));  // assignment_start
            stmt.setDate(5, Date.valueOf(today.plusMonths(1)));  // assigment_end (note the spelling)

            stmt.executeUpdate();
        }

        return driverVehicleId;
    }

    /**
     * Get assignment by its ID
     */
    public DriverVehicle getAssignmentByDriverVehicleId(String id) throws SQLException {
        String sql = "SELECT * FROM Driver_Vehicle WHERE driver_vehicle_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    DriverVehicle dv = new DriverVehicle();
                    dv.setDriverVehicleId(rs.getString("driver_vehicle_id"));
                    dv.setDriverId(rs.getString("driver_id"));
                    dv.setVehicleId(rs.getString("vehicle_id"));
                    dv.setAssignmentStart(rs.getDate("assignment_start").toLocalDate());
                    dv.setAssignmentEnd(rs.getDate("assigment_end").toLocalDate()); // Fixed column name
                    return dv;
                }
            }
        }
        return null;
    }

    /**
     * Get assignment for a specific trip
     */
    public DriverVehicle getAssignmentByTripId(String tripId) throws SQLException {
        String sql = "SELECT dv.* FROM Driver_Vehicle dv " +
                     "JOIN Trip t ON t.driver_vehicle_id = dv.driver_vehicle_id " +
                     "WHERE t.trip_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, tripId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    DriverVehicle dv = new DriverVehicle();
                    dv.setDriverVehicleId(rs.getString("driver_vehicle_id"));
                    dv.setDriverId(rs.getString("driver_id"));
                    dv.setVehicleId(rs.getString("vehicle_id"));
                    dv.setAssignmentStart(rs.getDate("assignment_start").toLocalDate());
                    dv.setAssignmentEnd(rs.getDate("assigment_end").toLocalDate()); // Fixed column name
                    return dv;
                }
            }
        }
        return null;
    }

    /**
     * Update an existing driver-vehicle assignment
     * @param assignment The assignment with updated values
     * @return true if update was successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updateAssignment(DriverVehicle assignment) throws SQLException {
        String sql = "UPDATE Driver_Vehicle SET driver_id = ?, vehicle_id = ?, " +
                     "assignment_start = ?, assigment_end = ? " +
                     "WHERE driver_vehicle_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, assignment.getDriverId());
            stmt.setString(2, assignment.getVehicleId());
            stmt.setDate(3, assignment.getAssignmentStart() != null ?
                            Date.valueOf(assignment.getAssignmentStart()) : null);
            stmt.setDate(4, assignment.getAssignmentEnd() != null ?
                            Date.valueOf(assignment.getAssignmentEnd()) : null);
            stmt.setString(5, assignment.getDriverVehicleId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Deletes a driver-vehicle assignment by ID
     *
     * @param driverVehicleId The ID of the assignment to delete
     * @return true if deletion was successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean deleteAssignment(String driverVehicleId) throws SQLException {
        String sql = "DELETE FROM driver_vehicle WHERE driver_vehicle_id = ?";

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, driverVehicleId);

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Get an assignment by its ID - correctly handles Date to LocalDate conversion
     * @param id the assignment ID
     * @return DriverVehicle object or null if not found
     * @throws SQLException if a database error occurs
     */
    public DriverVehicle getAssignmentById(String id) throws SQLException {
        String sql = "SELECT * FROM Driver_Vehicle WHERE driver_vehicle_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    DriverVehicle assignment = new DriverVehicle();
                    assignment.setDriverVehicleId(rs.getString("driver_vehicle_id"));
                    assignment.setDriverId(rs.getString("driver_id"));
                    assignment.setVehicleId(rs.getString("vehicle_id"));

                    // Convert java.sql.Date to java.time.LocalDate before setting
                    java.sql.Date startDate = rs.getDate("assignment_start");
                    if (startDate != null) {
                        assignment.setAssignmentStart(startDate.toLocalDate());
                    }

                    // Note the misspelling in the database column name (assigment_end)
                    java.sql.Date endDate = rs.getDate("assigment_end");
                    if (endDate != null) {
                        assignment.setAssignmentEnd(endDate.toLocalDate());
                    }

                    return assignment;
                }
            }
        }

        return null;
    }

    /**
     * Check if a driver is available for assignment (not currently assigned to another trip)
     * @param driverId the driver ID to check
     * @return true if the driver is available, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean isDriverAvailable(String driverId) throws SQLException {
        // First, get all current assignments
        List<DriverVehicle> currentAssignments = getActiveAssignments();

        // Check if the driver is assigned in any active assignments
        for (DriverVehicle assignment : currentAssignments) {
            if (driverId.equals(assignment.getDriverId())) {
                return false; // Driver is already assigned
            }
        }

        return true; // Driver is available
    }

    /**
     * Check if a vehicle is available for assignment (not currently assigned to another trip)
     * @param vehicleId the vehicle ID to check
     * @return true if the vehicle is available, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean isVehicleAvailable(String vehicleId) throws SQLException {
        // First, get all current assignments
        List<DriverVehicle> currentAssignments = getActiveAssignments();

        // Check if the vehicle is assigned in any active assignments
        for (DriverVehicle assignment : currentAssignments) {
            if (vehicleId.equals(assignment.getVehicleId())) {
                return false; // Vehicle is already assigned
            }
        }

        return true; // Vehicle is available
    }

    /**
     * Get all active assignments (assignments for trips that are not completed)
     * @return List of active driver-vehicle assignments
     * @throws SQLException if a database error occurs
     */
    private List<DriverVehicle> getActiveAssignments() throws SQLException {
        List<DriverVehicle> activeAssignments = new ArrayList<>();
        String sql = "SELECT dv.* FROM driver_vehicle dv " +
                     "JOIN trip t ON t.driver_vehicle_id = dv.driver_vehicle_id " +
                     "WHERE t.end_date >= CURRENT_DATE";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                DriverVehicle assignment = new DriverVehicle();
                assignment.setAssignmentId(rs.getString("driver_vehicle_id"));
                assignment.setDriverId(rs.getString("driver_id"));
                assignment.setVehicleId(rs.getString("vehicle_id"));

                // Handle nullable dates
                Date startDateSql = rs.getDate("assignment_start");
                if (startDateSql != null) {
                    assignment.setStartDate(startDateSql.toLocalDate());
                }

                Date endDateSql = rs.getDate("assigment_end");  // Note: this is the correct spelling as per schema
                if (endDateSql != null) {
                    assignment.setEndDate(endDateSql.toLocalDate());
                }

                // Add notes if the field exists
                try {
                    assignment.setNotes(rs.getString("notes"));
                } catch (SQLException e) {
                    // Field may not exist, ignore
                }

                activeAssignments.add(assignment);
            }
        }

        return activeAssignments;
    }

    /**
     * Get driver-vehicle assignment by ID, populating driver and vehicle objects
     * @param id the ID to look up
     * @return populated DriverVehicle object or null if not found
     * @throws SQLException if database error occurs
     */
    public DriverVehicle getDriverVehicleById(String id) throws SQLException {
        String sql = "SELECT * FROM Driver_Vehicle WHERE driver_vehicle_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    DriverVehicle dv = new DriverVehicle();

                    dv.setDriverVehicleId(rs.getString("driver_vehicle_id"));
                    dv.setDriverId(rs.getString("driver_id"));
                    dv.setVehicleId(rs.getString("vehicle_id"));

                    // Handle dates
                    Date startDate = rs.getDate("assignment_start");
                    if (startDate != null) {
                        dv.setAssignmentStart(startDate.toLocalDate());
                    }

                    Date endDate = rs.getDate("assigment_end");
                    if (endDate != null) {
                        dv.setAssignmentEnd(endDate.toLocalDate());
                    }

                    // Load related driver and vehicle objects
                    DriverDAO driverDAO = new DriverDAO();
                    VehicleDAO vehicleDAO = new VehicleDAO();

                    Driver driver = driverDAO.getDriverById(dv.getDriverId());
                    Vehicle vehicle = vehicleDAO.getVehicleById(dv.getVehicleId());

                    dv.setDriver(driver);
                    dv.setVehicle(vehicle);

                    return dv;
                }
            }
        }
        return null;
    }
}