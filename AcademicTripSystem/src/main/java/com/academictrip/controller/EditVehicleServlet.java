package com.academictrip.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.academictrip.dao.VehicleDAO;
import com.academictrip.model.Vehicle;

/**
 * Servlet to handle editing vehicle information
 */
@WebServlet("/transport/editVehicle")
public class EditVehicleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameters from the form
        String vehicleId = request.getParameter("vehicleId");
        String make = request.getParameter("make");
        String model = request.getParameter("model");
        String yearStr = request.getParameter("year");
        String capacity = request.getParameter("capacity");
        String registration = request.getParameter("registration");

        // Validate input
        if (vehicleId == null || make == null || model == null || yearStr == null
                || capacity == null || registration == null) {
            request.getSession().setAttribute("errorMessage", "All fields are required");
            response.sendRedirect(request.getContextPath() + "/transport/manageVehicles.jsp");
            return;
        }

        try {
            // Create vehicle object
            Vehicle vehicle = new Vehicle();
            vehicle.setVehicleId(vehicleId);
            vehicle.setMake(make);
            vehicle.setModel(model);

            // Parse year into LocalDate (January 1st of the year)
            int yearInt = Integer.parseInt(yearStr);
            vehicle.setYear(LocalDate.of(yearInt, 1, 1));

            vehicle.setCapacity(Integer.parseInt(capacity));
            vehicle.setPlateNumber(registration);

            // Update vehicle in database
            VehicleDAO vehicleDAO = new VehicleDAO();
            boolean success = vehicleDAO.updateVehicle(vehicle);

            if (success) {
                request.getSession().setAttribute("successMessage", "Vehicle updated successfully");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update vehicle");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid number format");
        } catch (SQLException e) {
            request.getSession().setAttribute("errorMessage", "Database error: " + e.getMessage());
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
        }

        // Redirect back to the manage vehicles page
        response.sendRedirect(request.getContextPath() + "/transport/manageVehicles.jsp");
    }
}
