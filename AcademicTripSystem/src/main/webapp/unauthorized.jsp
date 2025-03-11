<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.model.User" %>
<%
    // Get current user
    User currentUser = (User) session.getAttribute("user");
    
    // Determine unauthorized access type
    boolean isLoggedIn = (currentUser != null);
    String redirectPath = isLoggedIn ? request.getContextPath() + "/dashboard.jsp" : request.getContextPath() + "/login.jsp";
    
    // Get redirect URL parameter if available
    String redirectUrl = request.getParameter("redirect");
    if (redirectUrl != null && !redirectUrl.isEmpty()) {
        redirectPath = redirectUrl;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unauthorized Access | Academic Trip System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="min-h-screen flex flex-col">
        <header class="bg-white shadow-md">
            <div class="container mx-auto px-4 py-4 flex justify-between items-center">
                <a href="${pageContext.request.contextPath}/index.jsp" class="text-2xl font-bold text-primary">
                    <i class="fas fa-bus mr-2"></i> Academic Trip System
                </a>
                <% if (isLoggedIn) { %>
                <div class="flex items-center">
                    <div class="text-sm text-gray-700 mr-4">
                        Signed in as <span class="font-medium"><%= currentUser.getUsername() %></span>
                    </div>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-outline">
                        <i class="fas fa-sign-out-alt mr-1"></i> Logout
                    </a>
                </div>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn-outline">
                    <i class="fas fa-sign-in-alt mr-1"></i> Login
                </a>
                <% } %>
            </div>
        </header>

        <div class="container mx-auto px-4 py-8 flex-grow">
            <div class="bg-white p-6 rounded-lg shadow-md text-center">
                <div class="text-6xl text-red-500 mb-4">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <h1 class="text-3xl font-bold mb-4">Unauthorized Access</h1>
                <p class="text-gray-700 mb-6">You don't have permission to access this resource. Please contact your administrator if you believe this is an error.</p>
                <a href="<%= redirectPath %>" class="btn-primary">
                    <i class="fas fa-home mr-2"></i> Return to Home
                </a>
            </div>
        </div>

        <footer class="bg-white shadow-md">
            <div class="container mx-auto px-4 py-4 text-center">
                &copy; <%= new java.util.Date().getYear() + 1900 %> Academic Trip System. All rights reserved.
            </div>
        </footer>
    </div>
</body>
</html>
