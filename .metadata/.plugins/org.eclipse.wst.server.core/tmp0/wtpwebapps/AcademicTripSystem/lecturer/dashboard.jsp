<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.model.User" %>
<%@ page import="com.academictrip.dao.TripDAO" %>
<%@ page import="com.academictrip.model.Trip" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    // Renamed variable to avoid conflict with header.jsp
    User dashboardUser = (User) session.getAttribute("user");
    if (dashboardUser == null || !dashboardUser.getRole().equalsIgnoreCase("lecturer")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get lecturer's trips
    TripDAO tripDAO = new TripDAO();
    List<Trip> upcomingTrips = tripDAO.getTripsByLecturerId(dashboardUser.getId());
    
    // Get current page name for navigation highlighting
    String pageName = request.getServletPath();
    pageName = pageName.substring(pageName.lastIndexOf("/") + 1);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lecturer Dashboard | Academic Trip System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">
    <div class="page-wrapper">
        <%@ include file="/includes/header.jsp" %>
        
        <div class="main-content">
            <div class="container mx-auto px-4 py-8 max-w-7xl">
                <!-- Welcome Banner -->
                <div class="bg-gradient-to-r from-primary to-primary-dark rounded-lg shadow-lg mb-8 p-6 text-white">
                    <div class="flex items-center justify-between">
                        <div>
                            <h1 class="text-3xl font-bold">
                                <i class="fas fa-tachometer-alt mr-2"></i>Welcome, <%= dashboardUser.getName() != null ? dashboardUser.getName() : "Lecturer" %>
                            </h1>
                            <p class="mt-1 opacity-80">
                                Your academic trip planning portal - Request, track and manage all your trips
                            </p>
                        </div>
                        <div class="hidden md:block bg-white bg-opacity-10 p-4 rounded-lg">
                            <div class="text-center">
                                <p class="text-sm uppercase tracking-wider mb-1">Today's Date</p>
                                <p class="text-xl font-semibold"><%= LocalDate.now().format(DateTimeFormatter.ofPattern("dd MMMM yyyy")) %></p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Display success or error messages -->
                <% if (session.getAttribute("successMessage") != null) { %>
                    <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-6" role="alert" id="successAlert">
                        <div class="flex items-center">
                            <div class="flex-shrink-0">
                                <i class="fas fa-check-circle text-green-500"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-green-700"><%= session.getAttribute("successMessage") %></p>
                            </div>
                            <div class="ml-auto">
                                <button onclick="document.getElementById('successAlert').style.display='none'" class="text-green-500">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <% session.removeAttribute("successMessage"); %>
                <% } %>
                
                <% if (session.getAttribute("errorMessage") != null) { %>
                    <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6" role="alert" id="errorAlert">
                        <div class="flex items-center">
                            <div class="flex-shrink-0">
                                <i class="fas fa-exclamation-circle text-red-500"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-red-700"><%= session.getAttribute("errorMessage") %></p>
                            </div>
                            <div class="ml-auto">
                                <button onclick="document.getElementById('errorAlert').style.display='none'" class="text-red-500">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <% session.removeAttribute("errorMessage"); %>
                <% } %>
        
                <!-- Stats Cards -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                    <div class="bg-white rounded-lg shadow-md p-6 border-t-4 border-blue-500 transform transition-transform duration-300 hover:-translate-y-1 hover:shadow-lg">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-blue-100 mr-4">
                                <i class="fas fa-clipboard-list text-xl text-blue-500"></i>
                            </div>
                            <div>
                                <h3 class="text-lg font-semibold text-gray-700">Total Trips</h3>
                                <p class="text-2xl font-bold text-gray-800"><%= upcomingTrips.size() %></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white rounded-lg shadow-md p-6 border-t-4 border-green-500 transform transition-transform duration-300 hover:-translate-y-1 hover:shadow-lg">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-green-100 mr-4">
                                <i class="fas fa-check-circle text-xl text-green-500"></i>
                            </div>
                            <div>
                                <h3 class="text-lg font-semibold text-gray-700">Assigned Trips</h3>
                                <%
                                    int assignedTrips = 0;
                                    for (Trip trip : upcomingTrips) {
                                        if (trip.getDriverVehicleId() != null) {
                                            assignedTrips++;
                                        }
                                    }
                                %>
                                <p class="text-2xl font-bold text-gray-800"><%= assignedTrips %></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white rounded-lg shadow-md p-6 border-t-4 border-yellow-500 transform transition-transform duration-300 hover:-translate-y-1 hover:shadow-lg">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-yellow-100 mr-4">
                                <i class="fas fa-clock text-xl text-yellow-500"></i>
                            </div>
                            <div>
                                <h3 class="text-lg font-semibold text-gray-700">Pending Trips</h3>
                                <p class="text-2xl font-bold text-gray-800"><%= upcomingTrips.size() - assignedTrips %></p>
                            </div>
                        </div>
                    </div>
                </div>
        
                <!-- Quick Action Cards -->
                <div class="mb-8">
                    <h2 class="text-xl font-bold text-gray-800 mb-4">
                        <i class="fas fa-bolt text-secondary mr-2"></i>Quick Actions
                    </h2>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <a href="${pageContext.request.contextPath}/lecturer/addTrip.jsp" 
                           class="bg-white rounded-lg shadow-md p-8 text-center transition-all duration-300 hover:shadow-lg hover:bg-blue-50 hover:border-blue-500 border border-gray-100">
                            <div class="inline-flex h-16 w-16 mx-auto rounded-full bg-blue-100 items-center justify-center mb-4">
                                <i class="fas fa-plus-circle text-2xl text-blue-500"></i>
                            </div>
                            <h3 class="text-lg font-semibold text-gray-800 mb-2">New Trip</h3>
                            <p class="text-gray-600">Request a new academic trip for your students</p>
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/lecturer/viewTimetable.jsp" 
                           class="bg-white rounded-lg shadow-md p-8 text-center transition-all duration-300 hover:shadow-lg hover:bg-green-50 hover:border-green-500 border border-gray-100">
                            <div class="inline-flex h-16 w-16 mx-auto rounded-full bg-green-100 items-center justify-center mb-4">
                                <i class="fas fa-calendar-alt text-2xl text-green-500"></i>
                            </div>
                            <h3 class="text-lg font-semibold text-gray-800 mb-2">Timetable</h3>
                            <p class="text-gray-600">View your complete trip schedule and calendar</p>
                        </a>
                        
                        <a href="#" 
                           class="bg-white rounded-lg shadow-md p-8 text-center transition-all duration-300 hover:shadow-lg hover:bg-purple-50 hover:border-purple-500 border border-gray-100">
                            <div class="inline-flex h-16 w-16 mx-auto rounded-full bg-purple-100 items-center justify-center mb-4">
                                <i class="fas fa-file-alt text-2xl text-purple-500"></i>
                            </div>
                            <h3 class="text-lg font-semibold text-gray-800 mb-2">Reports</h3>
                            <p class="text-gray-600">Generate and download trip reports</p>
                        </a>
                    </div>
                </div>
        
                <!-- Upcoming Trips Section -->
                <div class="bg-white shadow-xl rounded-lg overflow-hidden mb-8">
                    <div class="bg-primary px-6 py-4">
                        <div class="flex justify-between items-center">
                            <h2 class="text-xl font-bold text-white">
                                <i class="fas fa-bus mr-2"></i> Your Upcoming Trips
                            </h2>
                            <a href="${pageContext.request.contextPath}/lecturer/viewTimetable.jsp" class="text-white text-sm bg-white bg-opacity-20 px-3 py-1 rounded hover:bg-opacity-30 transition-all">
                                <i class="fas fa-eye mr-1"></i> View All
                            </a>
                        </div>
                    </div>
                    <div class="p-6">
                        <% if (upcomingTrips != null && !upcomingTrips.isEmpty()) { %>
                            <div class="overflow-x-auto">
                                <table class="min-w-full divide-y divide-gray-200">
                                    <thead>
                                        <tr class="bg-gray-50">
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Trip ID</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Destination</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody class="bg-white divide-y divide-gray-200">
                                        <% 
                                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy");
                                        // Limit to display only first 5 trips
                                        int tripsToShow = Math.min(upcomingTrips.size(), 5);
                                        for (int i = 0; i < tripsToShow; i++) {
                                            Trip trip = upcomingTrips.get(i);
                                            String statusClass = "status-pending";
                                            String statusLabel = "Pending";
                                            String badgeClass = "bg-yellow-100 text-yellow-800";
                                            if (trip.getDriverVehicleId() != null) {
                                                statusClass = "status-assigned";
                                                statusLabel = "Resources Assigned";
                                                badgeClass = "bg-green-100 text-green-800";
                                            }
                                        %>
                                        <tr class="hover:bg-gray-50">
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                <%= trip.getId() %>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                                <%= trip.getDestination().getName() %>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                <%= trip.getTripDate().format(formatter) %>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full <%= badgeClass %>">
                                                    <%= statusLabel %>
                                                </span>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                <a href="${pageContext.request.contextPath}/lecturer/viewTrip.jsp?id=<%= trip.getId() %>" 
                                                   class="text-indigo-600 hover:text-indigo-900" title="View details">
                                                    <i class="fas fa-eye"></i> Details
                                                </a>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <% if (upcomingTrips.size() > 5) { %>
                                <div class="text-center mt-4">
                                    <a href="${pageContext.request.contextPath}/lecturer/viewTimetable.jsp" class="text-indigo-600 hover:text-indigo-900 font-medium">
                                        View all <%= upcomingTrips.size() %> trips <i class="fas fa-arrow-right ml-1"></i>
                                    </a>
                                </div>
                            <% } %>
                        <% } else { %>
                            <div class="flex flex-col items-center justify-center py-10">
                                <div class="text-center">
                                    <div class="rounded-full bg-gray-100 p-6 inline-flex mb-4">
                                        <i class="fas fa-calendar-times text-4xl text-gray-400"></i>
                                    </div>
                                    <p class="text-lg text-gray-600 mb-4">You don't have any upcoming trips scheduled.</p>
                                    <a href="${pageContext.request.contextPath}/lecturer/addTrip.jsp" 
                                       class="btn btn-primary inline-flex items-center px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md transition-colors">
                                        <i class="fas fa-plus mr-2"></i> Create New Trip
                                    </a>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
                
                <!-- Recent Activity Section -->
                <div class="bg-white shadow-xl rounded-lg overflow-hidden mb-8">
                    <div class="bg-secondary px-6 py-4">
                        <h2 class="text-xl font-bold text-white">
                            <i class="fas fa-bell mr-2"></i> System Updates
                        </h2>
                    </div>
                    <div class="p-6">
                        <ul class="space-y-4">
                            <li class="flex items-start">
                                <div class="flex-shrink-0 h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center">
                                    <i class="fas fa-info-circle text-blue-500"></i>
                                </div>
                                <div class="ml-4">
                                    <p class="text-sm font-medium text-gray-900">Transport module updated</p>
                                    <p class="text-sm text-gray-500">The transport assignment system has been updated with new features.</p>
                                </div>
                            </li>
                            <li class="flex items-start">
                                <div class="flex-shrink-0 h-10 w-10 rounded-full bg-green-100 flex items-center justify-center">
                                    <i class="fas fa-check-circle text-green-500"></i>
                                </div>
                                <div class="ml-4">
                                    <p class="text-sm font-medium text-gray-900">Resource allocation improved</p>
                                    <p class="text-sm text-gray-500">The resource allocation system has been optimized for faster assignment.</p>
                                </div>
                            </li>
                        </ul>
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

    <script>
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('#successAlert, #errorAlert');
            alerts.forEach(alert => {
                if (alert) alert.style.display = 'none';
            });
        }, 5000);
    </script>
</body>
</html>
