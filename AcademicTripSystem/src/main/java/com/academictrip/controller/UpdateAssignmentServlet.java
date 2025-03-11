package com.academictrip.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.academictrip.dao.DriverVehicleDAO;
import com.academictrip.model.DriverVehicle;

/**
 * Servlet implementation class UpdateAssignmentServlet
 * Updates the driver and vehicle assignments for trips
 */
@WebServlet("/transport/updateAssignment")
public class UpdateAssignmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateAssignmentServlet() {
        super();
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Get form parameters
        String tripId = request.getParameter("tripId");
        String currentAssignmentId = request.getParameter("currentAssignmentId");
        String driverId = request.getParameter("driverId");
        String vehicleId = request.getParameter("vehicleId");
        String notes = request.getParameter("notes");

        // Optional date parameters
        String assignmentStartStr = request.getParameter("assignmentStart");
        String assignmentEndStr = request.getParameter("assignmentEnd");

        // Validate required parameters
        if (tripId == null || tripId.trim().isEmpty() ||
            currentAssignmentId == null || currentAssignmentId.trim().isEmpty() ||
            driverId == null || driverId.trim().isEmpty() ||
            vehicleId == null || vehicleId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "All required fields must be completed");
            response.sendRedirect(request.getContextPath() + "/transport/editAssignment.jsp?id=" + tripId);
            return;
        }

        try {
            DriverVehicleDAO driverVehicleDAO = new DriverVehicleDAO();

            // Check if we're actually changing anything
            DriverVehicle currentAssignment = driverVehicleDAO.getAssignmentById(currentAssignmentId);
            if (currentAssignment == null) {
                session.setAttribute("errorMessage", "Current assignment not found");
                response.sendRedirect(request.getContextPath() + "/transport/editAssignment.jsp?id=" + tripId);
                return;
            }

            // Check if the driver and vehicle are available (except for the current assignment)
            if (!driverId.equals(currentAssignment.getDriverId()) && !driverVehicleDAO.isDriverAvailable(driverId)) {
                session.setAttribute("errorMessage", "Selected driver is not available for assignment");
                response.sendRedirect(request.getContextPath() + "/transport/editAssignment.jsp?id=" + tripId);
                return;
            }

            if (!vehicleId.equals(currentAssignment.getVehicleId()) && !driverVehicleDAO.isVehicleAvailable(vehicleId)) {
                session.setAttribute("errorMessage", "Selected vehicle is not available for assignment");
                response.sendRedirect(request.getContextPath() + "/transport/editAssignment.jsp?id=" + tripId);
                return;
            }

            // Prepare assignment dates if provided
            LocalDate startDate = null;
            LocalDate endDate = null;
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            if (assignmentStartStr != null && !assignmentStartStr.trim().isEmpty()) {
                startDate = LocalDate.parse(assignmentStartStr, formatter);
            }

            if (assignmentEndStr != null && !assignmentEndStr.trim().isEmpty()) {
                endDate = LocalDate.parse(assignmentEndStr, formatter);
            }

            // Update the driver-vehicle assignment
            DriverVehicle updatedAssignment = new DriverVehicle();
            updatedAssignment.setDriverVehicleId(currentAssignmentId);
            updatedAssignment.setDriverId(driverId);
            updatedAssignment.setVehicleId(vehicleId);

            // Using the appropriate setter methods for dates
            if (startDate != null) {
                updatedAssignment.setAssignmentStart(startDate);
            }
            if (endDate != null) {
                updatedAssignment.setAssignmentEnd(endDate);
            }
            updatedAssignment.setNotes(notes);

            boolean success = driverVehicleDAO.updateAssignment(updatedAssignment);

            if (success) {
                session.setAttribute("successMessage", "Assignment updated successfully");
                // Redirect to trip details
                response.sendRedirect(request.getContextPath() + "/transport/tripDetails.jsp?id=" + tripId);
            } else {
                session.setAttribute("errorMessage", "Failed to update assignment");
                response.sendRedirect(request.getContextPath() + "/transport/editAssignment.jsp?id=" + tripId);
            }

        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/transport/editAssignment.jsp?id=" + tripId);
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/transport/editAssignment.jsp?id=" + tripId);
        }
    }
}
