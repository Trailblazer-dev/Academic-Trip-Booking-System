<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.dao.*" %>
<%@ page import="com.academictrip.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.format.*" %>
<%
    // Get trip ID from parameter
    String tripIdParam = request.getParameter("id");
    if (tripIdParam == null) {
        tripIdParam = request.getParameter("tripId"); // Alternative parameter name
    }
    
    Trip trip = null;
    DriverVehicle currentAssignment = null;
    Driver currentDriver = null;
    Vehicle currentVehicle = null;
    
    // Get available drivers and vehicles lists
    DriverDAO driverDAO = new DriverDAO();
    VehicleDAO vehicleDAO = new VehicleDAO();
    
    List<Driver> availableDrivers = new ArrayList<>();
    List<Vehicle> availableVehicles = new ArrayList<>();
    
    // Date formatter for display
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
    // Get success or error messages from session
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    // Clear messages after retrieving
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
    
    if(tripIdParam != null && !tripIdParam.trim().isEmpty()) {
        try {
            TripDAO tripDAO = new TripDAO();
            trip = tripDAO.getTripById(tripIdParam);
            
            if(trip != null) {
                DriverVehicleDAO driverVehicleDAO = new DriverVehicleDAO();
                currentAssignment = driverVehicleDAO.getAssignmentById(trip.getDriverVehicleId());
                
                if(currentAssignment != null) {
                    // Get the currently assigned driver and vehicle
                    if(currentAssignment.getDriverId() != null) {
                        currentDriver = driverDAO.getDriverById(currentAssignment.getDriverId());
                    }
                    
                    if(currentAssignment.getVehicleId() != null) {
                        currentVehicle = vehicleDAO.getVehicleById(currentAssignment.getVehicleId());
                    }
                    
                    // Get all drivers - don't filter by availability
                    availableDrivers = driverDAO.getAllDrivers();
                    
                    // Get all vehicles - don't filter by availability
                    availableVehicles = vehicleDAO.getAllVehicles();
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error retrieving trip details: " + e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Assignment | Academic Trip System</title>
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
                <% if(trip == null || currentAssignment == null) { %>
                    <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i class="fas fa-exclamation-circle text-red-500"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-red-700">
                                    Trip or assignment not found. Please check the ID and try again.
                                </p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="text-center py-8">
                        <i class="fas fa-search text-gray-300 text-4xl mb-4"></i>
                        <p class="text-xl text-gray-400">The requested assignment could not be found</p>
                        <a href="${pageContext.request.contextPath}/transport/viewAssignments.jsp" class="inline-block mt-4 bg-indigo-600 hover:bg-indigo-700 text-white py-2 px-4 rounded-md">
                            View All Assignments
                        </a>
                    </div>
                <% } else { %>
                    <div class="bg-white shadow-xl rounded-lg overflow-hidden">
                        <!-- Header -->
                        <div class="bg-primary px-6 py-4">
                            <h1 class="text-2xl font-bold text-white">
                                <i class="fas fa-edit mr-2"></i>Edit Transport Assignment
                            </h1>
                            <p class="text-blue-100 mt-1">Update driver and vehicle for trip #<%= trip.getTripId() %></p>
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
                        
                        <!-- Trip Info -->
                        <div class="bg-blue-50 border-l-4 border-blue-500 p-4 m-4">
                            <h2 class="text-lg font-semibold text-blue-800">Trip Details</h2>
                            <div class="mt-2 text-blue-700">
                                <p><strong>Trip ID:</strong> <%= trip.getTripId() %></p>
                                <p><strong>Destination:</strong> <%= trip.getDestination() %></p>
                                <p><strong>Dates:</strong> <%= formatter.format(trip.getDepartureDate())%> to <%= formatter.format(trip.getReturnDate()) %></p>
                                <p><strong>Current Assignment:</strong> 
                                    <% if(currentDriver != null && currentVehicle != null) { %>
                                        Driver: <%= currentDriver.getFirstname() %> <%= currentDriver.getLastname() %>, 
                                        Vehicle: <%= currentVehicle.getMake() %> <%= currentVehicle.getModel() %> (<%= currentVehicle.getRegistration() %>)
                                    <% } else { %>
                                        No current assignment
                                    <% } %>
                                </p>
                            </div>
                        </div>
                        
                        <!-- Edit Assignment Form -->
                        <form id="editAssignmentForm" action="${pageContext.request.contextPath}/transport/updateAssignment" method="post" class="p-6">
                            <input type="hidden" name="tripId" value="<%= trip.getTripId() %>">
                            <input type="hidden" name="currentAssignmentId" value="<%= currentAssignment.getAssignmentId() %>">
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <!-- Driver Selection -->
                                <div class="mb-6">
                                    <label for="driverId" class="block text-sm font-medium text-gray-700 mb-1">Select Driver <span class="text-red-500">*</span></label>
                                    <select id="driverId" name="driverId" class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md shadow-sm" required>
                                        <option value="">-- Select a Driver --</option>
                                        <% for (Driver driver : availableDrivers) { 
                                            boolean isCurrentDriver = currentDriver != null && driver.getDriverId().equals(currentDriver.getDriverId());
                                        %>
                                            <option value="<%= driver.getDriverId() %>" <%= isCurrentDriver ? "selected" : "" %>>
                                                <%= driver.getFirstname() %> <%= driver.getLastname() %><%= isCurrentDriver ? " (Current)" : "" %>
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                
                                <!-- Vehicle Selection -->
                                <div class="mb-6">
                                    <label for="vehicleId" class="block text-sm font-medium text-gray-700 mb-1">Select Vehicle <span class="text-red-500">*</span></label>
                                    <select id="vehicleId" name="vehicleId" class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md shadow-sm" required>
                                        <option value="">-- Select a Vehicle --</option>
                                        <% for (Vehicle vehicle : availableVehicles) { 
                                            boolean isCurrentVehicle = currentVehicle != null && vehicle.getVehicleId().equals(currentVehicle.getVehicleId());
                                        %>
                                            <option value="<%= vehicle.getVehicleId() %>" <%= isCurrentVehicle ? "selected" : "" %>>
                                                <%= vehicle.getMake() %> <%= vehicle.getModel() %> (<%= vehicle.getRegistration() %>)<%= isCurrentVehicle ? " (Current)" : "" %>
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
                                           value="<%= formatter.format(trip.getDepartureDate()) %>"
                                           class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                                </div>
                                <div>
                                    <label for="assignmentEnd" class="block text-sm font-medium text-gray-700 mb-1">Assignment End Date</label>
                                    <input type="date" id="assignmentEnd" name="assignmentEnd" 
                                           value="<%= formatter.format(trip.getReturnDate()) %>"
                                           class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                                </div>
                            </div>
                            
                            <!-- Additional Notes -->
                            <div class="mb-6">
                                <label for="notes" class="block text-sm font-medium text-gray-700 mb-1">Additional Notes</label>
                                <textarea id="notes" name="notes" rows="3" 
                                          class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                          placeholder="Any special instructions or notes about this assignment"></textarea>
                            </div>
                            
                            <!-- Buttons -->
                            <div class="flex justify-between mt-8">
                                <a href="${pageContext.request.contextPath}/transport/tripDetails.jsp?id=<%= trip.getTripId() %>" 
                                   class="bg-gray-500 hover:bg-gray-600 text-white py-2 px-4 rounded-md inline-flex items-center transition-colors">
                                    <i class="fas fa-arrow-left mr-2"></i> Back to Trip Details
                                </a>
                                <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white py-2 px-6 rounded-md inline-flex items-center transition-colors">
                                    <i class="fas fa-save mr-2"></i> Update Assignment
                                </button>
                            </div>
                        </form>
                    </div>
                <% } %>
            </div>
        </div>
        
        <footer>
            <div class="footer-content">
                <p>&copy; 2023 Academic Trip System. All rights reserved.</p>
                <p class="mt-2 text-sm text-gray-300">Transport Management Module</p>
            </div>
        </footer>
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
            
            // Form validation
            document.getElementById('editAssignmentForm').addEventListener('submit', function(e) {
                const driverId = document.getElementById('driverId').value;
                const vehicleId = document.getElementById('vehicleId').value;
                
                if (!driverId || !vehicleId) {
                    e.preventDefault();
                    alert('Please select both a driver and vehicle.');
                }
            });
        });
    </script>
</body>
</html>
