<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.dao.*" %>
<%@ page import="com.academictrip.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transport Dashboard | Academic Trip System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="../includes/transportHeader.jsp" %>
    
    <div class="container">
        <div class="page-title">
            <h1 class="text-2xl font-bold text-gray-800"><i class="fas fa-tachometer-alt mr-2"></i>Transport Dashboard</h1>
        </div>
        
        <%
            // Get counts for dashboard
            TripDAO tripDAO = new TripDAO();
            DriverDAO driverDAO = new DriverDAO();
            VehicleDAO vehicleDAO = new VehicleDAO();
            
            // Get available trips
            List<Trip> allTrips = tripDAO.getAllTrips();
            int pendingTrips = 0;
            int assignedTrips = 0;
            
            // Count pending vs assigned trips - use driverVehicleId to check assignment
            for (Trip trip : allTrips) {
                if (trip.getDriverVehicleId() != null && !trip.getDriverVehicleId().isEmpty()) {
                    assignedTrips++;
                } else {
                    pendingTrips++;
                }
            }
            
            int totalDrivers = driverDAO.getAllDrivers().size();
            int totalVehicles = vehicleDAO.getAllVehicles().size();
            
            // Get most recent trips - using limited number from all trips
            List<Trip> recentTrips = allTrips.size() > 5 ? allTrips.subList(0, 5) : allTrips;
        %>
        
        <!-- Dashboard Cards -->
        <div class="transport-dashboard animate-fade">
            <div class="dashboard-card">
                <i class="fas fa-route"></i>
                <h3><%= pendingTrips %></h3>
                <p>Pending Trip Assignments</p>
                <a href="assignResources.jsp" class="btn btn-sm">Assign Resources</a>
            </div>
            
            <div class="dashboard-card">
                <i class="fas fa-bus"></i>
                <h3><%= totalVehicles %></h3>
                <p>Available Vehicles</p>
                <a href="manageVehicles.jsp" class="btn btn-sm">Manage Vehicles</a>
            </div>
            
            <div class="dashboard-card">
                <i class="fas fa-id-card"></i>
                <h3><%= totalDrivers %></h3>
                <p>Registered Drivers</p>
                <a href="manageDrivers.jsp" class="btn btn-sm">Manage Drivers</a>
            </div>
            
            <div class="dashboard-card">
                <i class="fas fa-check-circle"></i>
                <h3><%= assignedTrips %></h3>
                <p>Assigned Trips</p>
                <a href="viewAssignments.jsp" class="btn btn-sm">View Assignments</a>
            </div>
        </div>
        
        <!-- Quick Actions Card -->
        <div class="card mb-5">
            <div class="card-header">
                <h2 class="card-title"><i class="fas fa-bolt mr-2"></i>Quick Actions</h2>
            </div>
            <div class="card-body">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
                    <a href="manageDrivers.jsp" class="quick-action-card bg-blue-500">
                        <i class="fas fa-users"></i>
                        <span>Manage Drivers</span>
                    </a>
                    <a href="manageVehicles.jsp" class="quick-action-card bg-green-500">
                        <i class="fas fa-car"></i>
                        <span>Manage Vehicles</span>
                    </a>
                    <a href="assignResources.jsp" class="quick-action-card bg-purple-500">
                        <i class="fas fa-clipboard-list"></i>
                        <span>Assign Resources</span>
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Recent Trips Section -->
        <div class="card mt-5">
            <div class="card-header">
                <h2 class="card-title"><i class="fas fa-history mr-2"></i>Recent Trip Assignments</h2>
            </div>
            <div class="card-body p-0">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Trip ID</th>
                                <th>Destination</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(recentTrips != null && !recentTrips.isEmpty()) { 
                                for(Trip trip : recentTrips) {
                                    String statusClass = "pending";
                                    String statusText = "Pending";
                                    
                                    if (trip.getDriverVehicleId() != null && !trip.getDriverVehicleId().isEmpty()) {
                                        statusClass = "assigned";
                                        statusText = "Assigned";
                                    }
                            %>
                            <tr>
                                <td><%= trip.getTripId() %></td>
                                <td><%= trip.getDestinationId() != null ? trip.getDestinationId() : "Not specified" %></td>
                                <td><%= trip.getStartDateFormatted() != null ? trip.getStartDateFormatted() : "Not set" %></td>
                                <td><%= trip.getEndDateFormatted() != null ? trip.getEndDateFormatted() : "Not set" %></td>
                                <td><span class="trip-status <%= statusClass %>"><%= statusText %></span></td>
                                <td>
                                    <a href="tripDetails.jsp?id=<%= trip.getTripId() %>" class="btn btn-sm btn-primary">View</a>
                                </td>
                            </tr>
                            <% } } else { %>
                            <tr>
                                <td colspan="6" class="text-center py-4">No recent trips found</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <!-- Quick Links -->
        <div class="card mt-4">
            <div class="card-header">
                <h2 class="card-title"><i class="fas fa-link mr-2"></i>Quick Links</h2>
            </div>
            <div class="card-body">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <a href="assignResources.jsp" class="btn btn-primary w-full">
                        <i class="fas fa-tasks mr-2"></i>Assign Trip Resources
                    </a>
                    
                    <a href="viewAssignments.jsp" class="btn btn-info w-full">
                        <i class="fas fa-clipboard-list mr-2"></i>View All Assignments
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="../includes/footer.jsp" %>
</body>
</html>
