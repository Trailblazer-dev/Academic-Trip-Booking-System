
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.Year" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Vehicle | Academic Trip System</title>
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
                            <i class="fas fa-bus mr-2"></i>Add New Vehicle
                        </h1>
                        <p class="text-blue-100 mt-1">Enter vehicle details below</p>
                    </div>
                    
                    <!-- Alert Messages -->
                    <% if (request.getAttribute("errorMessage") != null) { %> 
                        <div class="bg-red-50 border-l-4 border-red-500 p-4 m-4" id="errorAlert">
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
                    
                    <!-- Vehicle Form -->
                    <form id="addVehicleForm" action="${pageContext.request.contextPath}/transport/addVehicleAction" method="post" class="p-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <!-- Make -->
                            <div class="mb-6">
                                <label for="make" class="block text-sm font-medium text-gray-700 mb-1">Make <span class="text-red-500">*</span></label>
                                <input type="text" id="make" name="make" required
                                       class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                       placeholder="Enter vehicle make (e.g., Toyota)">
                            </div>
                            
                            <!-- Model -->
                            <div class="mb-6">
                                <label for="model" class="block text-sm font-medium text-gray-700 mb-1">Model <span class="text-red-500">*</span></label>
                                <input type="text" id="model" name="model" required
                                       class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                       placeholder="Enter vehicle model (e.g., Coaster)">
                            </div>
                        </div>
                        
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                            <!-- Year -->
                            <div>
                                <label for="year" class="block text-sm font-medium text-gray-700 mb-1">Year <span class="text-red-500">*</span></label>
                                <select id="year" name="year" required
                                        class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                                    <option value="">Select Year</option>
                                    <% 
                                        int currentYear = Year.now().getValue();
                                        for (int year = currentYear; year >= currentYear - 20; year--) { 
                                    %>
                                        <option value="<%= year %>"><%= year %></option>
                                    <% } %>
                                </select>
                            </div>
                            
                            <!-- Capacity -->
                            <div>
                                <label for="capacity" class="block text-sm font-medium text-gray-700 mb-1">Capacity <span class="text-red-500">*</span></label>
                                <input type="number" id="capacity" name="capacity" required min="1" max="100"
                                       class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                       placeholder="Number of seats">
                            </div>
                            
                            <!-- Registration -->
                            <div>
                                <label for="registration" class="block text-sm font-medium text-gray-700 mb-1">Registration Number <span class="text-red-500">*</span></label>
                                <input type="text" id="registration" name="registration" required
                                       class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                       placeholder="Enter plate number">
                            </div>
                        </div>
                        
                        <!-- Buttons -->
                        <div class="flex justify-between mt-8">
                            <a href="${pageContext.request.contextPath}/transport/manageVehicles.jsp" 
                               class="bg-gray-500 hover:bg-gray-600 text-white py-2 px-4 rounded-md inline-flex items-center transition-colors">
                                <i class="fas fa-arrow-left mr-2"></i> Cancel
                            </a>
                            <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white py-2 px-6 rounded-md inline-flex items-center transition-colors">
                                <i class="fas fa-save mr-2"></i> Save Vehicle
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

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Form validation
            document.getElementById('addVehicleForm').addEventListener('submit', function(e) {
                const make = document.getElementById('make').value.trim();
                const model = document.getElementById('model').value.trim();
                const year = document.getElementById('year').value;
                const capacity = document.getElementById('capacity').value.trim();
                const registration = document.getElementById('registration').value.trim();
                
                if (!make || !model || !year || !capacity || !registration) {
                    e.preventDefault();
                    alert('Please fill in all required fields');
                }
            });
        });
    </script>
</body>
</html>