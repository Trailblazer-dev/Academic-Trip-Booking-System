<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.dao.TripDAO" %>
<%@ page import="com.academictrip.model.Trip" %>
<%@ page import="com.academictrip.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>

<%
    User tripTableUser = (User) session.getAttribute("user");
    if (tripTableUser == null || !tripTableUser.getRole().equalsIgnoreCase("lecturer")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trip Timetable | Academic Trip System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">
    <div class="page-wrapper">
        <%@ include file="/includes/header.jsp" %>
        
        <div class="main-content">
            <div class="container mx-auto px-4 py-8">
                <!-- Page header -->
                <div class="md:flex md:items-center md:justify-between mb-8">
                    <div class="flex-1 min-w-0">
                        <h1 class="text-3xl font-bold text-gray-900">
                            <i class="fas fa-calendar-alt mr-2 text-secondary"></i> Trip Timetable
                        </h1>
                        <p class="mt-1 text-sm text-gray-500">
                            View all scheduled academic trips in the system
                        </p>
                    </div>
                    <div class="mt-4 md:mt-0">
                        <a href="${pageContext.request.contextPath}/lecturer/dashboard.jsp" 
                           class="bg-gray-500 hover:bg-gray-600 text-white py-2 px-4 rounded-md inline-flex items-center transition-colors">
                            <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
                        </a>
                    </div>
                </div>
                
                <!-- Timetable Card -->
                <div class="bg-white shadow-xl rounded-lg overflow-hidden mb-6">
                    <div class="bg-primary px-6 py-4">
                        <div class="flex justify-between items-center">
                            <h2 class="text-xl font-bold text-white">
                                <i class="fas fa-list mr-2"></i> All Academic Trips
                            </h2>
                            <a href="${pageContext.request.contextPath}/lecturer/addTrip.jsp" 
                               class="bg-secondary hover:bg-orange-500 text-white py-1.5 px-3 rounded-md inline-flex items-center text-sm transition-colors">
                                <i class="fas fa-plus mr-2"></i> Add Trip
                            </a>
                        </div>
                    </div>
                    <div class="p-6">
                        <% 
                            TripDAO tripDAO = new TripDAO();
                            List<Trip> trips = tripDAO.getAllTrips();
                            
                            if (trips != null && !trips.isEmpty()) { 
                        %>
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead>
                                    <tr class="bg-gray-50">
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Trip ID</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Departure</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Return</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Destination</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Course</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <% for (Trip trip : trips) { 
                                        String statusClass = trip.getDriverVehicleId() != null ? "bg-green-100 text-green-800" : "bg-yellow-100 text-yellow-800";
                                        String statusText = trip.getDriverVehicleId() != null ? "Assigned" : "Pending";
                                    %>
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <%= trip.getTripId() %>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <%= trip.getDepartureDate().format(formatter) %>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <%= trip.getReturnDate().format(formatter) %>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                            <%= trip.getDestination() != null ? trip.getDestination().getName() : "N/A" %>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full <%= statusClass %>">
                                                <%= statusText %>
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <%= trip.getCourse() != null ? trip.getCourse().getCode() : "N/A" %>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                            <a href="${pageContext.request.contextPath}/lecturer/viewTrip.jsp?id=<%= trip.getTripId() %>" 
                                               class="text-indigo-600 hover:text-indigo-900" title="View details">
                                                <i class="fas fa-eye"></i> Details
                                            </a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                            <div class="flex flex-col items-center justify-center py-10">
                                <div class="text-center">
                                    <div class="rounded-full bg-gray-100 p-6 inline-flex mb-4">
                                        <i class="fas fa-calendar-times text-4xl text-gray-400"></i>
                                    </div>
                                    <p class="text-lg text-gray-600 mb-4">No trips found in the system.</p>
                                    <a href="${pageContext.request.contextPath}/lecturer/addTrip.jsp" class="bg-blue-600 hover:bg-blue-700 text-white py-2 px-4 rounded-md inline-flex items-center">
                                        <i class="fas fa-plus mr-2"></i> Create New Trip
                                    </a>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
                
                <!-- Calendar View (Optional - Advanced Feature) -->
                <div class="bg-white shadow-xl rounded-lg overflow-hidden mb-6">
                    <div class="bg-primary px-6 py-4">
                        <h2 class="text-xl font-bold text-white">
                            <i class="fas fa-calendar mr-2"></i> Calendar View
                        </h2>
                    </div>
                    <div class="p-6">
                        <div class="bg-gray-50 p-4 rounded-lg border border-gray-200">
                            <p class="text-center text-gray-600">
                                <i class="fas fa-info-circle mr-1"></i> 
                                Calendar view will be available in a future update.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <footer>
            <div class="footer-content">
                <p>&copy; <%= LocalDate.now().getYear() %> Academic Trip System. All rights reserved.</p>
                <p class="mt-2 text-sm text-gray-300">Lecturer Management Module</p>
            </div>
        </footer>
    </div>
</body>
</html>
