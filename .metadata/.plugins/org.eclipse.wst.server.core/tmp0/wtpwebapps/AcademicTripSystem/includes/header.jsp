<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userRole = currentUser != null ? currentUser.getRole() : "";
%>
<header class="header">
    <div class="container">
        <nav class="nav">
            <a href="<%= request.getContextPath() %>/" class="nav-logo">Academic Trip System</a>
            <ul class="nav-links">
                <% if (currentUser != null) { %>
                    <% if ("lecturer".equalsIgnoreCase(userRole)) { %>
                        <li><a href="<%= request.getContextPath() %>/lecturer/addTrip.jsp">Add Trip</a></li>
                        <li><a href="<%= request.getContextPath() %>/lecturer/viewTimetable.jsp">View Timetable</a></li>
                    <% } else if ("transport_manager".equalsIgnoreCase(userRole) || "transport".equalsIgnoreCase(userRole)) { %>
                        <li><a href="<%= request.getContextPath() %>/transport/manageDrivers.jsp">Manage Drivers</a></li>
                        <li><a href="<%= request.getContextPath() %>/transport/manageVehicles.jsp">Manage Vehicles</a></li>
                        <li><a href="<%= request.getContextPath() %>/transport/assignResources.jsp">Assign Resources</a></li>
                        <li><a href="<%= request.getContextPath() %>/transport/assignDriverVehicle.jsp">Driver-Vehicle Assignments</a></li>
                        <li><a href="<%= request.getContextPath() %>/transport/viewAssignments.jsp">View Assignments</a></li>
                    <% } %>
                    <li><a href="<%= request.getContextPath() %>/logout.jsp">Logout</a></li>
                <% } else { %>
                    <li><a href="<%= request.getContextPath() %>/login.jsp">Login</a></li>
                <% } %>
            </ul>
        </nav>
    </div>
</header>
