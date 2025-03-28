package com.academictrip.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the current session
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Log the logout action (optional)
            String username = "unknown";
            if (session.getAttribute("user") != null) {
                username = ((com.academictrip.model.User)session.getAttribute("user")).getUsername();
            }

            // Invalidate the session
            session.invalidate();
        }

        // Redirect to login page with logout message
        response.sendRedirect(request.getContextPath() + "/login.jsp?status=logout");
    }
}
