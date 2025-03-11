<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.dao.*" %>
<%@ page import="com.academictrip.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.format.*" %>
<% 
    // Remove duplicate declarations of pageName and currentUser
    // They are already declared in transportHeader.jsp
    
    // Get trip ID from request parameter if available
    String tripId = request.getParameter("tripId");
    // Fetch lists of available drivers and vehicles
    List<Driver> drivers = new DriverDAO().getAllAvailableDrivers();
    List<Vehicle> vehicles = new VehicleDAO().getAllAvailableVehicles();
    // Get trip details if tripId is provided
    Trip selectedTrip = null;
    if (tripId != null && !tripId.isEmpty()) {
        selectedTrip = new TripDAO().getTripById(tripId);
    }
    // Get success or error messages from session
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    // Clear messages after retrieving
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM d, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Resources | Academic Trip System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">
    <div class="page-wrapper">
        <!-- Include standardized header -->
        <jsp:include page="../includes/transportHeader.jsp" />
        
        <div class="main-content">
            <div class="max-w-4xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
                <div class="bg-white shadow-xl rounded-lg overflow-hidden">
                    <!-- Header -->
                    <div class="bg-primary px-6 py-4">
                        <h1 class="text-2xl font-bold text-white">
                            <i class="fas fa-tasks mr-2"></i>Assign Transport Resources
                        </h1>
                        <p class="text-blue-100 mt-1">Assign drivers and vehicles to academic trips</p>
                    </div>
                    <!-- Alert Messages -->
                    <% if (successMessage != null && !successMessage.isEmpty()) { %> 
                        <div class="bg-green-50 border-l-4 border-green-500 p-4 m-4" id="successAlert">
                            <div class="flex">
                                <div class="flex-shrink-0">
                                    <i class="fas fa-check-circle text-green-500"></i>
                                </div>
                                <div class="ml-3">
                                    <p class="text-green-700"><%= successMessage %></p>
                                </div>
                                <div class="ml-auto">
                                    <button onclick="document.getElementById('successAlert').style.display='none'" class="text-green-500">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    <% } %>
                    <% if (errorMessage != null && !errorMessage.isEmpty()) { %> 
                        <div class="bg-red-50 border-l-4 border-red-500 p-4 m-4" id="errorAlert">
                            <div class="flex">
                                <div class="flex-shrink-0">
                                    <i class="fas fa-exclamation-circle text-red-500"></i>
                                </div>
                                <div class="ml-3">
                                    <p class="text-red-700"><%= errorMessage %></p>
                                </div>
                                <div class="ml-auto">
                                    <button onclick="document.getElementById('errorAlert').style.display='none'" class="text-red-500">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    <% } %>
                    <!-- Trip Info (if selected) -->
                    <% if (selectedTrip != null) { %>
                        <div class="bg-blue-50 border-l-4 border-blue-500 p-4 m-4">
                            <h2 class="text-lg font-semibold text-blue-800">Trip Details</h2>
                            <div class="mt-2 text-blue-700"> <%= selectedTrip.getTripId() %>
                                <p><strong>Trip ID:</strong> <%= selectedTrip.getTripId() %></p>
                                <p><strong>Destination:</strong> <%= selectedTrip.getDestination() %></p>
                                <p><strong>Dates:</strong> <%= formatter.format(selectedTrip.getDepartureDate())%> to <%= formatter.format(selectedTrip.getReturnDate()) %></p>
                                <p><strong>Purpose:</strong> <%= selectedTrip.getPurpose() %></p>
                            </div>
                        </div>
                    <% } %>
                    <!-- Assignment Form -->
                    <form id="assignmentForm" action="${pageContext.request.contextPath}/transport/assignResources" method="post" class="p-6">
                        <!-- Trip Selection -->
                        <div class="mb-6">
                            <label for="tripId" class="block text-sm font-medium text-gray-700 mb-1">Select Trip <span class="text-red-500">*</span></label>
                            <select id="tripId" name="tripId" class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md shadow-sm" 
                                   required <%= selectedTrip != null ? "readonly" : "" %>>
                                <option value="" <%= selectedTrip == null ? "selected" : "" %>>-- Select a Trip --</option>
                                <% 
                                    List<Trip> trips = new TripDAO().getAllUnassignedTrips();
                                    for (Trip trip : trips) {
                                        boolean isSelected = selectedTrip != null && trip.getTripId().equals(selectedTrip.getTripId());
                                %>  
                                    <option value="<%= trip.getTripId() %>" <%= isSelected ? "selected" : "" %>>
                                        <%= trip.getTripId() %> - <%= trip.getDestination() %> 
                                        (<%= formatter.format(trip.getDepartureDate()) %>)
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <!-- Driver Selection -->
                            <div class="mb-6">
                                <label for="driverId" class="block text-sm font-medium text-gray-700 mb-1">Select Driver <span class="text-red-500">*</span></label>
                                <select id="driverId" name="driverId" class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md shadow-sm" required>
                                    <option value="">-- Select a Driver --</option>
                                    <% for (Driver driver : drivers) { %>
                                        <option value="<%= driver.getDriverId() %>"><%= driver.getFirstname() %> <%= driver.getLastname() %></option>
                                    <% } %>
                                </select>
                            </div>
                            <!-- Vehicle Selection -->
                            <div class="mb-6">
                                <label for="vehicleId" class="block text-sm font-medium text-gray-700 mb-1">Select Vehicle <span class="text-red-500">*</span></label>
                                <select id="vehicleId" name="vehicleId" class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md shadow-sm" required>
                                    <option value="">-- Select a Vehicle --</option>
                                    <% for (Vehicle vehicle : vehicles) { %>
                                        <option value="<%= vehicle.getVehicleId() %>">
                                            <%= vehicle.getMake() %> <%= vehicle.getModel() %> (<%= vehicle.getRegistration() %>)
                                        </option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        <!-- Assignment Dates -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                            <div>
                                <label for="assignmentStart" class="block text-sm font-medium text-gray-700 mb-1">Assignment Start Date</label>
                                <input type="date" id="assignmentStart" name="assignmentStart" 
                                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                            </div>
                            <div>
                                <label for="assignmentEnd" class="block text-sm font-medium text-gray-700 mb-1">Assignment End Date</label>
                                <input type="date" id="assignmentEnd" name="assignmentEnd" 
                                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                            </div>
                        </div>
                        <!-- Buttons -->
                        <div class="flex justify-between mt-8">
                            <a href="${pageContext.request.contextPath}/transport/viewAssignments.jsp" 
                               class="bg-gray-500 hover:bg-gray-600 text-white py-2 px-4 rounded-md inline-flex items-center transition-colors">
                                <i class="fas fa-arrow-left mr-2"></i> Back to Assignments
                            </a>
                            <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white py-2 px-6 rounded-md inline-flex items-center transition-colors">
                                <i class="fas fa-save mr-2"></i> Assign Resources
                            </button>
                        </div>
                    </form>
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

    <!-- Your existing JavaScript code -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Set default dates based on trip selectiontripId');
            const tripSelect = document.getElementById('tripId');
            const assignmentStart = document.getElementById('assignmentStart');
            const assignmentEnd = document.getElementById('assignmentEnd');
            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                const alerts = document.querySelectorAll('#successAlert, #errorAlert');
                alerts.forEach(alert => {
                    if (alert) alert.style.display = 'none';
                });
            }, 5000);
            // Form validation
            document.getElementById('assignmentForm').addEventListener('submit', function(e) {
                if (!tripSelect.value || !document.getElementById('driverId').value || !document.getElementById('vehicleId').value) {
                    e.preventDefault();in all required fields');
                    alert('Please fill in all required fields');
                }
            });
        });
    </script>
</body>
</html>