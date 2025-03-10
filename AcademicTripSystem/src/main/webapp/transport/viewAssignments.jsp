<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.academictrip.dao.TripDAO, com.academictrip.model.Trip" %>
<%@ page import="com.academictrip.dao.DriverVehicleDAO, com.academictrip.model.DriverVehicle" %>
<%@ page import="com.academictrip.dao.DriverDAO, com.academictrip.model.Driver" %>
<%@ page import="com.academictrip.dao.VehicleDAO, com.academictrip.model.Vehicle" %>
<%@ page import="java.util.List, java.util.Map, java.util.HashMap" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.academictrip.model.User" %>
<%@ page import="com.academictrip.dao.*" %>
<%@ page import="com.academictrip.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.format.*" %>
<%
    // Remove duplicate declarations of pageName and currentUser
    // They are already declared in transportHeader.jsp
    
    // Get filter parameters
    String statusFilter = request.getParameter("status");
    String destinationFilter = request.getParameter("destination");
    String startDateParam = request.getParameter("startDate");
    String endDateParam = request.getParameter("endDate");
    
    // CRITICAL FIX: Initialize the lists directly to avoid method ambiguity 
    List<Trip> trips = new ArrayList<>();
    List<Trip> assignedTrips = new ArrayList<>();
    
    // FIXED: Move tripDAO declaration outside of try block so it's accessible later
    TripDAO tripDAO = new TripDAO();
    
    try {
        // Get assignments data with filters
        
        // Only filter by destination since we'll handle status filtering client-side
        if (destinationFilter != null && !destinationFilter.isEmpty()) {
            trips = tripDAO.getTripsWithAssignmentsByFilters(null, destinationFilter);
        } else {
            // Default to all trips if no filters
            trips = tripDAO.getAllTrips();
        }
        
        // Only execute date filtering if date params are provided
        if (startDateParam != null && !startDateParam.isEmpty() || 
            endDateParam != null && !endDateParam.isEmpty()) {
            assignedTrips = tripDAO.getTripsWithAssignmentsByDate(startDateParam, endDateParam);
        }
    } catch (Exception e) {
        // Log the error to help with debugging
        e.printStackTrace();
        // Set an attribute so we can display it in the page if needed
        request.setAttribute("error", e.getMessage());
    }
    
    // Prepare DAOs for additional data
    DriverVehicleDAO dvDAO = new DriverVehicleDAO();
    DriverDAO driverDAO = new DriverDAO();
    VehicleDAO vehicleDAO = new VehicleDAO();
    
    // Cache for driver-vehicle assignments
    Map<String, DriverVehicle> assignmentCache = new HashMap<>();
    Map<String, Driver> driverCache = new HashMap<>();
    Map<String, Vehicle> vehicleCache = new HashMap<>();
    
    // Date formatter
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM d, yyyy");
    
    // Now tripDAO is accessible outside the try block
    List<String> destinations = tripDAO.getUniqueDestinations();
