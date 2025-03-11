<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.academictrip.model.User" %>
<%@ page import="com.academictrip.dao.TripDAO" %>
<%@ page import="com.academictrip.dao.InchargeGroupDAO" %>
<%@ page import="com.academictrip.dao.TripGroupDAO" %>
<%@ page import="com.academictrip.dao.CourseDAO" %>
<%@ page import="com.academictrip.model.Trip" %>
<%@ page import="com.academictrip.model.InchargeGroup" %>
<%@ page import="com.academictrip.model.TripGroup" %>
<%@ page import="com.academictrip.model.Incharge" %>
<%@ page import="com.academictrip.model.Course" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>

<%
    // Check if user is logged in and is a lecturer
    User editPageUser = (User) session.getAttribute("user");
    if (editPageUser == null || !editPageUser.getRole().equalsIgnoreCase("lecturer")) {
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
    
    // Check if this trip belongs to the current lecturer
    String tripLecturerId = trip.getLecturerId();
    if (tripLecturerId != null && !tripLecturerId.equals(editPageUser.getId())) {
        session.setAttribute("errorMessage", "You don't have permission to edit this trip");
        response.sendRedirect(request.getContextPath() + "/lecturer/dashboard.jsp");
        return;
    }
    
    // Load incharge information
    String inchargeFirstName = "";
    String inchargeLastName = "";
    String inchargePhone = "";
    String inchargeEmail = "";
    String groupName = "";
    int studentCount = 0;
    String courseName = "";
    String facultyName = "";
    String destinationName = "";
    
    // Load all related details if available
    if (trip.getInchargeGroupId() != null) {
        InchargeGroupDAO inchargeGroupDAO = new InchargeGroupDAO();
        InchargeGroup inchargeGroup = inchargeGroupDAO.getInchargeGroupById(trip.getInchargeGroupId());
        
        if (inchargeGroup != null) {
            // Get incharge details
            Incharge incharge = inchargeGroup.getIncharge();
            if (incharge != null) {
                inchargeFirstName = incharge.getFirstName();
                inchargeLastName = incharge.getLastName();
                inchargePhone = String.valueOf(incharge.getPhoneNumber());
                inchargeEmail = incharge.getEmail();
            }
            
            // Get group details
            TripGroup tripGroup = inchargeGroup.getTripGroup();
            if (tripGroup != null) {
                groupName = tripGroup.getGroupName();
                studentCount = tripGroup.getStudentNumber();
                
                // Enhanced course retrieval with explicit loading
                String courseId = tripGroup.getCourseId();
                if (courseId != null && !courseId.isEmpty()) {
                    CourseDAO courseDAO = new CourseDAO();
                    try {
                        Course course = courseDAO.getCourseById(courseId);
                        if (course != null) {
                            courseName = course.getCourseName();
                            System.out.println("Loaded course: " + courseId + " - Name: " + courseName);
                        } else {
                            System.out.println("Course not found with ID: " + courseId);
                        }
                    } catch (Exception e) {
                        System.out.println("Error loading course: " + e.getMessage());
                        e.printStackTrace();
                    }
                } else {
                    System.out.println("No course ID found in trip group");
                }
            }
        }
    }
    
    // Get destination name - Ensure trip.getDestination() returns a valid object
    if (trip.getDestination() != null) {
        destinationName = trip.getDestination().getName();
    }
    
    // Get faculty name - Ensure trip.getFaculty() returns a valid object
    if (trip.getFaculty() != null) {
        facultyName = trip.getFaculty().getName();
    }
    
    // For debugging purposes
    System.out.println("Trip ID: " + trip.getTripId());
    System.out.println("Course Name: " + courseName);
    
    // Get message from session if exists
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("errorMessage");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Trip | Academic Trip System</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">
    <div class="page-wrapper">
        <%@ include file="/includes/header.jsp" %>
        
        <div class="main-content">
            <div class="container mx-auto px-4 py-8">
                <!-- Breadcrumb -->
                <div class="flex items-center text-sm text-gray-600 mb-6">
                    <a href="${pageContext.request.contextPath}/lecturer/dashboard.jsp" class="hover:text-blue-500">
                        <i class="fas fa-home mr-2"></i> Dashboard
                    </a>
                    <span class="mx-2">/</span>
                    <a href="${pageContext.request.contextPath}/lecturer/viewTrip.jsp?id=<%= trip.getTripId() %>" class="hover:text-blue-500">
                        Trip Details
                    </a>
                    <span class="mx-2">/</span>
                    <span class="text-gray-800 font-medium">Edit Trip</span>
                </div>
                
                <!-- Edit Trip Card -->
                <div class="bg-white shadow-xl rounded-lg overflow-hidden">
                    <!-- Header -->
                    <div class="bg-primary px-6 py-4">
                        <h1 class="text-2xl font-bold text-white">
                            <i class="fas fa-edit mr-2"></i> Edit Trip
                        </h1>
                        <p class="text-blue-100 mt-1">Update trip details for <%= trip.getTripId() %></p>
                    </div>
                    
                    <div class="p-6">
                        <!-- Display error message if present -->
                        <% if(errorMessage != null) { %>
                            <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6" id="errorAlert">
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
                        
                        <!-- Edit Trip Form -->
                        <form action="${pageContext.request.contextPath}/UpdateTripServlet" method="post" class="space-y-6" id="editTripForm">
                            <!-- Hidden field for trip ID -->
                            <input type="hidden" name="tripId" value="<%= trip.getTripId() %>">
                            
                            <!-- Trip Details Section -->
                            <div class="mb-6">
                                <h2 class="text-lg font-semibold text-primary border-b border-gray-200 pb-2 mb-4">
                                    <i class="fas fa-info-circle mr-2 text-secondary"></i>Trip Details
                                </h2>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">Start Date <span class="text-red-500">*</span></label>
                                        <input type="date" name="startDate" value="<%= trip.getStartDateFormatted() %>" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">End Date <span class="text-red-500">*</span></label>
                                        <input type="date" name="endDate" value="<%= trip.getEndDateFormatted() %>" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Incharge Details Section -->
                            <div class="mb-6">
                                <h2 class="text-lg font-semibold text-primary border-b border-gray-200 pb-2 mb-4">
                                    <i class="fas fa-user-tie mr-2 text-secondary"></i>Trip Supervisor Details
                                </h2>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">First Name <span class="text-red-500">*</span></label>
                                        <input type="text" name="inchargeFirstName" value="<%= inchargeFirstName %>" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">Last Name <span class="text-red-500">*</span></label>
                                        <input type="text" name="inchargeLastName" value="<%= inchargeLastName %>" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                </div>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-4">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">Phone <span class="text-red-500">*</span></label>
                                        <input type="tel" name="inchargePhone" value="<%= inchargePhone %>" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">Email <span class="text-red-500">*</span></label>
                                        <input type="email" name="inchargeEmail" value="<%= inchargeEmail %>" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Student Group Section -->
                            <div class="mb-6">
                                <h2 class="text-lg font-semibold text-primary border-b border-gray-200 pb-2 mb-4">
                                    <i class="fas fa-users mr-2 text-secondary"></i>Student Group Details
                                </h2>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">Group Name <span class="text-red-500">*</span></label>
                                        <input type="text" name="groupName" value="<%= groupName %>" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">Student Count <span class="text-red-500">*</span></label>
                                        <input type="number" name="studentCount" value="<%= studentCount %>" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Academic Information Section -->
                            <div class="mb-6">
                                <h2 class="text-lg font-semibold text-primary border-b border-gray-200 pb-2 mb-4">
                                    <i class="fas fa-graduation-cap mr-2 text-secondary"></i>Academic Information
                                </h2>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">Course Name <span class="text-red-500">*</span></label>
                                        <input type="text" name="courseName" value="<%= courseName %>" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">Faculty Name <span class="text-red-500">*</span></label>
                                        <input type="text" name="facultyName" value="<%= facultyName %>" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Destination Section -->
                            <div class="mb-10">
                                <h2 class="text-lg font-semibold text-primary border-b border-gray-200 pb-2 mb-4">
                                    <i class="fas fa-map-marker-alt mr-2 text-secondary"></i>Destination
                                </h2>
                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Destination Name <span class="text-red-500">*</span></label>
                                    <input type="text" name="destinationName" value="<%= destinationName %>" required 
                                           class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                </div>
                            </div>
                            
                            <!-- Form Actions -->
                            <div class="flex justify-between">
                                <a href="${pageContext.request.contextPath}/lecturer/viewTrip.jsp?id=<%= trip.getTripId() %>" 
                                   class="bg-gray-500 hover:bg-gray-600 text-white py-2 px-6 rounded-md inline-flex items-center transition-colors">
                                    <i class="fas fa-times mr-2"></i> Cancel
                                </a>
                                
                                <button type="submit" id="submitBtn"
                                        class="bg-blue-600 hover:bg-blue-700 text-white py-2 px-6 rounded-md inline-flex items-center transition-colors">
                                    <i class="fas fa-save mr-2"></i> Update Trip
                                </button>
                            </div>
                        </form>
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
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('editTripForm');
            const submitBtn = document.getElementById('submitBtn');
            
            // Auto-hide error alert after 5 seconds
            setTimeout(function() {
                const errorAlert = document.getElementById('errorAlert');
                if (errorAlert) {
                    errorAlert.style.display = 'none';
                }
            }, 5000);
            
            form.addEventListener('submit', function(e) {
                // Disable submit button to prevent multiple submissions
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Updating...';
                
                // Basic form validation
                const startDate = document.querySelector('input[name="startDate"]');
                const endDate = document.querySelector('input[name="endDate"]');
                
                if (startDate.value === '') {
                    e.preventDefault();
                    alert('Please enter a start date');
                    startDate.focus();
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = '<i class="fas fa-save mr-2"></i> Update Trip';
                    return;
                }
                
                if (endDate.value === '') {
                    e.preventDefault();
                    alert('Please enter an end date');
                    endDate.focus();
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = '<i class="fas fa-save mr-2"></i> Update Trip';
                    return;
                }
                
                if (new Date(startDate.value) > new Date(endDate.value)) {
                    e.preventDefault();
                    alert('End date must be after start date');
                    endDate.focus();
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = '<i class="fas fa-save mr-2"></i> Update Trip';
                    return;
                }
            });
        });
    </script>
</body>
</html>
