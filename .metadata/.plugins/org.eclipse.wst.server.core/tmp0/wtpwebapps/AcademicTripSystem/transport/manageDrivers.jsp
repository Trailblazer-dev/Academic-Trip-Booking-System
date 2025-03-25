<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.dao.DriverDAO" %>
<%@ page import="com.academictrip.dao.DriverVehicleDAO" %>
<%@ page import="com.academictrip.model.Driver" %>
<%@ page import="com.academictrip.model.DriverVehicle" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    // Your existing code for driver management
    DriverDAO driverDAO = new DriverDAO();
    List<Driver> drivers = driverDAO.getAllDrivers();
    
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
    <title>Manage Drivers | Academic Trip System</title>
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
                <div class="flex justify-between items-center mb-6">
                    <h1 class="text-2xl font-bold text-gray-800">
                        <i class="fas fa-users mr-2 text-secondary"></i>Manage Drivers
                    </h1>
                    <a href="${pageContext.request.contextPath}/transport/addDriver.jsp" class="btn btn-secondary hover:bg-orange-700 text-white py-2 px-4 rounded-lg flex items-center">
    <i class="fas fa-plus-circle mr-2"></i> Add New Driver
</a>
                </div>
                
                <!-- Dashboard Stats -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                    <div class="bg-white rounded-lg shadow-md p-6 border-t-4 border-blue-500">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-blue-100 mr-4">
                                <i class="fas fa-user text-xl text-blue-500"></i>
                            </div>
                            <div>
                                <h3 class="text-lg font-semibold text-gray-700">Total Drivers</h3>
                                <% 
                                    int totalDrivers = driverDAO.getAllDrivers().size();
                                %>
                                <p class="text-2xl font-bold text-gray-800"><%= totalDrivers %></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white rounded-lg shadow-md p-6 border-t-4 border-green-500">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-green-100 mr-4">
                                <i class="fas fa-check-circle text-xl text-green-500"></i>
                            </div>
                            <div>
                                <h3 class="text-lg font-semibold text-gray-700">Active Assignments</h3>
                                <% 
                                    DriverVehicleDAO dvDAO = new DriverVehicleDAO();
                                    int activeAssignments = dvDAO.getAllAssignments().size();
                                %>
                                <p class="text-2xl font-bold text-gray-800"><%= activeAssignments %></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white rounded-lg shadow-md p-6 border-t-4 border-purple-500">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-purple-100 mr-4">
                                <i class="fas fa-calendar-alt text-xl text-purple-500"></i>
                            </div>
                            <div>
                                <h3 class="text-lg font-semibold text-gray-700">Available Drivers</h3>
                                <p class="text-2xl font-bold text-gray-800"><%= totalDrivers - activeAssignments %></p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Search & Filter Bar -->
                <div class="bg-white p-4 rounded-lg shadow mb-6">
                    <div class="flex flex-col md:flex-row justify-between items-center">
                        <div class="relative w-full md:w-64 mb-4 md:mb-0">
                            <input type="text" id="driverSearch" placeholder="Search drivers..." 
                                   class="w-full pl-10 pr-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-400">
                            <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                        </div>
                        <div class="flex space-x-4">
                            <select id="filterStatus" class="rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400">
                                <option value="all">All Status</option>
                                <option value="active">Active</option>
                                <option value="inactive">Available</option>
                            </select>
                            <button id="refreshBtn" class="bg-gray-200 hover:bg-gray-300 text-gray-700 py-2 px-4 rounded-lg">
                                <i class="fas fa-sync-alt mr-2"></i> Refresh
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Driver List -->
                <div class="bg-white rounded-lg shadow-md overflow-hidden">
                    <div class="overflow-x-auto">
                        <table id="driversTable" class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-100">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Driver ID</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Phone</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <% 
                                    // Get map of driver IDs to assignment status
                                    Map<String, Boolean> driverAssignmentMap = new HashMap<>();
                                    List<DriverVehicle> assignments = dvDAO.getAllAssignments();
                                    
                                    for (DriverVehicle dv : assignments) {
                                        driverAssignmentMap.put(dv.getDriverId(), true);
                                    }
                                    
                                    for (Driver driver : drivers) {
                                        boolean isAssigned = driverAssignmentMap.containsKey(driver.getDriverId());
                                %>
                                <tr class="hover:bg-gray-50 transition">
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= driver.getDriverId() %></td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-10 w-10 bg-blue-100 rounded-full flex items-center justify-center">
                                                <i class="fas fa-user text-blue-500"></i>
                                            </div>
                                            <div class="ml-4">
                                                <div class="text-sm font-medium text-gray-900"><%= driver.getFirstname() %> <%= driver.getLastname() %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= driver.getPhoneNumber() %></td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= driver.getEmail() %></td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full 
                                              <%= isAssigned ? "bg-green-100 text-green-800" : "bg-yellow-100 text-yellow-800" %>">
                                            <%= isAssigned ? "Active" : "Available" %>
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                        <div class="flex space-x-2">
                                            <button onclick="openEditModal('<%=driver.getDriverId()%>', '<%=driver.getFirstname()%>', '<%=driver.getLastname()%>', '<%=driver.getPhoneNumber()%>', '<%=driver.getEmail()%>')" class="text-indigo-600 hover:text-indigo-900">
                                                <i class="fas fa-edit"></i> Edit
                                            </button>
                                            <button onclick="confirmDelete('<%=driver.getDriverId()%>', '<%=driver.getFirstname()%> <%=driver.getLastname()%>')" class="text-red-600 hover:text-red-900">
                                                <i class="fas fa-trash-alt"></i> Delete
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
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

    <!-- Your existing JavaScript code -->
    <script>
        $(document).ready(function() {
            // Initialize DataTable
            $('#driversTable').DataTable({
                "paging": true,
                "ordering": true,
                "info": true,
                "searching": true,
                "lengthChange": true,
                "pageLength": 10,
                "language": {
                    "search": "",
                    "searchPlaceholder": "Search drivers..."
                },
                "dom": '<"top"f>rt<"bottom"lip><"clear">'
            });
            
            // Add Driver Modal
            $('#addDriverBtn').click(function() {
                $('#addDriverModal').removeClass('hidden');
            });
            
            $('#closeAddModal').click(function() {
                $('#addDriverModal').addClass('hidden');
            });
            
            // View Driver Modal
            $('.view-driver').click(function() {
                const driverId = $(this).data('id');
                
                // In a real application, fetch driver details via AJAX
                // For demo, we'll use data from the table
                const row = $(this).closest('tr');
                const name = row.find('td:eq(1)').text().trim();
                const phone = row.find('td:eq(2)').text().trim();
                const email = row.find('td:eq(3)').text().trim();
                const status = row.find('td:eq(4)').text().trim();
                
                // Populate modal with driver details
                $('#driverDetails').html(`
                    <div class="text-center text-xl font-bold mb-2">${name}</div>
                    <div class="text-center text-gray-500 mb-4">${driverId}</div>
                    <div class="grid grid-cols-1 gap-3">
                        <div class="flex items-center">
                            <div class="w-8 text-gray-500"><i class="fas fa-phone"></i></div>
                            <div>${phone}</div>
                        </div>
                        <div class="flex items-center">
                            <div class="w-8 text-gray-500"><i class="fas fa-envelope"></i></div>
                            <div>${email}</div>
                        </div>
                        <div class="flex items-center">
                            <div class="w-8 text-gray-500"><i class="fas fa-circle"></i></div>
                            <div>${status}</div>
                        </div>
                    </div>
                `);
                
                $('#viewDriverModal').removeClass('hidden');
            });
            
            $('#closeViewModal').click(function() {
                $('#viewDriverModal').addClass('hidden');
            });
            
            // Filter functionality
            $('#filterStatus').change(function() {
                const value = $(this).val();
                if (value === "all") {
                    $('#driversTable tbody tr').show();
                } else if (value === "active") {
                    $('#driversTable tbody tr').hide();
                    $('#driversTable tbody tr:contains("Active")').show();
                } else if (value === "inactive") {
                    $('#driversTable tbody tr').hide();
                    $('#driversTable tbody tr:contains("Available")').show();
                }
            });
            
            // Refresh button
            $('#refreshBtn').click(function() {
                location.reload();
            });
            
            // Close modals when clicking outside
            $(window).click(function(e) {
                if ($(e.target).is('#addDriverModal')) {
                    $('#addDriverModal').addClass('hidden');
                }
                if ($(e.target).is('#viewDriverModal')) {
                    $('#viewDriverModal').addClass('hidden');
                }
            });
        });

        function confirmDelete(driverId, driverName) {
            document.getElementById('deleteDriverId').value = driverId;
            document.getElementById('deleteConfirmationText').textContent = 
                `Are you sure you want to delete the driver ${driverName}? This action cannot be undone.`;
            document.getElementById('deleteModal').classList.remove('hidden');
        }

        function closeModal(modalId) {
            document.getElementById(modalId).classList.add('hidden');
        }
    </script>
</body>
</html>