%>
<!DOCTYPE html>
<html lang="en" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Assignments | Academic Trip System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex flex-col h-full bg-gray-50">
    <!-- Include header -->
    <%@ include file="../includes/transportHeader.jsp" %>

    <div class="flex-grow container mx-auto px-4 sm:px-8 py-8">
        <div class="mb-8">
            <h1 class="text-2xl font-bold text-gray-900">Transport Assignments</h1>
            <p class="mt-2 text-gray-600">View and manage all vehicle and driver assignments for academic trips.</p>
        </div>
        
        <!-- Filters -->
        <div class="bg-white p-4 rounded-lg shadow mb-6">
            <form action="viewAssignments.jsp" method="get" class="md:flex md:items-end space-y-4 md:space-y-0 md:space-x-4">
                <div class="flex-1">
                    <label for="destination" class="block text-sm font-medium text-gray-700 mb-1">Destination</label>
                    <select id="destination" name="destination" class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                        <option value="">All Destinations</option>
                        <% if (destinations != null) {
                            for (String destination : destinations) {
                                if (destination != null && !destination.isEmpty()) { %>
                                    <option value="<%= destination %>" <%= (destination.equals(destinationFilter)) ? "selected" : "" %>><%= destination %></option>
                        <%      }
                            }
                        } %>
                    </select>
                </div>
                
                <!-- Keep the status filter for UI consistency but it won't be used in DB queries -->
                <div class="flex-1">
                    <label for="status" class="block text-sm font-medium text-gray-700 mb-1">Assignment Status</label>
                    <select id="status" name="status" class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                        <option value="">Any Status</option>
                        <option value="assigned" <%= "assigned".equals(statusFilter) ? "selected" : "" %>>Assigned</option>
                        <option value="unassigned" <%= "unassigned".equals(statusFilter) ? "selected" : "" %>>Unassigned</option>
                        <option value="completed" <%= "completed".equals(statusFilter) ? "selected" : "" %>>Completed</option>
                    </select>
                </div>
                
                <div class="flex-none">
                    <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-2 px-4 rounded inline-flex items-center">
                        <i class="fas fa-filter mr-2"></i> Filter
                    </button>
                    <a href="viewAssignments.jsp" class="ml-2 bg-gray-200 hover:bg-gray-300 text-gray-800 font-medium py-2 px-4 rounded inline-flex items-center">
                        <i class="fas fa-times mr-2"></i> Clear
                    </a>
                </div>
            </form>
        </div>
        
        <!-- Assignments Table -->
        <div class="bg-white shadow overflow-hidden sm:rounded-lg">
            <div class="bg-indigo-700 px-4 py-3 sm:px-6">
                <h2 class="text-lg leading-6 font-medium text-white">Trip Assignments</h2>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Trip</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Destination</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Trip Dates</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Driver</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Vehicle</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <% if (trips != null && !trips.isEmpty()) {
                               for (Trip trip : trips) {
                                   String driverVehicleId = trip.getDriverVehicleId();
                                   DriverVehicle assignment = null;
                                   Driver driver = null;
                                   Vehicle vehicle = null;
                                   
                                   // Get assignment details if assigned
                                   if (driverVehicleId != null && !driverVehicleId.isEmpty()) {
                                       if (assignmentCache.containsKey(driverVehicleId)) {
                                           assignment = assignmentCache.get(driverVehicleId);
                                       } else {
                                           assignment = dvDAO.getAssignmentById(driverVehicleId);
                                           if (assignment != null) {
                                               assignmentCache.put(driverVehicleId, assignment);
                                           }
                                       }
                                       
                                       // Get driver details
                                       if (assignment != null && assignment.getDriverId() != null) {
                                           String driverId = assignment.getDriverId();
                                           if (driverCache.containsKey(driverId)) {
                                               driver = driverCache.get(driverId);
                                           } else {
                                               driver = driverDAO.getDriverById(driverId);
                                               if (driver != null) {
                                                   driverCache.put(driverId, driver);
                                               }
                                           }
                                       }
                                       
                                       // Get vehicle details
                                       if (assignment != null && assignment.getVehicleId() != null) {
                                           String vehicleId = assignment.getVehicleId();
                                           if (vehicleCache.containsKey(vehicleId)) {
                                               vehicle = vehicleCache.get(vehicleId);
                                           } else {
                                               vehicle = vehicleDAO.getVehicleById(vehicleId);
                                               if (vehicle != null) {
                                                   vehicleCache.put(vehicleId, vehicle);
                                               }
                                           }
                                       }
                                   }
                                   
                                   // Determine trip status
                                   String status = (driverVehicleId == null || driverVehicleId.isEmpty()) ? "unassigned" : "assigned";
                                   if (trip.isCompleted()) status = "completed";
                        %>
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                <div class="flex items-center">
                                    <div class="flex-shrink-0 h-8 w-8 flex items-center justify-center rounded-full <%= status.equals("unassigned") ? "bg-yellow-100" : (status.equals("completed") ? "bg-green-100" : "bg-blue-100") %>">
                                        <i class="fas <%= status.equals("unassigned") ? "fa-exclamation" : (status.equals("completed") ? "fa-check" : "fa-bus-alt") %> text-sm <%= status.equals("unassigned") ? "text-yellow-600" : (status.equals("completed") ? "text-green-600" : "text-blue-600") %>"></i>
                                    </div>
                                    <div class="ml-3">
                                        <%= trip.getTripId() %>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                <%= trip.getDestination() %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                <%= formatter.format(trip.getDepartureDate()) %> to <%= formatter.format(trip.getReturnDate()) %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                <% if (driver != null) { %>
                                    <div class="flex items-center">
                                        <i class="fas fa-user-tie text-gray-400 mr-2"></i>
                                        <%= driver.getFullName() %>
                                    </div>
                                <% } else { %>
                                    <span class="text-gray-400">Not assigned</span>
                                <% } %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                <% if (vehicle != null) { %>
                                    <div class="flex items-center">
                                        <i class="fas fa-car text-gray-400 mr-2"></i>
                                        <%= vehicle.getMake() %> <%= vehicle.getModel() %> (<%= vehicle.getRegistration() %>)
                                    </div>
                                <% } else { %>
                                    <span class="text-gray-400">Not assigned</span>
                                <% } %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <% if (status.equals("unassigned")) { %>
                                    <span class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">Unassigned</span>
                                <% } else if (status.equals("completed")) { %>
                                    <span class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Completed</span>
                                <% } else { %>
                                    <span class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">Assigned</span>
                                <% } %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                <a href="tripDetails.jsp?id=<%= trip.getTripId() %>" class="text-indigo-600 hover:text-indigo-900 mr-3" title="View Details">
                                    <i class="fas fa-eye"></i>
                                </a>
                                
                                <% if (status.equals("unassigned")) { %>
                                    <a href="assignResources.jsp?tripId=<%= trip.getTripId() %>" class="text-green-600 hover:text-green-900 mr-3" title="Assign Resources">
                                        <i class="fas fa-plus-circle"></i>
                                    </a>
                                <% } else if (!status.equals("completed")) { %>
                                    <a href="editAssignment.jsp?id=<%= trip.getTripId() %>" class="text-blue-600 hover:text-blue-900 mr-3" title="Edit Assignment">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                <% } %>
                            </td>
                        </tr>
                        <% }
                           } else { %>
                        <tr>
                            <td colspan="7" class="px-6 py-4 text-center text-sm text-gray-500">
                                <div class="py-8">
                                    <div class="text-center">
                                        <i class="fas fa-search text-4xl text-gray-300 mb-3"></i>
                                        <p class="text-gray-500 mb-1">No assignments found matching your criteria.</p>
                                        <p class="text-sm text-gray-400">Try changing your filter settings or create a new assignment.</p>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <!-- Pagination (if needed in the future) -->
            <div class="bg-white px-4 py-3 border-t border-gray-200 sm:px-6">
                <div class="flex items-center justify-between">
                    <div class="flex-1 flex justify-between sm:hidden">
                        <a href="#" class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                            Previous
                        </a>
                        <a href="#" class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                            Next
                        </a>
                    </div>
                    <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                        <div>
                            <p class="text-sm text-gray-700">
                                Showing
                                <span class="font-medium"><%= trips != null ? trips.size() : 0 %></span>
                                results
                            </p>
                        </div>
                        <!-- Page numbers would go here -->
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="mt-6 flex justify-center">
            <a href="assignResources.jsp" class="bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-2 px-4 rounded-lg inline-flex items-center shadow-md transition-all">
                <i class="fas fa-plus-circle mr-2"></i> Create New Assignment
            </a>
            <a href="dashboard.jsp" class="ml-4 bg-gray-600 hover:bg-gray-700 text-white font-medium py-2 px-4 rounded-lg inline-flex items-center shadow-md transition-all">
                <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
            </a>
        </div>
    </div>
    
    <!-- Include footer -->
    <%@ include file="../includes/footer.jsp" %>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Add any client-side JavaScript functionality here
            const destinationFilter = document.getElementById('destination');
            const statusFilter = document.getElementById('status');
            
            // Quick filter application
            destinationFilter.addEventListener('change', function() {
                if (this.value !== '') {
                    document.querySelector('form').submit();
                }
            });
            
            statusFilter.addEventListener('change', function() {
                // Apply client-side filtering for status
                filterTripsByStatus(this.value);
            });
            
            // Apply initial status filter if needed
            const initialStatus = statusFilter.value;
            if (initialStatus) {
                filterTripsByStatus(initialStatus);
            }
            
            // Function to filter trips by status without page reload
            function filterTripsByStatus(status) {
                const rows = document.querySelectorAll('table tbody tr');
                if (!status) {
                    // Show all rows if no status selected
                    rows.forEach(row => row.style.display = '');
                    return;
                }
                
                rows.forEach(row => {
                    const statusCell = row.querySelector('td:nth-child(6)');
                    if (statusCell) {
                        const statusText = statusCell.textContent.toLowerCase().trim();
                        if (statusText.includes(status)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    }
                });
                
                // Update the count in pagination
                updateResultCount();
            }
            
            // Update the result count in pagination
            function updateResultCount() {
                const visibleRows = document.querySelectorAll('table tbody tr:not([style*="display: none"])').length;
                const countSpan = document.querySelector('.text-gray-700 .font-medium');
                if (countSpan) {
                    countSpan.textContent = visibleRows;
                }
            }
        });
    </script>
</body>
</html>
