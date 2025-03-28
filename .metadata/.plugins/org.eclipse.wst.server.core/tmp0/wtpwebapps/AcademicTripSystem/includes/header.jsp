<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.model.User" %>
<%
    // Get current user
    User headerUser = (User) session.getAttribute("user");
    
    // Get current page to highlight active menu item
    String currentPage = request.getRequestURI();
    String contextPath = request.getContextPath();
    currentPage = currentPage.substring(currentPage.lastIndexOf("/") + 1);
    
    // Determine user role for menu customization
    boolean isLecturer = headerUser != null && "lecturer".equalsIgnoreCase(headerUser.getRole());
    boolean isAdmin = headerUser != null && "admin".equalsIgnoreCase(headerUser.getRole());
    boolean isDriver = headerUser != null && "driver".equalsIgnoreCase(headerUser.getRole());
%>

<header class="bg-white shadow-md">
    <div class="container mx-auto px-4">
        <div class="flex justify-between items-center py-4">
            <!-- Logo -->
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/index.jsp" class="text-primary text-2xl font-bold">
                    <i class="fas fa-bus mr-2"></i>
                    Academic Trip System
                </a>
            </div>
            
            <!-- User Menu -->
            <% if (headerUser != null) { %>
                <div class="flex items-center">
                    <% if (isLecturer) { %>
                        <!-- Lecturer Navigation -->
                        <nav class="hidden md:flex items-center mr-6">
                            <a href="${pageContext.request.contextPath}/lecturer/dashboard.jsp" 
                               class="nav-link <%= currentPage.equals("dashboard.jsp") ? "active" : "" %>">
                                <i class="fas fa-tachometer-alt mr-1"></i> Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/lecturer/addTrip.jsp" 
                               class="nav-link <%= currentPage.equals("addTrip.jsp") ? "active" : "" %>">
                                <i class="fas fa-plus-circle mr-1"></i> New Trip
                            </a>
                            <a href="${pageContext.request.contextPath}/lecturer/viewTrips.jsp" 
                               class="nav-link <%= currentPage.equals("viewTrips.jsp") ? "active" : "" %>">
                                <i class="fas fa-list mr-1"></i> My Trips
                            </a>
                            <a href="${pageContext.request.contextPath}/lecturer/viewTimetable.jsp" 
                               class="nav-link <%= currentPage.equals("viewTimetable.jsp") ? "active" : "" %>">
                                <i class="fas fa-calendar-alt mr-1"></i> Timetable
                            </a>
                            <a href="${pageContext.request.contextPath}/lecturer/profile.jsp" 
                               class="nav-link <%= currentPage.equals("profile.jsp") ? "active" : "" %>">
                                <i class="fas fa-user-circle mr-1"></i> Profile
                            </a>
                        </nav>
                    <% } %>
                    
                    <!-- User dropdown -->
                    <div class="relative inline-block text-left" id="userMenu">
                        <div>
                            <button type="button" class="user-dropdown-button" id="userMenuButton">
                                <div class="flex items-center">
                                    <div class="h-8 w-8 rounded-full bg-primary flex items-center justify-center text-white text-sm font-medium uppercase">
                                        <%= headerUser.getName() != null ? headerUser.getName().substring(0, 1) : "U" %>
                                    </div>
                                    <span class="ml-2 hidden md:inline-block text-gray-700">
                                        <%= headerUser.getName() != null ? headerUser.getName() : "User" %>
                                    </span>
                                    <i class="fas fa-chevron-down ml-2 text-gray-400 text-xs"></i>
                                </div>
                            </button>
                        </div>
                        
                        <!-- Dropdown menu -->
                        <div class="user-dropdown-menu hidden" id="userDropdownMenu">
                            <div class="py-2">
                                <div class="px-4 py-2 border-b border-gray-100">
                                    <p class="text-sm font-medium text-gray-900">Signed in as</p>
                                    <p class="text-sm text-gray-600 truncate"><%= headerUser.getUsername() %></p>
                                </div>
                                
                                <% if (isLecturer) { %>
                                    <a href="${pageContext.request.contextPath}/lecturer/profile.jsp" class="dropdown-item">
                                        <i class="fas fa-user-circle mr-2 text-gray-500"></i> Profile
                                    </a>
                                    <a href="${pageContext.request.contextPath}/lecturer/dashboard.jsp" class="dropdown-item">
                                        <i class="fas fa-tachometer-alt mr-2 text-gray-500"></i> Dashboard
                                    </a>
                                <% } %>
                                
                                <a href="${pageContext.request.contextPath}/logout" class="dropdown-item border-t border-gray-100 text-red-600 hover:text-red-800 hover:bg-red-50">
                                    <i class="fas fa-sign-out-alt mr-2"></i> Sign out
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Mobile menu button -->
                    <div class="ml-4 md:hidden">
                        <button type="button" id="mobileMenuButton" class="text-gray-500 hover:text-gray-700 focus:outline-none">
                            <i class="fas fa-bars text-lg"></i>
                        </button>
                    </div>
                </div>
            <% } else { %>
                <!-- Not logged in -->
                <div>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn-outline">
                        <i class="fas fa-sign-in-alt mr-1"></i> Login
                    </a>
                </div>
            <% } %>
        </div>
        
        <!-- Mobile menu -->
        <% if (headerUser != null) { %>
            <div class="md:hidden hidden" id="mobileMenu">
                <div class="pt-2 pb-4 border-t border-gray-200">
                    <% if (isLecturer) { %>
                        <a href="${pageContext.request.contextPath}/lecturer/dashboard.jsp" 
                           class="mobile-nav-link <%= currentPage.equals("dashboard.jsp") ? "bg-primary text-white" : "" %>">
                            <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/lecturer/addTrip.jsp" 
                           class="mobile-nav-link <%= currentPage.equals("addTrip.jsp") ? "bg-primary text-white" : "" %>">
                            <i class="fas fa-plus-circle mr-2"></i> New Trip
                        </a>
                        <a href="${pageContext.request.contextPath}/lecturer/viewTrips.jsp" 
                           class="mobile-nav-link <%= currentPage.equals("viewTrips.jsp") ? "bg-primary text-white" : "" %>">
                            <i class="fas fa-list mr-2"></i> My Trips
                        </a>
                        <a href="${pageContext.request.contextPath}/lecturer/viewTimetable.jsp" 
                           class="mobile-nav-link <%= currentPage.equals("viewTimetable.jsp") ? "bg-primary text-white" : "" %>">
                            <i class="fas fa-calendar-alt mr-2"></i> Timetable
                        </a>
                        <a href="${pageContext.request.contextPath}/lecturer/profile.jsp" 
                           class="mobile-nav-link <%= currentPage.equals("profile.jsp") ? "bg-primary text-white" : "" %>">
                            <i class="fas fa-user-circle mr-2"></i> Profile
                        </a>
                    <% } %>
                    <a href="${pageContext.request.contextPath}/logout" class="mobile-nav-link text-red-600">
                        <i class="fas fa-sign-out-alt mr-2"></i> Sign out
                    </a>
                </div>
            </div>
        <% } %>
    </div>
