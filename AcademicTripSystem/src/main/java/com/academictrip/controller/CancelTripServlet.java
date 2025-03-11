package com.academictrip.controller;

import java.io.IOException;
import javax.servlet.ServletException;
// Remove @WebServlet annotation as this is configured in web.xml
// import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.academictrip.dao.TripDAO;

/**
 * Servlet implementation class CancelTripServlet
 * Handles the cancellation of trips by lecturers
 * 
 * Note: This servlet is configured in web.xml, not using @WebServlet annotation
 */
public class CancelTripServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String tripId = request.getParameter("tripId");
        
        if (tripId == null || tripId.isEmpty()) {
            session.setAttribute("errorMessage", "Trip ID is required");
            response.sendRedirect(request.getContextPath() + "/lecturer/dashboard.jsp");
            return;
        }
        
        try {
            TripDAO tripDAO = new TripDAO();
            boolean success = tripDAO.deleteTrip(tripId);
            
            if (success) {
                session.setAttribute("successMessage", "Trip was successfully cancelled");
            } else {
                session.setAttribute("errorMessage", "Failed to cancel trip");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/lecturer/dashboard.jsp");
    }
}
