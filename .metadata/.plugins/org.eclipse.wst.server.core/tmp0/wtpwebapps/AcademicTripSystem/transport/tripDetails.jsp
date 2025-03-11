<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.dao.*" %>
<%@ page import="com.academictrip.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.format.*" %>
<%@ page import="java.time.LocalDate" %>
<%
    // Get trip ID from request parameter
    String tripIdParam = request.getParameter("id");
    
    // Initialize objects
    Trip trip = null;
    DriverVehicle assignment = null;
    Driver driver = null;
    Vehicle vehicle = null;
    Destination destination = null;
    InchargeGroup inchargeGroup = null;
    Incharge incharge = null;
    TripGroup tripGroup = null;
    Course course = null;
    
    // Format dates nicely
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM d, yyyy");
    
    if(tripIdParam != null && !tripIdParam.trim().isEmpty()) {
        try {
            TripDAO tripDAO = new TripDAO();
            trip = tripDAO.getTripById(tripIdParam);
            
            if(trip != null) {
                // Get driver-vehicle assignment
                DriverVehicleDAO driverVehicleDAO = new DriverVehicleDAO();
                assignment = driverVehicleDAO.getAssignmentById(trip.getDriverVehicleId());
                
                // Get destination details
                DestinationDAO destinationDAO = new DestinationDAO();
                if(trip.getDestinationId() != null) {
                    destination = destinationDAO.getDestinationById(trip.getDestinationId());
                }
                
                // Get incharge group information
                InchargeGroupDAO inchargeGroupDAO = new InchargeGroupDAO();
                if(trip.getInchargeGroupId() != null) {
                    inchargeGroup = inchargeGroupDAO.getInchargeGroupById(trip.getInchargeGroupId());
                    if(inchargeGroup != null) {
                        InchargeDAO inchargeDAO = new InchargeDAO();
                        incharge = inchargeDAO.getInchargeById(inchargeGroup.getInchargeId());
                    }
                }
                
                // Get trip group and course information
                if(inchargeGroup != null) {
                    TripGroupDAO tripGroupDAO = new TripGroupDAO();
                    tripGroup = tripGroupDAO.getGroupById(inchargeGroup.getGroupId());
                    if(tripGroup != null) {
                        CourseDAO courseDAO = new CourseDAO();
                        course = courseDAO.getCourseById(tripGroup.getCourseId());
                    }
                }
                
                // Get driver and vehicle details if assigned
                if(assignment != null) {
                    DriverDAO driverDAO = new DriverDAO();
                    VehicleDAO vehicleDAO = new VehicleDAO();
                    
                    if(assignment.getDriverId() != null) {
                        driver = driverDAO.getDriverById(assignment.getDriverId());
                    }
                    
                    if(assignment.getVehicleId() != null) {
                        vehicle = vehicleDAO.getVehicleById(assignment.getVehicleId());
                    }
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
    <title>Trip Details | Academic Trip System</title>
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
                <!-- Page header with navigation -->
                <div class="flex items-center space-x-4 mb-8">
                    <a href="${pageContext.request.contextPath}/transport/viewAssignments.jsp" class="text-gray-500 hover:text-indigo-600">
                        <i class="fas fa-arrow-left"></i> Back to Assignments
                    </a>
                    <h1 class="text-3xl font-bold text-gray-900">
                        Trip Details
                    </h1>
                </div>
                
                <% if(trip == null) { %>
                    <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i class="fas fa-exclamation-circle text-red-500"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-red-700">
                                    Trip not found. Please check the ID and try again.
                                </p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="text-center py-8">
                        <i class="fas fa-search text-gray-300 text-4xl mb-4"></i>
                        <p class="text-xl text-gray-400">Trip details could not be found</p>
                        <a href="${pageContext.request.contextPath}/transport/viewAssignments.jsp" class="inline-block mt-4 bg-indigo-600 hover:bg-indigo-700 text-white py-2 px-4 rounded-md">
                            View All Assignments
                        </a>
                    </div>
                <% } else { %>
                    <!-- Trip Status Banner -->
                    <%
                        String statusClass, statusText, statusIcon;
                        LocalDate today = LocalDate.now();
                        if(today.isBefore(trip.getDepartureDate())) {
                            statusClass = "bg-blue-50 border-blue-500 text-blue-800";
                            statusText = "Upcoming Trip";
                            statusIcon = "calendar-alt";
                        } else if(today.isAfter(trip.getReturnDate())) {
                            statusClass = "bg-gray-50 border-gray-500 text-gray-800";
                            statusText = "Completed Trip";
                            statusIcon = "check-circle";
                        } else {
                            statusClass = "bg-green-50 border-green-500 text-green-800";
                            statusText = "Ongoing Trip";
                            statusIcon = "route";
                        }
                    %>
                    <div class="<%= statusClass %> border-l-4 p-4 mb-6 rounded-r-md">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i class="fas fa-<%= statusIcon %>"></i>
                            </div>
                            <div class="ml-3">
                                <p class="font-medium"><%= statusText %></p>
                                <p class="text-sm">ID: <%= trip.getTripId() %></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <!-- Main Trip Information -->
                        <div class="md:col-span-2">
                            <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                                <h2 class="text-xl font-bold mb-4 text-blue-800 border-b pb-2">
                                    <i class="fas fa-info-circle mr-2"></i>Trip Information
                                </h2>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <p class="text-gray-600 font-medium">Trip ID:</p>
                                        <p class="font-semibold"><%= trip.getTripId() %></p>
                                    </div>
                                    <div>
                                        <p class="text-gray-600 font-medium">Trip Status:</p>
                                        <p class="font-semibold"><%= statusText %></p>
                                    </div>
                                    <div>
                                        <p class="text-gray-600 font-medium">Destination:</p>
                                        <p class="font-semibold"><%= destination != null ? destination.getName() : "Not specified" %></p>
                                    </div>
                                    <div>
                                        <p class="text-gray-600 font-medium">Purpose:</p>
                                        <p class="font-semibold"><%= trip.getPurpose() != null ? trip.getPurpose() : "Academic Trip" %></p>
                                    </div>
                                    <div>
                                        <p class="text-gray-600 font-medium">Departure Date:</p>
                                        <p class="font-semibold"><%= formatter.format(trip.getDepartureDate()) %></p>
                                    </div>
                                    <div>
                                        <p class="text-gray-600 font-medium">Return Date:</p>
                                        <p class="font-semibold"><%= formatter.format(trip.getReturnDate()) %></p>
                                    </div>
                                    <div>
                                        <p class="text-gray-600 font-medium">Duration:</p>
                                        <p class="font-semibold">
                                            <%= java.time.temporal.ChronoUnit.DAYS.between(trip.getDepartureDate(), trip.getReturnDate()) + 1 %> days
                                        </p>
                                    </div>
                                    <div>
                                        <p class="text-gray-600 font-medium">Course:</p>
                                        <p class="font-semibold">
                                            <%= course != null ? course.getCourseName() : "Not specified" %>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Incharge Information -->
                            <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                                <h2 class="text-xl font-bold mb-4 text-blue-800 border-b pb-2">
                                    <i class="fas fa-user-tie mr-2"></i>Trip Incharge Details
                                </h2>
                                <% if(incharge != null) { %>
                                    <div class="flex items-center mb-4">
                                        <div class="h-12 w-12 rounded-full bg-blue-100 flex items-center justify-center">
                                            <i class="fas fa-user text-blue-500"></i>
                                        </div>
                                        <div class="ml-4">
                                            <h3 class="text-lg font-semibold"><%= incharge.getFirstName() %> <%= incharge.getLastName() %></h3>
                                            <p class="text-gray-500"><%= incharge.getFacultyId() != null ? "Faculty ID: " + incharge.getFacultyId() : "" %></p>
                                        </div>
                                    </div>
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                                        <div>
                                            <p class="text-gray-600 font-medium">Email:</p>
                                            <p class="font-semibold"><%= incharge.getEmail() %></p>
                                        </div>
                                        <div>
                                            <p class="text-gray-600 font-medium">Phone:</p>
                                            <p class="font-semibold"><%= incharge.getPhoneNumber() %></p>
                                        </div>
                                    </div>
                                <% } else { %>
                                    <p class="text-gray-500">No incharge information available for this trip.</p>
                                <% } %>
                            </div>
                            
                            <!-- Student Group Information -->
                            <div class="bg-white rounded-lg shadow-md p-6">
                                <h2 class="text-xl font-bold mb-4 text-blue-800 border-b pb-2">
                                    <i class="fas fa-users mr-2"></i>Student Group Details
                                </h2>
                                <% if(tripGroup != null) { %>
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div>
                                            <p class="text-gray-600 font-medium">Group Name:</p>
                                            <p class="font-semibold"><%= tripGroup.getGroupName() != null ? tripGroup.getGroupName() : "Group " + tripGroup.getGroupId() %></p>
                                        </div>
                                        <div>
                                            <p class="text-gray-600 font-medium">Number of Students:</p>
                                            <p class="font-semibold"><%= tripGroup.getStudentNumber() %></p>
                                        </div>
                                        <div>
                                            <p class="text-gray-600 font-medium">Course:</p>
                                            <p class="font-semibold"><%= course != null ? course.getCourseName() : "Not specified" %></p>
                                        </div>
                                    </div>
                                <% } else { %>
                                    <p class="text-gray-500">No student group information available for this trip.</p>
                                <% } %>
                            </div>
                        </div>
                        
                        <!-- Transport Assignment Details -->
                        <div class="md:col-span-1">
                            <div class="bg-white rounded-lg shadow-md p-6 mb-6 border-t-4 border-secondary">
                                <h2 class="text-xl font-bold mb-4 text-blue-800 border-b pb-2">
                                    <i class="fas fa-shuttle-van mr-2"></i>Transport Details
                                </h2>
                                
                                <% if(assignment != null && driver != null && vehicle != null) { %>
                                    <!-- Driver Information -->
                                    <div class="mb-6">
                                        <h3 class="text-lg font-semibold text-gray-700 mb-3">Assigned Driver</h3>
                                        <div class="flex items-center mb-4">
                                            <div class="h-12 w-12 rounded-full bg-blue-100 flex items-center justify-center">
                                                <i class="fas fa-user text-blue-500"></i>
                                            </div>
                                            <div class="ml-4">
                                                <h4 class="text-md font-semibold"><%= driver.getFirstname() %> <%= driver.getLastname() %></h4>
                                                <p class="text-sm text-gray-500">Driver ID: <%= driver.getDriverId() %></p>
                                            </div>
                                        </div>
                                        <div class="grid grid-cols-1 gap-2">
                                            <div class="flex items-center">
                                                <i class="fas fa-phone w-5 text-gray-500"></i>
                                                <span class="ml-2"><%= driver.getPhoneNumber() %></span>
                                            </div>
                                            <div class="flex items-center">
                                                <i class="fas fa-envelope w-5 text-gray-500"></i>
                                                <span class="ml-2"><%= driver.getEmail() %></span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Vehicle Information -->
                                    <div>
                                        <h3 class="text-lg font-semibold text-gray-700 mb-3">Assigned Vehicle</h3>
                                        <div class="flex items-center mb-4">
                                            <div class="h-12 w-12 rounded-full bg-indigo-100 flex items-center justify-center">
                                                <i class="fas fa-<%= vehicle.getType().toLowerCase().contains("bus") ? "bus" : "car" %> text-indigo-500"></i>
                                            </div>
                                            <div class="ml-4">
                                                <h4 class="text-md font-semibold"><%= vehicle.getMake() %> <%= vehicle.getModel() %></h4>
                                                <p class="text-sm text-gray-500"><%= vehicle.getRegistration() %></p>
                                            </div>
                                        </div>
                                        <div class="grid grid-cols-1 gap-2">
                                            <div class="flex items-center">
                                                <i class="fas fa-tag w-5 text-gray-500"></i>
                                                <span class="ml-2"><%= vehicle.getType() %></span>
                                            </div>
                                            <div class="flex items-center">
                                                <i class="fas fa-calendar w-5 text-gray-500"></i>
                                                <span class="ml-2"><%= vehicle.getYear() %></span>
                                            </div>
                                            <div class="flex items-center">
                                                <i class="fas fa-users w-5 text-gray-500"></i>
                                                <span class="ml-2"><%= vehicle.getCapacity() %> passengers</span>
                                            </div>
                                        </div>
                                    </div>
                                <% } else { %>
                                    <div class="bg-yellow-50 p-4 rounded-md">
                                        <p class="text-yellow-700 flex items-center">
                                            <i class="fas fa-exclamation-triangle mr-2"></i>
                                            No transport assigned yet
                                        </p>
                                        <p class="text-sm text-yellow-600 mt-1">
                                            This trip doesn't have a driver and vehicle assigned.
                                        </p>
                                        <a href="${pageContext.request.contextPath}/transport/assignResources.jsp?tripId=<%= trip.getTripId() %>" 
                                           class="mt-3 inline-block bg-secondary hover:bg-orange-700 text-white py-2 px-4 rounded text-sm">
                                            Assign Resources
                                        </a>
                                    </div>
                                <% } %>
                            </div>
                            
                            <!-- Action Buttons -->
                            <div class="bg-white rounded-lg shadow-md p-6">
                                <h2 class="text-xl font-bold mb-4 text-blue-800 border-b pb-2">
                                    <i class="fas fa-cogs mr-2"></i>Actions
                                </h2>
                                <div class="space-y-3">
                                    <% if(assignment == null) { %>
                                        <a href="${pageContext.request.contextPath}/transport/assignResources.jsp?tripId=<%= trip.getTripId() %>" 
                                           class="block w-full bg-green-600 hover:bg-green-700 text-white text-center py-2 px-4 rounded">
                                            <i class="fas fa-plus-circle mr-2"></i> Assign Resources
                                        </a>
                                    <% } else if(LocalDate.now().isBefore(trip.getDepartureDate())) { %>
                                        <a href="${pageContext.request.contextPath}/transport/editAssignment.jsp?id=<%= trip.getTripId() %>" 
                                           class="block w-full bg-blue-600 hover:bg-blue-700 text-white text-center py-2 px-4 rounded">
                                            <i class="fas fa-edit mr-2"></i> Edit Assignment
                                        </a>
                                        <button onclick="confirmUnassign('<%= trip.getTripId() %>', '<%= destination != null ? destination.getName() : "this trip" %>')" 
                                                class="block w-full bg-red-600 hover:bg-red-700 text-white text-center py-2 px-4 rounded">
                                            <i class="fas fa-unlink mr-2"></i> Remove Assignment
                                        </button>
                                    <% } %>
                                    <a href="${pageContext.request.contextPath}/transport/viewAssignments.jsp" 
                                       class="block w-full bg-gray-500 hover:bg-gray-600 text-white text-center py-2 px-4 rounded">
                                        <i class="fas fa-arrow-left mr-2"></i> Back to Assignments
                                    </a>
                                </div>
                            </div>
                        </div>
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
        function confirmUnassign(tripId, destination) {
            document.getElementById('unassignTripId').value = tripId;
            document.getElementById('unassignConfirmationText').textContent = 
                `Are you sure you want to remove the assignment for the trip to ${destination}? This will free up the driver and vehicle for other trips.`;
            document.getElementById('unassignModal').classList.remove('hidden');
        }
        
        function closeModal(modalId) {
            document.getElementById(modalId).classList.add('hidden');
        }
        
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeModal('unassignModal');
            }
        });
    </script>
</body>
</html>
