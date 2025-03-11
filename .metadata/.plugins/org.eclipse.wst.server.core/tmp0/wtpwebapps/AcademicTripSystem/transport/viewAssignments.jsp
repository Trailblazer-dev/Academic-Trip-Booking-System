<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.dao.*" %>
<%@ page import="com.academictrip.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.format.*" %>
<%@ page import="java.time.LocalDate" %>
<%
    // Get list of all trips first
    TripDAO tripDAO = new TripDAO();
    List<Trip> allTrips = tripDAO.getAllTrips();
    
    // Filter to only include trips that have driver-vehicle assignments
    List<Trip> assignedTrips = new ArrayList<>();
    for (Trip trip : allTrips) {
        if (trip.getDriverVehicleId() != null && !trip.getDriverVehicleId().isEmpty()) {
            assignedTrips.add(trip);
        }
    }
    
    // Get driver-vehicle assignments
    DriverVehicleDAO dvDAO = new DriverVehicleDAO();
    
    // Create a map of driver IDs to Driver objects for quick lookup
    DriverDAO driverDAO = new DriverDAO();
    Map<String, Driver> driverMap = new HashMap<>();
    List<Driver> allDrivers = driverDAO.getAllDrivers();
    for (Driver driver : allDrivers) {
        driverMap.put(driver.getDriverId(), driver);
    }
    
    // Create a map of vehicle IDs to Vehicle objects for quick lookup
    VehicleDAO vehicleDAO = new VehicleDAO();
    Map<String, Vehicle> vehicleMap = new HashMap<>();
    List<Vehicle> allVehicles = vehicleDAO.getAllVehicles();
    for (Vehicle vehicle : allVehicles) {
        vehicleMap.put(vehicle.getVehicleId(), vehicle);
    }
    
    // Format dates nicely
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM d, yyyy");
    
    // Get messages from session
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    
    // Clear messages after retrieving
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Assignments | Academic Trip System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">
    <div class="page-wrapper">
        <!-- Include standardized header -->
        <jsp:include page="../includes/transportHeader.jsp" />
        
        <div class="main-content">
            <div class="container mx-auto px-4 py-8">
                <!-- Page header -->
                <div class="md:flex md:items-center md:justify-between mb-8">
                    <div class="flex-1 min-w-0">
                        <h1 class="text-3xl font-bold text-gray-900">
                            <i class="fas fa-clipboard-list mr-2 text-secondary"></i>View Assignments
                        </h1>
                        <p class="mt-1 text-sm text-gray-500">
                            Manage all driver and vehicle assignments for academic trips
                        </p>
                    </div>
                    <div class="mt-4 md:mt-0 flex">
                        <a href="${pageContext.request.contextPath}/transport/assignResources.jsp" 
                           class="btn btn-secondary hover:bg-orange-700 text-white py-2 px-4 rounded-lg flex items-center">
                            <i class="fas fa-plus-circle mr-2"></i> New Assignment
                        </a>
                    </div>
                </div>
                
                <!-- Filter & Search -->
                <div class="bg-white p-4 rounded-lg shadow mb-6">
                    <div class="flex flex-col md:flex-row justify-between items-center gap-4">
                        <div class="relative w-full md:w-64">
                            <input type="text" id="assignmentSearch" placeholder="Search assignments..." 
                                   class="w-full pl-10 pr-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-400">
                            <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                        </div>
                        <div class="flex flex-wrap gap-4">
                            <select id="filterStatus" class="rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400">
                                <option value="all">All Status</option>
                                <option value="upcoming">Upcoming</option>
                                <option value="ongoing">Ongoing</option>
                                <option value="completed">Completed</option>
                            </select>
                            <button id="refreshBtn" class="bg-gray-200 hover:bg-gray-300 text-gray-700 py-2 px-4 rounded-lg">
                                <i class="fas fa-sync-alt mr-2"></i> Refresh
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Assignments List -->
                <div class="bg-white shadow-md rounded-lg overflow-hidden">
                    <div class="overflow-x-auto">
                        <table id="assignmentsTable" class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-100">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Trip ID</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Destination</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Travel Dates</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Driver</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Vehicle</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <% 
                                if (assignedTrips != null && !assignedTrips.isEmpty()) {
                                    for (Trip trip : assignedTrips) {
                                        // Get the related driver-vehicle assignment
                                        DriverVehicle dv = dvDAO.getAssignmentById(trip.getDriverVehicleId());
                                        if (dv == null) continue;
                                        
                                        // Get Driver and Vehicle details
                                        Driver driver = driverMap.get(dv.getDriverId());
                                        Vehicle vehicle = vehicleMap.get(dv.getVehicleId());
                                        if (driver == null || vehicle == null) continue;
                                        
                                        // Determine status based on dates
                                        String status;
                                        LocalDate today = LocalDate.now();
                                        
                                        if (today.isBefore(trip.getDepartureDate())) {
                                            status = "upcoming";
                                        } else if (today.isAfter(trip.getReturnDate())) {
                                            status = "completed";
                                        } else {
                                            status = "ongoing";
                                        }
                                %>
                                <tr class="hover:bg-gray-50 transition" data-status="<%= status %>">
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        <%= trip.getTripId() %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                        <%= trip.getDestination() %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                        <%= formatter.format(trip.getDepartureDate()) %> - <%= formatter.format(trip.getReturnDate()) %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-8 w-8 bg-blue-100 rounded-full flex items-center justify-center">
                                                <i class="fas fa-user text-blue-500"></i>
                                            </div>
                                            <div class="ml-3">
                                                <div class="text-sm font-medium text-gray-900">
                                                    <%= driver.getFirstname() %> <%= driver.getLastname() %>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-8 w-8 bg-indigo-100 rounded-full flex items-center justify-center">
                                                <i class="fas fa-bus text-indigo-500"></i>
                                            </div>
                                            <div class="ml-3">
                                                <div class="text-sm font-medium text-gray-900">
                                                    <%= vehicle.getMake() %> <%= vehicle.getModel() %>
                                                </div>
                                                <div class="text-xs text-gray-500">
                                                    <%= vehicle.getRegistration() %> | <%= vehicle.getCapacity() %> seats
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <% if (status.equals("upcoming")) { %>
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                                                Upcoming
                                            </span>
                                        <% } else if (status.equals("ongoing")) { %>
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                Ongoing
                                            </span>
                                        <% } else { %>
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">
                                                Completed
                                            </span>
                                        <% } %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                        <div class="flex space-x-2">
                                            <a href="${pageContext.request.contextPath}/transport/tripDetails.jsp?id=<%= trip.getTripId() %>" 
                                               class="text-indigo-600 hover:text-indigo-900" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <% if (status.equals("upcoming")) { %>
                                                <a href="${pageContext.request.contextPath}/transport/editAssignment.jsp?tripId=<%= trip.getTripId() %>" 
                                                   class="text-blue-600 hover:text-blue-900" title="Edit Assignment">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <button onclick="confirmUnassign('<%= trip.getTripId() %>', '<%= trip.getDestination() %>')" 
                                                        class="text-red-600 hover:text-red-900" title="Remove Assignment">
                                                    <i class="fas fa-unlink"></i>
                                                </button>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                                <% 
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="7" class="px-6 py-4 text-center text-sm text-gray-500">
                                        No assignments found. <a href="${pageContext.request.contextPath}/transport/assignResources.jsp" class="text-indigo-600 hover:underline">Create one now</a>.
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Stats Cards -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mt-8">
                    <div class="bg-white rounded-lg shadow-md p-6 border-t-4 border-blue-500">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-blue-100 mr-4">
                                <i class="fas fa-clipboard-list text-xl text-blue-500"></i>
                            </div>
                            <div>
                                <h3 class="text-lg font-semibold text-gray-700">Total Assignments</h3>
                                <p class="text-2xl font-bold text-gray-800"><%= assignedTrips.size() %></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white rounded-lg shadow-md p-6 border-t-4 border-green-500">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-green-100 mr-4">
                                <i class="fas fa-road text-xl text-green-500"></i>
                            </div>
                            <div>
                                <h3 class="text-lg font-semibold text-gray-700">Active Trips</h3>
                                <% 
                                    int activeCount = 0;
                                    for (Trip trip : assignedTrips) {
                                        LocalDate today = LocalDate.now();
                                        if (!today.isBefore(trip.getDepartureDate()) && 
                                            !today.isAfter(trip.getReturnDate())) {
                                            activeCount++;
                                        }
                                    }
                                %>
                                <p class="text-2xl font-bold text-gray-800"><%= activeCount %></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white rounded-lg shadow-md p-6 border-t-4 border-purple-500">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-purple-100 mr-4">
                                <i class="fas fa-calendar-alt text-xl text-purple-500"></i>
                            </div>
                            <div>
                                <h3 class="text-lg font-semibold text-gray-700">Upcoming Trips</h3>
                                <% 
                                    int upcomingCount = 0;
                                    for (Trip trip : assignedTrips) {
                                        LocalDate today = LocalDate.now();
                                        if (today.isBefore(trip.getDepartureDate())) {
                                            upcomingCount++;
                                        }
                                    }
                                %>
                                <p class="text-2xl font-bold text-gray-800"><%= upcomingCount %></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <footer>
            <div class="footer-content">
                <p>&copy; 2023 Academic Trip System. All rights reserved.</p>
                <p class="mt-2 text-sm text-gray-300">Transport Management Module</p>
            </div>
        </footer>
    </div>
    
    <!-- Unassign Confirmation Modal -->
    <div id="unassignModal" class="fixed z-10 inset-0 overflow-y-auto hidden">
        <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center">
            <div class="fixed inset-0 transition-opacity" aria-hidden="true">
                <div class="absolute inset-0 bg-gray-500 opacity-75" onclick="closeModal('unassignModal')"></div>
            </div>
            <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                    <div class="sm:flex sm:items-start">
                        <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                            <i class="fas fa-exclamation-triangle text-red-600"></i>
                        </div>
                        <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                            <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
                                Remove Assignment
                            </h3>
                            <div class="mt-2">
                                <p class="text-sm text-gray-500" id="unassignConfirmationText">
                                    Are you sure you want to remove this assignment? This will free up the driver and vehicle for other trips.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <form id="unassignForm" action="${pageContext.request.contextPath}/transport/unassignResources" method="post">
                    <input type="hidden" id="unassignTripId" name="tripId">
                    <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                        <button type="submit" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm">
                            Remove Assignment
                        </button>
                        <button type="button" onclick="closeModal('unassignModal')" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                            Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                const alerts = document.querySelectorAll('#successAlert, #errorAlert');
                alerts.forEach(alert => {
                    if (alert) alert.style.display = 'none';
                });
            }, 5000);
            
            // Filter functionality
            const filterStatus = document.getElementById('filterStatus');
            filterStatus.addEventListener('change', function() {
                const value = this.value;
                const rows = document.querySelectorAll('#assignmentsTable tbody tr[data-status]');
                
                rows.forEach(row => {
                    if (value === 'all' || row.getAttribute('data-status') === value) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
            
            // Search functionality
            document.getElementById('assignmentSearch').addEventListener('keyup', function() {
                const searchValue = this.value.toLowerCase();
                const rows = document.querySelectorAll('#assignmentsTable tbody tr');
                
                rows.forEach(row => {
                    const text = row.textContent.toLowerCase();
                    if (text.includes(searchValue)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
            
            // Refresh button
            document.getElementById('refreshBtn').addEventListener('click', function() {
                location.reload();
            });
        });
        
        function confirmUnassign(tripId, destination) {
            document.getElementById('unassignTripId').value = tripId;
            document.getElementById('unassignConfirmationText').textContent = 
                `Are you sure you want to remove the assignment for trip to ${destination}? This will free up the driver and vehicle for other trips.`;
            document.getElementById('unassignModal').classList.remove('hidden');
        }
        
        function closeModal(modalId) {
            document.getElementById(modalId).classList.add('hidden');
        }
    </script>
</body>
</html>
