package com.academictrip.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.academictrip.dao.DriverDAO;

/**
 * Servlet implementation class DeleteDriverServlet
 * Handles deletion of drivers from the database
 */
@WebServlet("/transport/deleteDriver")
public class DeleteDriverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String driverId = request.getParameter("driverId");

        if (driverId == null || driverId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Driver ID is required for deletion");
            response.sendRedirect(request.getContextPath() + "/transport/manageDrivers.jsp");
            return;
        }

        try {
            DriverDAO driverDAO = new DriverDAO();

            // Check if driver is assigned to any trips before deleting
            if (driverDAO.isDriverAssigned(driverId)) {
                session.setAttribute("errorMessage",
                    "Cannot delete driver as they are currently assigned to a trip. Remove assignments first.");
            } else {
                boolean deleted = driverDAO.deleteDriver(driverId);

                if (deleted) {
                    session.setAttribute("successMessage", "Driver deleted successfully");
                } else {
                    session.setAttribute("errorMessage", "Failed to delete driver. They may no longer exist.");
                }
            }

        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/transport/manageDrivers.jsp");
    }
}
