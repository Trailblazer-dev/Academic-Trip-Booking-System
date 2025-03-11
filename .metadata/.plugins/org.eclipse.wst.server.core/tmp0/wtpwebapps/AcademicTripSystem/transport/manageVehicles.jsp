<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.dao.VehicleDAO" %>
<%@ page import="com.academictrip.model.Vehicle" %>
<%@ page import="java.util.List" %>
<%
    // Your existing code for vehicle management
    VehicleDAO vehicleDAO = new VehicleDAO();
    List<Vehicle> vehicles = vehicleDAO.getAllVehicles();
    
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
    <title>Manage Vehicles | Academic Trip System</title>
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
                            <i class="fas fa-bus mr-2 text-secondary"></i>Manage Vehicles
                        </h1>
                        <p class="mt-1 text-sm text-gray-500">Add, edit and manage the fleet of vehicles available for academic trips.</p>
                    </div>
                    <div class="mt-4 md:mt-0">
                        <button id="addVehicleBtn" class="btn btn-secondary hover:bg-orange-700 text-white py-2 px-4 rounded-lg flex items-center">
                            <i class="fas fa-plus-circle mr-2"></i> Add New Vehicle
                        </button>
                    </div>
                </div>
                
                <!-- Alert Messages -->
                <% if (successMessage != null && !successMessage.isEmpty()) { %>
                    <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-6" id="successAlert">
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

                <!-- Vehicle List -->
                <div class="bg-white shadow-md rounded-lg overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Registration</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Make & Model</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Capacity</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <% if (vehicles != null && !vehicles.isEmpty()) { 
                                    for (Vehicle vehicle : vehicles) { %>
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"><%= vehicle.getRegistration() %></td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= vehicle.getMake() %> <%= vehicle.getModel() %></td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= vehicle.getType() %></td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= vehicle.getCapacity() %> passengers</td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <% if (vehicle.isAvailable()) { %>
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Available</span>
                                            <% } else { %>
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">In Use</span>
                                            <% } %>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                            <div class="flex space-x-2">
                                                <button onclick="openEditModal('<%= vehicle.getVehicleId() %>', '<%= vehicle.getRegistration() %>', '<%= vehicle.getMake() %>', '<%= vehicle.getModel() %>', '<%= vehicle.getYear() %>', '<%= vehicle.getType() %>', '<%= vehicle.getCapacity() %>')" class="text-indigo-600 hover:text-indigo-900">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <button onclick="confirmDelete('<%= vehicle.getVehicleId() %>', '<%= vehicle.getMake() %> <%= vehicle.getModel() %>')" class="text-red-600 hover:text-red-900">
                                                    <i class="fas fa-trash-alt"></i> Delete
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                <% } } else { %>
                                    <tr>
                                        <td colspan="6" class="px-6 py-4 text-center text-sm text-gray-500">No vehicles available</td>
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

    <!-- Add Vehicle Modal -->
    <div id="addVehicleModal" class="fixed z-10 inset-0 overflow-y-auto hidden">
        <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center">
            <div class="fixed inset-0 transition-opacity" aria-hidden="true">
                <div class="absolute inset-0 bg-gray-500 opacity-75" onclick="closeModal('addVehicleModal')"></div>
            </div>
            <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                    <div>
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4" id="modal-title">
                            Add New Vehicle
                        </h3>
                        <form id="addVehicleForm" action="${pageContext.request.contextPath}/transport/addVehicleAction" method="post">
                            <div class="grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
                                <div class="sm:col-span-3">
                                    <label for="registration" class="block text-sm font-medium text-gray-700">Registration Number <span class="text-red-500">*</span></label>
                                    <div class="mt-1">
                                        <input type="text" name="registration" id="registration" required
                                               class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                    </div>
                                </div>
                                <div class="sm:col-span-3">
                                    <label for="make" class="block text-sm font-medium text-gray-700">Make <span class="text-red-500">*</span></label>
                                    <div class="mt-1">
                                        <input type="text" name="make" id="make" required
                                               class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                    </div>
                                </div>
                                <div class="sm:col-span-3">
                                    <label for="model" class="block text-sm font-medium text-gray-700">Model <span class="text-red-500">*</span></label>
                                    <div class="mt-1">
                                        <input type="text" name="model" id="model" required
                                               class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                    </div>
                                </div>
                                <div class="sm:col-span-3">
                                    <label for="year" class="block text-sm font-medium text-gray-700">Year <span class="text-red-500">*</span></label>
                                    <div class="mt-1">
                                        <input type="number" name="year" id="year" min="2000" max="2100" required
                                               class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                    </div>
                                </div>
                                <div class="sm:col-span-3">
                                    <label for="type" class="block text-sm font-medium text-gray-700">Type <span class="text-red-500">*</span></label>
                                    <div class="mt-1">
                                        <select id="type" name="type" required
                                               class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                            <option value="">Select a vehicle type</option>
                                            <option value="Bus">Bus</option>
                                            <option value="Van">Van</option>
                                            <option value="Car">Car</option>
                                            <option value="Minibus">Minibus</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="sm:col-span-3">
                                    <label for="capacity" class="block text-sm font-medium text-gray-700">Passenger Capacity <span class="text-red-500">*</span></label>
                                    <div class="mt-1">
                                        <input type="number" name="capacity" id="capacity" min="1" max="100" required
                                               class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                    </div>
                                </div>
                            </div>
                            <div class="mt-5 sm:mt-6 sm:grid sm:grid-cols-2 sm:gap-3 sm:grid-flow-row-dense">
                                <button type="submit" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-indigo-600 text-base font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:col-start-2 sm:text-sm">
                                    Add Vehicle
                                </button>
                                <button type="button" onclick="closeModal('addVehicleModal')" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:col-start-1 sm:text-sm">
                                    Cancel
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Vehicle Modal -->
    <div id="editVehicleModal" class="fixed z-10 inset-0 overflow-y-auto hidden">
        <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center">
            <div class="fixed inset-0 transition-opacity" aria-hidden="true">
                <div class="absolute inset-0 bg-gray-500 opacity-75" onclick="closeModal('editVehicleModal')"></div>
            </div>
            <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                    <div>
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4" id="modal-title">
                            Edit Vehicle
                        </h3>
                        <form id="editVehicleForm" action="${pageContext.request.contextPath}/transport/editVehicle" method="post">
                            <input type="hidden" id="editVehicleId" name="vehicleId">
                            <div class="grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
                                <div class="sm:col-span-3">
                                    <label for="editRegistration" class="block text-sm font-medium text-gray-700">Registration Number <span class="text-red-500">*</span></label>
                                    <div class="mt-1">
                                        <input type="text" name="registration" id="editRegistration" required
                                               class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                    </div>
                                </div>
                                <div class="sm:col-span-3">
                                    <label for="editMake" class="block text-sm font-medium text-gray-700">Make <span class="text-red-500">*</span></label>
                                    <div class="mt-1">
                                        <input type="text" name="make" id="editMake" required
                                               class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                    </div>
                                </div>
                                <div class="sm:col-span-3">
                                    <label for="editModel" class="block text-sm font-medium text-gray-700">Model <span class="text-red-500">*</span></label>
                                    <div class="mt-1">
                                        <input type="text" name="model" id="editModel" required
                                               class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                    </div>
                                </div>
                                <div class="sm:col-span-3">
                                    <label for="editYear" class="block text-sm font-medium text-gray-700">Year <span class="text-red-500">*</span></label>
                                    <div class="mt-1">
                                        <input type="number" name="year" id="editYear" min="2000" max="2100" required
                                               class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                    </div>
                                </div>
                                <div class="sm:col-span-3">
                                    <label for="editType" class="block text-sm font-medium text-gray-700">Type <span class="text-red-500">*</span></label>
                                    <div class="mt-1">
                                        <select id="editType" name="type" required
                                               class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                            <option value="">Select a vehicle type</option>
                                            <option value="Bus">Bus</option>
                                            <option value="Van">Van</option>
                                            <option value="Car">Car</option>
                                            <option value="Minibus">Minibus</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="sm:col-span-3">
                                    <label for="editCapacity" class="block text-sm font-medium text-gray-700">Passenger Capacity <span class="text-red-500">*</span></label>
                                    <div class="mt-1">
                                        <input type="number" name="capacity" id="editCapacity" min="1" max="100" required
                                               class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                    </div>
                                </div>
                            </div>
                            <div class="mt-5 sm:mt-6 sm:grid sm:grid-cols-2 sm:gap-3 sm:grid-flow-row-dense">
                                <button type="submit" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-indigo-600 text-base font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:col-start-2 sm:text-sm">
                                    Update Vehicle
                                </button>
                                <button type="button" onclick="closeModal('editVehicleModal')" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:col-start-1 sm:text-sm">
                                    Cancel
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="fixed z-10 inset-0 overflow-y-auto hidden">
        <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center">
            <div class="fixed inset-0 transition-opacity" aria-hidden="true">
                <div class="absolute inset-0 bg-gray-500 opacity-75" onclick="closeModal('deleteModal')"></div>
            </div>
            <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                    <div class="sm:flex sm:items-start">
                        <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                            <i class="fas fa-exclamation-triangle text-red-600"></i>
                        </div>
                        <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                            <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
                                Delete Vehicle
                            </h3>
                            <div class="mt-2">
                                <p class="text-sm text-gray-500" id="deleteConfirmationText">
                                    Are you sure you want to delete this vehicle? This action cannot be undone.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <form id="deleteVehicleForm" action="${pageContext.request.contextPath}/transport/deleteVehicle" method="post">
                    <input type="hidden" id="deleteVehicleId" name="vehicleId">
                    <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                        <button type="submit" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm">
                            Delete
                        </button>
                        <button type="button" onclick="closeModal('deleteModal')" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                            Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Your existing JavaScript code -->
    <script>
        // Modal handling functions
        function openAddModal() {
            document.getElementById('addVehicleModal').classList.remove('hidden');
        }
        
        function openEditModal(vehicleId, registration, make, model, year, type, capacity) {
            document.getElementById('editVehicleId').value = vehicleId;
            document.getElementById('editRegistration').value = registration;
            document.getElementById('editMake').value = make;
            document.getElementById('editModel').value = model;
            document.getElementById('editYear').value = year;
            document.getElementById('editType').value = type;
            document.getElementById('editCapacity').value = capacity;
            document.getElementById('editVehicleModal').classList.remove('hidden');
        }
        
        function confirmDelete(vehicleId, vehicleName) {
            document.getElementById('deleteVehicleId').value = vehicleId;
            document.getElementById('deleteConfirmationText').textContent = 
                `Are you sure you want to delete the vehicle ${vehicleName}? This action cannot be undone.`;
            document.getElementById('deleteModal').classList.remove('hidden');
        }
        
        function closeModal(modalId) {
            document.getElementById(modalId).classList.add('hidden');
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                const alerts = document.querySelectorAll('#successAlert, #errorAlert');
                alerts.forEach(alert => {
                    if (alert) alert.style.display = 'none';
                });
            }, 5000);
            
            // Form validation
            const forms = document.querySelectorAll('#addVehicleForm, #editVehicleForm');
            forms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const requiredFields = form.querySelectorAll('[required]');
                    let isValid = true;
                    
                    requiredFields.forEach(field => {
                        if (!field.value.trim()) {
                            isValid = false;
                            field.classList.add('border-red-500');
                        } else {
                            field.classList.remove('border-red-500');
                        }
                    });
                    
                    if (!isValid) {
                        e.preventDefault();
                        alert('Please fill in all required fields');
                    }
                });
            });
            
            // Add keyboard event for ESC key to close modals
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    const modals = document.querySelectorAll('#addVehicleModal, #editVehicleModal, #deleteModal');
                    modals.forEach(modal => {
                        if (!modal.classList.contains('hidden')) {
                            modal.classList.add('hidden');
                        }
                    });
                }
            });
        });
    </script>
</body>
</html>
