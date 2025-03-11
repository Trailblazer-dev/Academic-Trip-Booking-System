<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.model.User" %>
<%
    User headerUser = (User) session.getAttribute("user");
    String userRole = headerUser != null ? headerUser.getRole() : "";
    boolean isLecturerRole = "lecturer".equalsIgnoreCase(userRole);
    boolean isTransportRole = "transport".equalsIgnoreCase(userRole);
    String currentPage = request.getRequestURI();
%>

<header class="bg-white shadow-md mb-6">
    <div class="container mx-auto px-4">
        <div class="flex justify-between items-center py-4">
            <!-- Logo and System Name -->
            <div class="flex items-center">
                <div class="bg-primary rounded-full p-2 mr-3">
                    <i class="fas fa-bus text-white text-xl"></i>
                </div>
                <div>
                    <h1 class="text-xl font-bold text-gray-800">Academic Trip System</h1>
                    <p class="text-xs text-gray-500"><%= isLecturerRole ? "Lecturer Portal" : (isTransportRole ? "Transport Management" : "Admin Portal") %></p>
                </div>
            </div>
            
            <!-- Navigation Menu -->
            <nav class="hidden md:flex space-x-6">
                <% if(isLecturerRole) { %>
                    <a href="${pageContext.request.contextPath}/lecturer/dashboard.jsp" 
                       class="<%= currentPage.contains("/lecturer/dashboard.jsp") ? "text-primary font-medium" : "text-gray-600 hover:text-primary" %> flex items-center transition-colors">
                        <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/lecturer/addTrip.jsp" 
                       class="<%= currentPage.contains("/lecturer/addTrip.jsp") ? "text-primary font-medium" : "text-gray-600 hover:text-primary" %> flex items-center transition-colors">
                        <i class="fas fa-plus-circle mr-2"></i> New Trip
                    </a>
                    <a href="${pageContext.request.contextPath}/lecturer/viewTimetable.jsp" 
                       class="<%= currentPage.contains("/lecturer/viewTimetable.jsp") ? "text-primary font-medium" : "text-gray-600 hover:text-primary" %> flex items-center transition-colors">
                        <i class="fas fa-calendar-alt mr-2"></i> Timetable
                    </a>
                <% } else if(isTransportRole) { %>
                    <a href="${pageContext.request.contextPath}/transport/dashboard.jsp" 
                       class="<%= currentPage.contains("/transport/dashboard.jsp") ? "text-primary font-medium" : "text-gray-600 hover:text-primary" %> flex items-center transition-colors">
                        <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/transport/assignResources.jsp" 
                       class="<%= currentPage.contains("/transport/assignResources.jsp") ? "text-primary font-medium" : "text-gray-600 hover:text-primary" %> flex items-center transition-colors">
                        <i class="fas fa-tasks mr-2"></i> Assign Resources
                    </a>
                    <a href="${pageContext.request.contextPath}/transport/viewAssignments.jsp" 
                       class="<%= currentPage.contains("/transport/viewAssignments.jsp") ? "text-primary font-medium" : "text-gray-600 hover:text-primary" %> flex items-center transition-colors">
                        <i class="fas fa-clipboard-list mr-2"></i> Assignments
                    </a>
                <% } %>
            </nav>
            
            <!-- User Menu -->
            <div class="flex items-center">
                <% if(headerUser != null) { %>
                    <div class="relative" id="userMenuContainer">
                        <button id="userMenuButton" class="flex items-center space-x-2 p-2 rounded-full hover:bg-gray-100 focus:outline-none">
                            <div class="h-8 w-8 rounded-full bg-primary flex items-center justify-center">
                                <span class="text-white font-medium"><%= headerUser.getName() != null ? headerUser.getName().substring(0, 1).toUpperCase() : "U" %></span>
                            </div>
                            <div class="hidden md:block text-left">
                                <p class="text-sm font-medium text-gray-700"><%= headerUser.getName() != null ? headerUser.getName() : userRole %></p>
                                <p class="text-xs text-gray-500"><%= userRole %></p>
                            </div>
                            <i class="fas fa-chevron-down text-xs text-gray-400 ml-2"></i>
                        </button>
                        
                        <!-- Dropdown Menu -->
                        <div id="userMenu" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-10 hidden">
                            <a href="${pageContext.request.contextPath}/profile.jsp" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                <i class="fas fa-user-circle mr-2"></i> Profile
                            </a>
                            <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                <i class="fas fa-key mr-2"></i> Change Password
                            </a>
                            <div class="border-t border-gray-100 my-1"></div>
                            <a href="${pageContext.request.contextPath}/LogoutServlet" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                <i class="fas fa-sign-out-alt mr-2"></i> Logout
                            </a>
                        </div>
                    </div>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="text-gray-600 hover:text-primary">
                        <i class="fas fa-sign-in-alt mr-2"></i> Login
                    </a>
                <% } %>
                
                <!-- Mobile menu button -->
                <button id="mobileMenuButton" class="md:hidden ml-4 focus:outline-none">
                    <i class="fas fa-bars text-gray-600 text-xl"></i>
                </button>
            </div>
        </div>
        
        <!-- Mobile Navigation Menu -->
        <div id="mobileMenu" class="md:hidden border-t border-gray-200 hidden pb-4 pt-2">
            <% if(isLecturerRole) { %>
                <a href="${pageContext.request.contextPath}/lecturer/dashboard.jsp" 
                   class="block py-2 px-4 text-gray-600 hover:bg-gray-100 flex items-center">
                    <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/lecturer/addTrip.jsp" 
                   class="block py-2 px-4 text-gray-600 hover:bg-gray-100 flex items-center">
                    <i class="fas fa-plus-circle mr-2"></i> New Trip
                </a>
                <a href="${pageContext.request.contextPath}/lecturer/viewTimetable.jsp" 
                   class="block py-2 px-4 text-gray-600 hover:bg-gray-100 flex items-center">
                    <i class="fas fa-calendar-alt mr-2"></i> Timetable
                </a>
            <% } else if(isTransportRole) { %>
                <a href="${pageContext.request.contextPath}/transport/dashboard.jsp" 
                   class="block py-2 px-4 text-gray-600 hover:bg-gray-100 flex items-center">
                    <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/transport/assignResources.jsp" 
                   class="block py-2 px-4 text-gray-600 hover:bg-gray-100 flex items-center">
                    <i class="fas fa-tasks mr-2"></i> Assign Resources
                </a>
                <a href="${pageContext.request.contextPath}/transport/viewAssignments.jsp" 
                   class="block py-2 px-4 text-gray-600 hover:bg-gray-100 flex items-center">
                    <i class="fas fa-clipboard-list mr-2"></i> Assignments
                </a>
            <% } %>
        </div>
    </div>
</header>

<script>
    // Toggle user dropdown menu
    document.getElementById('userMenuButton')?.addEventListener('click', function() {
        document.getElementById('userMenu').classList.toggle('hidden');
    });
    
    // Close the dropdown when clicking outside
    document.addEventListener('click', function(event) {
        const userMenuContainer = document.getElementById('userMenuContainer');
        const userMenu = document.getElementById('userMenu');
        if (userMenuContainer && !userMenuContainer.contains(event.target)) {
            userMenu.classList.add('hidden');
        }
    });
    
    // Mobile menu toggle
    document.getElementById('mobileMenuButton')?.addEventListener('click', function() {
        document.getElementById('mobileMenu').classList.toggle('hidden');
    });
</script>
