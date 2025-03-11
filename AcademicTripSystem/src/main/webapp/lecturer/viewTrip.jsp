<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.model.User" %>
<%@ page import="com.academictrip.dao.TripDAO" %>
<%@ page import="com.academictrip.dao.DriverVehicleDAO" %>
<%@ page import="com.academictrip.model.Trip" %>
<%@ page import="com.academictrip.model.DriverVehicle" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    // Renamed variable to avoid conflict with header.jsp
    User tripPageUser = (User) session.getAttribute("user");
    if (tripPageUser == null || !tripPageUser.getRole().equalsIgnoreCase("lecturer")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get trip ID from request parameter
    String tripId = request.getParameter("id");
    if (tripId == null || tripId.isEmpty()) {
        session.setAttribute("errorMessage", "Trip ID is required");
        response.sendRedirect(request.getContextPath() + "/lecturer/dashboard.jsp");
        return;
    }
    
    // Get trip details
    TripDAO tripDAO = new TripDAO();
    Trip trip = tripDAO.getTripById(tripId);
    
    if (trip == null) {
        session.setAttribute("errorMessage", "Trip not found");
        response.sendRedirect(request.getContextPath() + "/lecturer/dashboard.jsp");
        return;
    }
    
    // Check if this trip belongs to the current lecturer - with null safety
    String tripLecturerId = trip.getLecturerId();
    if (tripLecturerId != null && !tripLecturerId.equals(tripPageUser.getId())) {
        session.setAttribute("errorMessage", "You don't have permission to view this trip");
        response.sendRedirect(request.getContextPath() + "/lecturer/dashboard.jsp");
        return;
    }
    
    // Format date
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy");
    String formattedDate = trip.getTripDate() != null ? 
        trip.getTripDate().format(formatter) : "Date not set";
    
    // Get driver and vehicle information if assigned
    DriverVehicle driverVehicle = null;
    if (trip.getDriverVehicleId() != null) {
        DriverVehicleDAO dvDAO = new DriverVehicleDAO();
        driverVehicle = dvDAO.getDriverVehicleById(trip.getDriverVehicleId());
    }
    
    // Get success message if exists and then clear it
    String successMessage = (String) session.getAttribute("successMessage");
    session.removeAttribute("successMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trip Details | Academic Trip System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">
    <div class="page-wrapper">
        <%@ include file="/includes/header.jsp" %>
        
        <div class="main-content">
            <div class="container mx-auto px-4 py-8">
                <div class="flex items-center text-sm text-gray-600 mb-6">
                    <a href="${pageContext.request.contextPath}/lecturer/dashboard.jsp" class="hover:text-blue-500">
                        <i class="fas fa-home mr-2"></i> Dashboard
                    </a>
                    <span class="mx-2">/</span>
                    <span class="text-gray-800 font-medium">Trip Details</span>
                </div>
                
                <!-- Success message display -->
                <% if(successMessage != null && !successMessage.isEmpty()) { %>
                    <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-6" id="successAlert">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i class="fas fa-check-circle text-green-500"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-green-700"><%= successMessage %></p>
                            </div>
                            <div class="ml-auto">
                                <button type="button" onclick="document.getElementById('successAlert').style.display='none'" class="text-green-500">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                <% } %>
                
                <!-- Trip Details Card -->
                <div class="bg-white shadow-xl rounded-lg overflow-hidden">
                    <!-- Header -->
                    <div class="bg-primary px-6 py-4">
                        <div class="flex justify-between items-center">
                            <h1 class="text-2xl font-bold text-white">
                                <i class="fas fa-info-circle mr-2"></i> Trip Details
                            </h1>
                            <a href="${pageContext.request.contextPath}/lecturer/dashboard.jsp" 
                               class="bg-white bg-opacity-20 hover:bg-opacity-30 text-white py-2 px-4 rounded-md transition-colors flex items-center">
                                <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
                            </a>
                        </div>
                    </div>
                    
                    <div class="p-6">
                        <!-- Trip Status Banner -->
                        <div class="flex items-center p-4 mb-6 rounded-lg <%= trip.getDriverVehicleId() != null ? "bg-green-50 text-green-700" : "bg-yellow-50 text-yellow-700" %>">
                            <i class="<%= trip.getDriverVehicleId() != null ? "fas fa-check-circle text-green-500" : "fas fa-clock text-yellow-500" %> text-2xl mr-3"></i>
                            <span class="text-lg font-medium">Status: <%= trip.getDriverVehicleId() != null ? "Resources Assigned" : "Pending Assignment" %></span>
                        </div>
                        
                        <!-- Trip Info Sections -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                            <!-- Basic Information -->
                            <div class="bg-white border border-gray-200 rounded-lg p-5 shadow-sm">
                                <h2 class="text-lg font-semibold text-primary border-b border-gray-200 pb-2 mb-4">
                                    <i class="fas fa-clipboard-list mr-2 text-secondary"></i>Basic Information
                                </h2>
                                <div class="space-y-3">
                                    <div class="grid grid-cols-1 sm:grid-cols-2">
                                        <div class="text-gray-600 font-medium">Trip ID:</div>
                                        <div class="font-semibold"><%= trip.getId() %></div>
                                    </div>
                                    <div class="grid grid-cols-1 sm:grid-cols-2">
                                        <div class="text-gray-600 font-medium">Trip Date:</div>
                                        <div><%= formattedDate %></div>
                                    </div>
                                    <div class="grid grid-cols-1 sm:grid-cols-2">
                                        <div class="text-gray-600 font-medium">Created On:</div>
                                        <div>
                                            <%= trip.getCreatedAt() != null ? 
                                                trip.getCreatedAt().format(DateTimeFormatter.ofPattern("dd MMM yyyy")) : 
                                                "Not available" %>
                                        </div>
                                    </div>
                                    <div class="grid grid-cols-1 sm:grid-cols-2">
                                        <div class="text-gray-600 font-medium">Trip Purpose:</div>
                                        <div><%= trip.getPurpose() != null ? trip.getPurpose() : "Not specified" %></div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Destination Information -->
                            <div class="bg-white border border-gray-200 rounded-lg p-5 shadow-sm">
                                <h2 class="text-lg font-semibold text-primary border-b border-gray-200 pb-2 mb-4">
                                    <i class="fas fa-map-marker-alt mr-2 text-secondary"></i>Destination Information
                                </h2>
                                <div class="space-y-3">
                                    <div class="grid grid-cols-1 sm:grid-cols-2">
                                        <div class="text-gray-600 font-medium">Name:</div>
                                        <div class="font-semibold"><%= trip.getDestination() != null ? trip.getDestination().getName() : "N/A" %></div>
                                    </div>
                                    <div class="grid grid-cols-1 sm:grid-cols-2">
                                        <div class="text-gray-600 font-medium">Location:</div>
                                        <div><%= trip.getDestination() != null ? trip.getDestination().getLocation() : "N/A" %></div>
                                    </div>
                                    <div class="grid grid-cols-1 sm:grid-cols-2">
                                        <div class="text-gray-600 font-medium">Distance:</div>
                                        <div><%= trip.getDestination() != null ? trip.getDestination().getDistance() + " km" : "N/A" %></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                            <!-- Academic Information -->
                            <div class="bg-white border border-gray-200 rounded-lg p-5 shadow-sm">
                                <h2 class="text-lg font-semibold text-primary border-b border-gray-200 pb-2 mb-4">
                                    <i class="fas fa-graduation-cap mr-2 text-secondary"></i>Academic Information
                                </h2>
                                <div class="space-y-3">
                                    <div class="grid grid-cols-1 sm:grid-cols-2">
                                        <div class="text-gray-600 font-medium">Faculty:</div>
                                        <div><%= trip.getFaculty() != null ? trip.getFaculty().getName() : "N/A" %></div>
                                    </div>
                                    <div class="grid grid-cols-1 sm:grid-cols-2">
                                        <div class="text-gray-600 font-medium">Course:</div>
                                        <div><%= trip.getCourse() != null ? trip.getCourse().getName() + " (" + trip.getCourse().getCode() + ")" : "N/A" %></div>
                                    </div>
                                    <div class="grid grid-cols-1 sm:grid-cols-2">
                                        <div class="text-gray-600 font-medium">Number of Students:</div>
                                        <div class="font-semibold"><%= trip.getNumberOfStudents() %></div>
                                    </div>
                                </div>
                            </div>
                            
                            <% if (trip.getInchargeId() != null) { %>
                            <!-- Trip Supervisor Information -->
                            <div class="bg-white border border-gray-200 rounded-lg p-5 shadow-sm">
                                <h2 class="text-lg font-semibold text-primary border-b border-gray-200 pb-2 mb-4">
                                    <i class="fas fa-user-tie mr-2 text-secondary"></i>Trip Supervisor Information
                                </h2>
                                <div class="space-y-3">
                                    <div class="grid grid-cols-1 sm:grid-cols-2">
                                        <div class="text-gray-600 font-medium">Incharge Name:</div>
                                        <div><%= trip.getInchargeGroup() != null && trip.getInchargeGroup().getIncharge() != null ? 
                                            trip.getInchargeGroup().getIncharge().getName() : "N/A" %></div>
                                    </div>
                                    <div class="grid grid-cols-1 sm:grid-cols-2">
                                        <div class="text-gray-600 font-medium">Incharge Email:</div>
                                        <div><%= trip.getInchargeGroup() != null && trip.getInchargeGroup().getIncharge() != null ? 
                                            trip.getInchargeGroup().getIncharge().getEmail() : "N/A" %></div>
                                    </div>
                                    <div class="grid grid-cols-1 sm:grid-cols-2">
                                        <div class="text-gray-600 font-medium">Incharge Phone:</div>
                                        <div><%= trip.getInchargeGroup() != null && trip.getInchargeGroup().getIncharge() != null ? 
                                            trip.getInchargeGroup().getIncharge().getPhone() : "N/A" %></div>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                        
                        <% if (trip.getDriverVehicleId() != null && driverVehicle != null) { %>
                        <!-- Assigned Resources -->
                        <div class="mb-6">
                            <h2 class="text-lg font-semibold text-primary border-b border-gray-200 pb-2 mb-4">
                                <i class="fas fa-bus mr-2 text-secondary"></i>Assigned Resources
                            </h2>
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                                <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                                    <div class="flex items-center mb-3">
                                        <div class="bg-blue-100 p-2 rounded-full mr-3">
                                            <i class="fas fa-user text-blue-500"></i>
                                        </div>
                                        <h3 class="font-semibold">Driver</h3>
                                    </div>
                                    <p class="text-gray-700"><%= driverVehicle.getDriver().getName() %></p>
                                    <p class="text-gray-500 text-sm"><i class="fas fa-phone-alt mr-1"></i> <%= driverVehicle.getDriver().getPhone() %></p>
                                </div>
                                
                                <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                                    <div class="flex items-center mb-3">
                                        <div class="bg-indigo-100 p-2 rounded-full mr-3">
                                            <i class="fas fa-bus text-indigo-500"></i>
                                        </div>
                                        <h3 class="font-semibold">Vehicle</h3>
                                    </div>
                                    <p class="text-gray-700"><%= driverVehicle.getVehicle().getMake() %> <%= driverVehicle.getVehicle().getModel() %></p>
                                    <p class="text-gray-500 text-sm"><%= driverVehicle.getVehicle().getRegistrationNumber() %> | <%= driverVehicle.getVehicle().getCapacity() %> seats</p>
                                </div>
                            </div>
                        </div>
                        <% } %>
                        
                        <!-- Trip Notes -->
                        <div class="bg-gray-50 p-4 rounded-lg mt-6">
                            <h2 class="text-lg font-semibold text-primary mb-3">
                                <i class="fas fa-sticky-note mr-2 text-secondary"></i>Additional Notes
                            </h2>
                            <div class="bg-white p-4 rounded-md shadow-sm">
                                <% if (trip.getNotes() != null && !trip.getNotes().isEmpty()) { %>
                                    <p><%= trip.getNotes() %></p>
                                <% } else { %>
                                    <p class="text-gray-500 italic">No additional notes provided.</p>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Footer Actions -->
                    <div class="bg-gray-50 px-6 py-4 flex justify-between items-center">
                        <div>
                            <a href="${pageContext.request.contextPath}/lecturer/dashboard.jsp" 
                               class="bg-gray-500 hover:bg-gray-600 text-white py-2 px-4 rounded-md inline-flex items-center transition-colors">
                                <i class="fas fa-arrow-left mr-2"></i> Back
                            </a>
                        </div>
                        <div class="flex gap-3">
                            <a href="${pageContext.request.contextPath}/lecturer/editTrip.jsp?id=<%= trip.getId() %>" 
                               class="bg-blue-600 hover:bg-blue-700 text-white py-2 px-4 rounded-md inline-flex items-center transition-colors">
                                <i class="fas fa-edit mr-2"></i> Edit Trip
                            </a>
                            
                            <% if (trip.getDriverVehicleId() == null) { %>
                            <button type="button" onclick="confirmCancelTrip()" 
                                    class="bg-red-600 hover:bg-red-700 text-white py-2 px-4 rounded-md inline-flex items-center transition-colors">
                                <i class="fas fa-times-circle mr-2"></i> Cancel Trip
                            </button>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <footer>
            <div class="footer-content">
                <p>&copy; <%= java.time.LocalDate.now().getYear() %> Academic Trip System. All rights reserved.</p>
                <p class="mt-2 text-sm text-gray-300">Lecturer Management Module</p>
            </div>
        </footer>
    </div>
    
    <!-- Confirmation Modal -->
    <div class="fixed z-10 inset-0 overflow-y-auto hidden" id="cancelModal">
        <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center">
            <div class="fixed inset-0 transition-opacity" aria-hidden="true">
                <div class="absolute inset-0 bg-gray-500 opacity-75" onclick="closeModal()"></div>
            </div>
            <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                    <div class="sm:flex sm:items-start">
                        <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                            <i class="fas fa-exclamation-triangle text-red-600"></i>
                        </div>
                        <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                            <h3 class="text-lg leading-6 font-medium text-gray-900">Confirm Cancellation</h3>
                            <div class="mt-2">
                                <p class="text-sm text-gray-500">Are you sure you want to cancel this trip? This action cannot be undone.</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                    <form action="${pageContext.request.contextPath}/lecturer/cancelTrip" method="post">
                        <input type="hidden" name="tripId" value="<%= trip.getId() %>">
                        <button type="submit" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm">
                            Yes, Cancel Trip
                        </button>
                    </form>
                    <button type="button" onclick="closeModal()" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                        No, Keep Trip
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Auto-hide success alert after 5 seconds
        window.onload = function() {
            setTimeout(function() {
                const successAlert = document.getElementById('successAlert');
                if (successAlert) {
                    successAlert.style.display = 'none';
                }
            }, 5000);
        };
        
        function confirmCancelTrip() {
            document.getElementById('cancelModal').style.display = 'block';
        }
        
        function closeModal() {
            document.getElementById('cancelModal').style.display = 'none';
        }
        
        // Close the modal if user clicks outside of it
        window.onclick = function(event) {
            const modal = document.getElementById('cancelModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    </script>
</body>
</html>
