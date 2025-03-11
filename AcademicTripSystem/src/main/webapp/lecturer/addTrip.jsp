<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.academictrip.model.User" %>
<%@ page import="java.time.LocalDate" %>
<%
    // Check if user is logged in and is a lecturer
    User addTripUser = (User) session.getAttribute("user");
    if (addTripUser == null || !addTripUser.getRole().equalsIgnoreCase("lecturer")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Pre-populate form with user information if available
    String userEmail = addTripUser.getUsername(); // Changed from getEmail() to getUsername()
    String userName = addTripUser.getName() != null ? addTripUser.getName() : "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Trip | Academic Trip System</title>
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
                    <span class="text-gray-800 font-medium">Add New Trip</span>
                </div>
                
                <!-- Add Trip Card -->
                <div class="bg-white shadow-xl rounded-lg overflow-hidden">
                    <!-- Header -->
                    <div class="bg-primary px-6 py-4">
                        <h1 class="text-2xl font-bold text-white">
                            <i class="fas fa-plus-circle mr-2"></i> Add New Trip
                        </h1>
                        <p class="text-blue-100 mt-1">Fill in the details to request a new academic trip</p>
                    </div>
                
                    <div class="p-6">
                        <!-- Display error message if present -->
                        <% if(request.getAttribute("errorMessage") != null) { %>
                            <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6" id="errorAlert">
                                <div class="flex">
                                    <div class="flex-shrink-0">
                                        <i class="fas fa-exclamation-circle text-red-500"></i>
                                    </div>
                                    <div class="ml-3">
                                        <p class="text-red-700"><%= request.getAttribute("errorMessage") %></p>
                                    </div>
                                    <div class="ml-auto">
                                        <button onclick="document.getElementById('errorAlert').style.display='none'" class="text-red-500">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                        
                        <!-- Trip Form -->
                        <form action="${pageContext.request.contextPath}/AddTripServlet" method="post" class="space-y-6" id="addTripForm">
                            <!-- Trip Details Section -->
                            <div class="mb-6">
                                <h2 class="text-lg font-semibold text-primary border-b border-gray-200 pb-2 mb-4">
                                    <i class="fas fa-info-circle mr-2 text-secondary"></i>Trip Details
                                </h2>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">Start Date <span class="text-red-500">*</span></label>
                                        <input type="date" name="startDate" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">End Date <span class="text-red-500">*</span></label>
                                        <input type="date" name="endDate" required 
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
                                        <input type="text" name="inchargeFirstName" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">Last Name <span class="text-red-500">*</span></label>
                                        <input type="text" name="inchargeLastName" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                </div>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-4">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">Phone <span class="text-red-500">*</span></label>
                                        <input type="tel" name="inchargePhone" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">Email <span class="text-red-500">*</span></label>
                                        <input type="email" name="inchargeEmail" required 
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
                                        <input type="text" name="groupName" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">Student Count <span class="text-red-500">*</span></label>
                                        <input type="number" name="studentCount" required min="1"
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
                                        <input type="text" name="courseName" required 
                                               class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700">Faculty Name <span class="text-red-500">*</span></label>
                                        <input type="text" name="facultyName" required 
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
                                    <input type="text" name="destinationName" required 
                                           class="w-full mt-1 p-2 border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-indigo-200 focus:border-indigo-300">
                                </div>
                            </div>
                            
                            <!-- Form Actions -->
                            <div class="flex justify-between">
                                <a href="${pageContext.request.contextPath}/lecturer/dashboard.jsp" 
                                   class="bg-gray-500 hover:bg-gray-600 text-white py-2 px-6 rounded-md inline-flex items-center transition-colors">
                                    <i class="fas fa-arrow-left mr-2"></i> Cancel
                                </a>
                                
                                <button type="submit" id="submitBtn"
                                        class="bg-blue-600 hover:bg-blue-700 text-white py-2 px-6 rounded-md inline-flex items-center transition-colors">
                                    <i class="fas fa-paper-plane mr-2"></i> Submit Trip
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
            const form = document.getElementById('addTripForm');
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
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Submitting...';
                
                // Basic form validation
                const startDate = document.querySelector('input[name="startDate"]');
                const endDate = document.querySelector('input[name="endDate"]');
                
                if (startDate.value === '') {
                    e.preventDefault();
                    alert('Please enter a start date');
                    startDate.focus();
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = '<i class="fas fa-paper-plane mr-2"></i> Submit Trip';
                    return;
                }
                
                if (endDate.value === '') {
                    e.preventDefault();
                    alert('Please enter an end date');
                    endDate.focus();
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = '<i class="fas fa-paper-plane mr-2"></i> Submit Trip';
                    return;
                }
                
                if (new Date(startDate.value) > new Date(endDate.value)) {
                    e.preventDefault();
                    alert('End date must be after start date');
                    endDate.focus();
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = '<i class="fas fa-paper-plane mr-2"></i> Submit Trip';
                    return;
                }
            });
            
            // Set minimum dates
            const today = new Date();
            const yyyy = today.getFullYear();
            const mm = String(today.getMonth() + 1).padStart(2, '0'); // January is 0!
            const dd = String(today.getDate()).padStart(2, '0');
            const todayFormatted = `${yyyy}-${mm}-${dd}`;
            
            document.querySelector('input[name="startDate"]').min = todayFormatted;
            document.querySelector('input[name="endDate"]').min = todayFormatted;
        });
    </script>
</body>
</html>
