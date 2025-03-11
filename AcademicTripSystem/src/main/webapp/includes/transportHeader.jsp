<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academictrip.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userRole = currentUser != null ? currentUser.getRole() : "";
    String pageName = request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1);
%>
<header>
    <div class="header-container">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/transport/dashboard.jsp">
                Academic Trip System
            </a>
        </div>
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/transport/dashboard.jsp" class="<%= pageName.equals("dashboard.jsp") ? "active" : "" %>">
                    <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
                </a></li>
                <li><a href="${pageContext.request.contextPath}/transport/manageDrivers.jsp" class="<%= pageName.equals("manageDrivers.jsp") ? "active" : "" %>">
                    <i class="fas fa-users mr-2"></i> Drivers
                </a></li>
                <li><a href="${pageContext.request.contextPath}/transport/manageVehicles.jsp" class="<%= pageName.equals("manageVehicles.jsp") ? "active" : "" %>">
                    <i class="fas fa-bus mr-2"></i> Vehicles
                </a></li>
                <li><a href="${pageContext.request.contextPath}/transport/assignResources.jsp" class="<%= pageName.equals("assignResources.jsp") ? "active" : "" %>">
                    <i class="fas fa-tasks mr-2"></i> Assign Resources
                </a></li>
                <li><a href="${pageContext.request.contextPath}/transport/viewAssignments.jsp" class="<%= pageName.equals("viewAssignments.jsp") ? "active" : "" %>">
                    <i class="fas fa-clipboard-list mr-2"></i> View Assignments
                </a></li>
                <li><a href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt mr-2"></i> Logout
                </a></li>
            </ul>
        </nav>
    </div>
</header>

<% if (request.getParameter("successMessage") != null) { %>
    <div class="alert alert-success mx-4 my-3" id="successAlert">
        <div class="flex">
            <div class="flex-shrink-0">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="ml-3">
                <p><%= request.getParameter("successMessage") %></p>
            </div>
            <div class="ml-auto">
                <button onclick="document.getElementById('successAlert').style.display='none'" class="text-success">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    </div>
<% } %>

<% if (request.getParameter("errorMessage") != null) { %>
    <div class="alert alert-danger mx-4 my-3" id="errorAlert">
        <div class="flex">
            <div class="flex-shrink-0">
                <i class="fas fa-exclamation-circle"></i>
            </div>
            <div class="ml-3">
                <p><%= request.getParameter("errorMessage") %></p>
            </div>
            <div class="ml-auto">
                <button onclick="document.getElementById('errorAlert').style.display='none'" class="text-danger">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    </div>
<% } %>

<% 
    // Handle session messages and clear them after displaying
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    
    if (successMessage != null && !successMessage.isEmpty()) { 
%>
    <div class="alert alert-success mx-4 my-3" id="sessionSuccessAlert">
        <div class="flex">
            <div class="flex-shrink-0">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="ml-3">
                <p><%= successMessage %></p>
            </div>
            <div class="ml-auto">
                <button onclick="document.getElementById('sessionSuccessAlert').style.display='none'" class="text-success">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    </div>
<% 
        session.removeAttribute("successMessage");
    } 
    
    if (errorMessage != null && !errorMessage.isEmpty()) { 
%>
    <div class="alert alert-danger mx-4 my-3" id="sessionErrorAlert">
        <div class="flex">
            <div class="flex-shrink-0">
                <i class="fas fa-exclamation-circle"></i>
            </div>
            <div class="ml-3">
                <p><%= errorMessage %></p>
            </div>
            <div class="ml-auto">
                <button onclick="document.getElementById('sessionErrorAlert').style.display='none'" class="text-danger">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    </div>
<% 
        session.removeAttribute("errorMessage");
    } 
%>

<script>
    // Auto-hide alerts after 5 seconds
    window.addEventListener('DOMContentLoaded', function() {
        setTimeout(function() {
            const alerts = document.querySelectorAll('#successAlert, #errorAlert, #sessionSuccessAlert, #sessionErrorAlert');
            alerts.forEach(function(alert) {
                if (alert) alert.style.display = 'none';
            });
        }, 5000);
    });
</script>
