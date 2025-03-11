package com.academictrip.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.academictrip.dao.UserDAO;
import com.academictrip.model.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Add some basic validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?status=error");
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.validateUser(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("lastActivityTime", System.currentTimeMillis());

            // Redirect based on role
            if ("lecturer".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/lecturer/dashboard.jsp");
            } else if ("transport".equalsIgnoreCase(user.getRole()) ||
                       "transport_manager".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/transport/dashboard.jsp");
            } else if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            } else {
                // Default fallback for unknown roles
                response.sendRedirect(request.getContextPath() + "/login.jsp?status=error");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?status=error");
        }
    }
}
