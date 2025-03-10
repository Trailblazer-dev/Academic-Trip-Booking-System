package com.academictrip.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.academictrip.model.User;

@WebFilter(urlPatterns = {"/lecturer/*", "/transport/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        String requestURI = httpRequest.getRequestURI();

        // Check if user is logged in
        if (!isLoggedIn) {
            // Use our dedicated session expired page instead of a parameter
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/session-expired.jsp");
            return;
        }

        // Check if user has appropriate role for the requested resource
        User user = (User) session.getAttribute("user");
        String role = user.getRole().toLowerCase();

        if (requestURI.contains("/lecturer/") && !role.equals("lecturer") && !role.equals("admin")) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/unauthorized.jsp");
            return;
        }

        if (requestURI.contains("/transport/") && !role.equals("transport_manager") &&
            !role.equals("transport") && !role.equals("admin")) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/unauthorized.jsp");
            return;
        }

        // Check for session timeout - inactive for more than 20 minutes
        Long lastActivity = (Long) session.getAttribute("lastActivityTime");
        if (lastActivity != null) {
            long currentTime = System.currentTimeMillis();
            if (currentTime - lastActivity > 20 * 60 * 1000) {  // 20 minutes
                session.invalidate();
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/session-expired.jsp");
                return;
            }
        }

        // Continue with the filter chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
