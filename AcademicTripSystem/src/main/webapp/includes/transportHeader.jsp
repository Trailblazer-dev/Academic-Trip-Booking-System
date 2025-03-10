<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.model.User" %>
<%
    // Define these variables here so they're available to all pages that include this header
    String pageName = request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1);
    User currentUser = (User) session.getAttribute("user");
    
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<div class="bg-indigo-800 shadow-md">
    <div class="max-w-7xl mx-auto px-2 sm:px-4 lg:px-8">
        <div class="relative flex items-center justify-between h-16">
            <!-- Mobile menu button -->
            <div class="absolute inset-y-0 left-0 flex items-center sm:hidden">
                <button type="button" id="mobile-menu-button"
                        class="inline-flex items-center justify-center p-2 rounded-md text-indigo-200 hover:text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white">
                    <span class="sr-only">Open main menu</span>
                    <i class="fas fa-bars text-xl"></i>
                </button>
            </div>
            
            <!-- Logo and site name -->
            <div class="flex-1 flex items-center justify-center sm:items-stretch sm:justify-start">
                <div class="flex-shrink-0 flex items-center">
                    <a href="${pageContext.request.contextPath}/dashboard.jsp" class="flex items-center">
                        <i class="fas fa-bus-alt text-white text-2xl"></i>
                        <span class="ml-2 text-white font-bold text-lg hidden md:block">ATS Transport</span>
                    </a>
                </div>
                
                <!-- Desktop Navigation -->
                <div class="hidden sm:block sm:ml-6">
                    <nav class="flex space-x-1">
                        <a href="${pageContext.request.contextPath}/transport/dashboard.jsp" 
                           class="px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-indigo-600 flex items-center transition-colors <%= pageName.equals("dashboard.jsp") ? "bg-indigo-700" : "" %>">
                            <i class="fas fa-tachometer-alt mr-1"></i> Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/transport/manageDrivers.jsp" 
                           class="px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-indigo-600 flex items-center transition-colors <%= pageName.equals("manageDrivers.jsp") ? "bg-indigo-700" : "" %>">
                            <i class="fas fa-user-tie mr-1"></i> Drivers
                        </a>
                        <a href="${pageContext.request.contextPath}/transport/manageVehicles.jsp" 
                           class="px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-indigo-600 flex items-center transition-colors <%= pageName.equals("manageVehicles.jsp") ? "bg-indigo-700" : "" %>">
                            <i class="fas fa-car mr-1"></i> Vehicles
                        </a>
                        <a href="${pageContext.request.contextPath}/transport/assignResources.jsp" 
                           class="px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-indigo-600 flex items-center transition-colors <%= pageName.equals("assignResources.jsp") ? "bg-indigo-700" : "" %>">
                            <i class="fas fa-clipboard-list mr-1"></i> Assign
                        </a>
                        <a href="${pageContext.request.contextPath}/transport/viewAssignments.jsp" 
                           class="px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-indigo-600 flex items-center transition-colors <%= pageName.equals("viewAssignments.jsp") ? "bg-indigo-700" : "" %>">
                            <i class="fas fa-list-alt mr-1"></i> Assignments
                        </a>
                    </nav>
                </div>
            </div>
            
            <!-- User Menu -->
            <div class="hidden md:block">
                <div class="flex items-center">
                    <div class="relative ml-3">
                        <button type="button" 
                                class="max-w-xs flex items-center text-sm rounded-full text-white focus:outline-none transition-colors group"
                                id="userMenuButton" 
                                onclick="document.getElementById('userDropdown').classList.toggle('hidden')">
                            <span class="bg-indigo-600 p-2 rounded-lg group-hover:bg-indigo-700">
                                <i class="fas fa-user-circle text-xl mr-2"></i>
                                <% if(currentUser != null) { %>
                                <%= currentUser.getUsername() %>
                                <% } %>
                                <i class="fas fa-chevron-down ml-1 text-xs"></i>
                            </span>
                        </button>
                        
                        <!-- Profile dropdown panel -->
                        <div id="userDropdown" class="hidden origin-top-right absolute right-0 mt-2 w-48 rounded-md shadow-lg py-1 bg-white ring-1 ring-black ring-opacity-5 focus:outline-none z-10" role="menu" aria-orientation="vertical" aria-labelledby="user-menu-button">
                            <a href="${pageContext.request.contextPath}/profile.jsp" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">
                                <i class="fas fa-user mr-2"></i> Your Profile
                            </a>
                            <a href="${pageContext.request.contextPath}/settings.jsp" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">
                                <i class="fas fa-cog mr-2"></i> Settings
                            </a>
                            <hr class="my-1">
                            <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">
                                <i class="fas fa-sign-out-alt mr-2"></i> Sign out
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Mobile menu, show/hide based on menu state -->
    <div class="sm:hidden hidden" id="mobile-menu">
        <div class="px-2 pt-2 pb-3 space-y-1 bg-indigo-800 border-t border-indigo-700">
            <a href="${pageContext.request.contextPath}/transport/dashboard.jsp" 
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors <%= pageName.equals("dashboard.jsp") ? "bg-indigo-700" : "" %>">
                <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
            </a>
            
            <a href="${pageContext.request.contextPath}/transport/manageDrivers.jsp" 
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors <%= pageName.equals("manageDrivers.jsp") ? "bg-indigo-700" : "" %>">
                <i class="fas fa-user-tie mr-2"></i> Manage Drivers
            </a>
            
            <a href="${pageContext.request.contextPath}/transport/manageVehicles.jsp" 
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors <%= pageName.equals("manageVehicles.jsp") ? "bg-indigo-700" : "" %>">
                <i class="fas fa-car mr-2"></i> Manage Vehicles
            </a>
            
            <a href="${pageContext.request.contextPath}/transport/assignResources.jsp" 
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors <%= pageName.equals("assignResources.jsp") ? "bg-indigo-700" : "" %>">
                <i class="fas fa-clipboard-list mr-2"></i> Assign Resources
            </a>
            
            <a href="${pageContext.request.contextPath}/transport/viewAssignments.jsp" 
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors <%= pageName.equals("viewAssignments.jsp") ? "bg-indigo-700" : "" %>">
                <i class="fas fa-list-alt mr-2"></i> View Assignments
            </a>
            
            <hr class="border-indigo-600 my-2">
            
            <a href="${pageContext.request.contextPath}/profile.jsp" 
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors">
                <i class="fas fa-user mr-2"></i> Your Profile
            </a>
            
            <a href="${pageContext.request.contextPath}/settings.jsp" 
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors">
                <i class="fas fa-cog mr-2"></i> Settings
            </a>
            
            <a href="${pageContext.request.contextPath}/logout" 
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors">
                <i class="fas fa-sign-out-alt mr-2"></i> Sign out
            </a>
        </div>
    </div>
</div>

<script>
    // Toggle mobile menu
    document.getElementById('mobile-menu-button').addEventListener('click', function() {
        document.getElementById('mobile-menu').classList.toggle('hidden');
    });
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(event) {
        const userMenuButton = document.getElementById('userMenuButton');
        const userDropdown = document.getElementById('userDropdown');
        
        if (userMenuButton && userDropdown && !userMenuButton.contains(event.target) && !userDropdown.contains(event.target)) {
            userDropdown.classList.add('hidden');
        }
    });
</script>