</header>

<!-- Add necessary CSS for the header -->
<style>
    .nav-link {
        @apply px-4 py-2 text-gray-700 hover:text-primary transition-colors;
    }
    .nav-link.active {
        @apply text-primary font-medium;
    }
    .dropdown-item {
        @apply block w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 cursor-pointer;
    }
    .user-dropdown-button {
        @apply inline-flex justify-center w-full rounded-md px-3 py-2 bg-white hover:bg-gray-50 focus:outline-none;
    }
    .user-dropdown-menu {
        @apply absolute right-0 w-56 mt-2 origin-top-right bg-white rounded-md shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none z-10;
    }
    .mobile-nav-link {
        @apply block px-4 py-3 text-base font-medium text-gray-700 hover:bg-gray-100 transition-colors;
    }
</style>

<!-- JavaScript for the header dropdowns and mobile menu -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const userMenuButton = document.getElementById('userMenuButton');
        const userDropdownMenu = document.getElementById('userDropdownMenu');
        const mobileMenuButton = document.getElementById('mobileMenuButton');
        const mobileMenu = document.getElementById('mobileMenu');
        
        // Handle user dropdown toggle
        if (userMenuButton && userDropdownMenu) {
            userMenuButton.addEventListener('click', function() {
                userDropdownMenu.classList.toggle('hidden');
            });
            
            // Close dropdown when clicking outside
            document.addEventListener('click', function(event) {
                if (!userMenuButton.contains(event.target) && !userDropdownMenu.contains(event.target)) {
                    userDropdownMenu.classList.add('hidden');
                }
            });
        }
        
        // Handle mobile menu toggle
        if (mobileMenuButton && mobileMenu) {
            mobileMenuButton.addEventListener('click', function() {
                mobileMenu.classList.toggle('hidden');
            });
        }
    });
</script>
