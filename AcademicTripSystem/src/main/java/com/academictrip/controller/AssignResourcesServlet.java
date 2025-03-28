package com.academictrip.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.academictrip.dao.DriverVehicleDAO;
import com.academictrip.dao.TripDAO;
import com.academictrip.model.DriverVehicle;

/**
 * Servlet implementation class AssignResourcesServlet
 */
public class AssignResourcesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String tripId = request.getParameter("tripId");
        String driverId = request.getParameter("driverId");
        String vehicleId = request.getParameter("vehicleId");
        String startDateStr = request.getParameter("assignmentStart");
        String endDateStr = request.getParameter("assignmentEnd");

        // Validate inputs
        if (tripId == null || tripId.isEmpty() ||
            driverId == null || driverId.isEmpty() ||
            vehicleId == null || vehicleId.isEmpty()) {
            session.setAttribute("errorMessage", "All required fields must be filled.");
            response.sendRedirect("assignResources.jsp");
            return;
        }

        try {
            // Create driver-vehicle assignment
            DriverVehicle assignment = new DriverVehicle();
            assignment.setDriverId(driverId);
            assignment.setVehicleId(vehicleId);

            // Set assignment period from form or default to current date + 7 days
            LocalDate today = LocalDate.now();
            LocalDate startDate = (startDateStr != null && !startDateStr.isEmpty())
                ? LocalDate.parse(startDateStr) : today;
            LocalDate endDate = (endDateStr != null && !endDateStr.isEmpty())
                ? LocalDate.parse(endDateStr) : today.plusDays(7);

            // Validate dates - ensure end date is after start date
            if (endDate.isBefore(startDate)) {
                session.setAttribute("errorMessage", "End date must be after start date.");
                response.sendRedirect("assignResources.jsp?tripId=" + tripId);
                return;
            }

            assignment.setAssignmentStart(startDate);
            assignment.setAssignmentEnd(endDate);

            // Insert the assignment and get the ID
            String driverVehicleId = new DriverVehicleDAO().insertAssignment(assignment);

            if (driverVehicleId == null || driverVehicleId.isEmpty()) {
                session.setAttribute("errorMessage", "Failed to create driver-vehicle assignment.");
                response.sendRedirect("assignResources.jsp?tripId=" + tripId);
                return;
            }

            // Update the trip with the driver_vehicle_id
            boolean success = new TripDAO().updateTripDriverVehicle(tripId, driverVehicleId);

            if (success) {
                session.setAttribute("successMessage", "Resources successfully assigned to trip.");
                response.sendRedirect("tripDetails.jsp?id=" + tripId);
            } else {
                // If trip update fails, try to clean up the driver-vehicle assignment
                new DriverVehicleDAO().deleteAssignment(driverVehicleId);
                session.setAttribute("errorMessage", "Failed to assign resources to trip.");
                response.sendRedirect("assignResources.jsp?tripId=" + tripId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect("assignResources.jsp?tripId=" + tripId);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            response.sendRedirect("assignResources.jsp?tripId=" + tripId);
        }
    }
}
