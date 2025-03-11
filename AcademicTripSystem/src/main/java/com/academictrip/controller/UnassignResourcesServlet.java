package com.academictrip.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.academictrip.dao.TripDAO;
import com.academictrip.model.Trip;

/**
 * Servlet implementation class UnassignResourcesServlet
 * Removes driver and vehicle assignments from trips
 */
@WebServlet("/transport/unassignResources")
public class UnassignResourcesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public UnassignResourcesServlet() {
        super();
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String tripId = request.getParameter("tripId");

        if (tripId == null || tripId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Trip ID is required");
            response.sendRedirect(request.getContextPath() + "/transport/viewAssignments.jsp");
            return;
        }

        try {
            TripDAO tripDAO = new TripDAO();
            Trip trip = tripDAO.getTripById(tripId);

            if (trip == null) {
                session.setAttribute("errorMessage", "Trip not found");
                response.sendRedirect(request.getContextPath() + "/transport/viewAssignments.jsp");
                return;
            }

            // Update trip to remove driver-vehicle assignment
            boolean success = tripDAO.updateTripDriverVehicle(tripId, null);

            if (success) {
                session.setAttribute("successMessage", "Assignment successfully removed");
            } else {
                session.setAttribute("errorMessage", "Failed to remove assignment");
            }

        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/transport/viewAssignments.jsp");
    }
}
