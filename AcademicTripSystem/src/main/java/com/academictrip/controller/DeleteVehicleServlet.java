package com.academictrip.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.academictrip.dao.VehicleDAO;

/**
 * Servlet implementation class DeleteVehicleServlet
 * Handles deletion of vehicles from the database
 */
@WebServlet("/transport/deleteVehicle")
public class DeleteVehicleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String vehicleId = request.getParameter("vehicleId");
        
        if (vehicleId == null || vehicleId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Vehicle ID is required for deletion");
            response.sendRedirect(request.getContextPath() + "/transport/manageVehicles.jsp");
            return;
        }
        
        try {
            VehicleDAO vehicleDAO = new VehicleDAO();
            
            // Check if vehicle is assigned to any trips before deleting
            if (vehicleDAO.isVehicleAssigned(vehicleId)) {
                session.setAttribute("errorMessage", 
                    "Cannot delete vehicle as it is currently assigned to a trip. Remove assignments first.");
            } else {
                boolean deleted = vehicleDAO.deleteVehicle(vehicleId);
                
                if (deleted) {
                    session.setAttribute("successMessage", "Vehicle deleted successfully");
                } else {
                    session.setAttribute("errorMessage", "Failed to delete vehicle. It may no longer exist.");
                }
            }
            
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/transport/manageVehicles.jsp");
    }
}
