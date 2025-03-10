package com.academictrip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.academictrip.model.Trip;
import com.academictrip.util.DatabaseUtil;

public class TripDAO {

	// Generate the next trip ID (e.g., TRP001)
	private String generateTripId() throws SQLException {
        String prefix = "TRP";
        String sql = "SELECT MAX(trip_id) FROM Trip";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                String maxId = rs.getString(1);
                if (maxId == null) {
					return prefix + "001";
				}
                int numericPart = Integer.parseInt(maxId.replace(prefix, ""));
                return String.format("%s%03d", prefix, numericPart + 1);
            }
            return prefix + "001";
        }
    }



    // Insert a new trip
	public void insertTrip(Trip trip) throws SQLException {
        String tripId = generateTripId();
        trip.setTripId(tripId); // Set generated ID

        String sql = "INSERT INTO Trip (trip_id, start_date, end_date, incharge_group_id, destination_id) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, trip.getTripId());
            stmt.setString(2, trip.getStartDate());
            stmt.setString(3, trip.getEndDate());
            stmt.setString(4, trip.getInchargeGroupId());
            stmt.setString(5, trip.getDestinationId());

            stmt.executeUpdate();
        }
    }

    public void updateTripDriverVehicle(String tripId, String driverVehicleId) throws SQLException {
        String sql = "UPDATE Trip SET driver_vehicle_id = ? WHERE trip_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, driverVehicleId);
            stmt.setString(2, tripId);
            stmt.executeUpdate();
        }
    }

    // Get all trips
    public List<Trip> getAllTrips() throws SQLException {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM Trip";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                Trip trip = new Trip(
                    resultSet.getString("trip_id"),
                    resultSet.getString("start_date"),
                    resultSet.getString("end_date"),
                    resultSet.getString("destination_id"),
                    resultSet.getString("driver_vehicle_id"),
                    resultSet.getString("incharge_group_id")

                );
                trips.add(trip);
            }
        }
        return trips;
    }
}