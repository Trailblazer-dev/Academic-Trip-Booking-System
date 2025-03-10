package com.academictrip.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.academictrip.dao.DriverVehicleDAO;
import com.academictrip.dao.TripDAO;
import com.academictrip.model.DriverVehicle;

// Change the servlet mapping to match the request URL pattern
@WebServlet("/updateAssignment")
public class UpdateAssignmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tripId = request.getParameter("tripId");
        String assignmentId = request.getParameter("assignmentId");
        String driverId = request.getParameter("driverId");
        String vehicleId = request.getParameter("vehicleId");
        String startDateStr = request.getParameter("assignmentStart");
        String endDateStr = request.getParameter("assignmentEnd");

        // Convert date strings to LocalDate
        LocalDate startDate = startDateStr != null && !startDateStr.isEmpty() ?
                              LocalDate.parse(startDateStr) : null;
        LocalDate endDate = endDateStr != null && !endDateStr.isEmpty() ?
                            LocalDate.parse(endDateStr) : null;

        try {
            DriverVehicleDAO driverVehicleDAO = new DriverVehicleDAO();
            TripDAO tripDAO = new TripDAO();

            // Check if this is a new assignment or an update to an existing one
            if (assignmentId == null || assignmentId.trim().isEmpty()) {
                // Create new assignment
                DriverVehicle newAssignment = new DriverVehicle();
                newAssignment.setDriverId(driverId);
                newAssignment.setVehicleId(vehicleId);
                newAssignment.setAssignmentStart(startDate);
                newAssignment.setAssignmentEnd(endDate);

                // Insert the assignment and get the ID
                String newAssignmentId = driverVehicleDAO.insertAssignment(newAssignment);

                // Update the trip with the new driver_vehicle_id
                tripDAO.updateTripDriverVehicle(tripId, newAssignmentId);
            } else {
                // Update existing assignment - first retrieve it
                DriverVehicle existingAssignment = driverVehicleDAO.getAssignmentByDriverVehicleId(assignmentId);

                if (existingAssignment != null) {
                    // Update the assignment with new data
                    existingAssignment.setDriverId(driverId);
                    existingAssignment.setVehicleId(vehicleId);
                    existingAssignment.setAssignmentStart(startDate);
                    existingAssignment.setAssignmentEnd(endDate);

                    // Update in database
                    driverVehicleDAO.updateAssignment(existingAssignment);
                }
            }

            // Set success message
            request.getSession().setAttribute("successMessage", "Assignment updated successfully");

            // Redirect back to trip details page - fix the path to include the transport directory
            response.sendRedirect(request.getContextPath() + "/transport/tripDetails.jsp?id=" + tripId);

        } catch (SQLException e) {
            // Set error message
            request.getSession().setAttribute("errorMessage", "Error updating assignment: " + e.getMessage());

            // Redirect back to edit assignment page
            response.sendRedirect(request.getContextPath() + "/transport/editAssignment.jsp?id=" + tripId);
        }
    }
}
