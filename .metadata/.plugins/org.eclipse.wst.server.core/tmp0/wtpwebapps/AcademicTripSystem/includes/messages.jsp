<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check for success message
    String successMessage = (String) request.getAttribute("successMessage");
    if (successMessage != null && !successMessage.trim().isEmpty()) {
%>
    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4 flex justify-between items-center">
        <span><i class="fas fa-check-circle mr-2"></i><%= successMessage %></span>
        <button type="button" class="text-green-700" onclick="this.parentElement.remove();">
            <i class="fas fa-times"></i>
        </button>
    </div>
<%
    }

    // Check for error message
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage != null && !errorMessage.trim().isEmpty()) {
%>
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4 flex justify-between items-center">
        <span><i class="fas fa-exclamation-circle mr-2"></i><%= errorMessage %></span>
        <button type="button" class="text-red-700" onclick="this.parentElement.remove();">
            <i class="fas fa-times"></i>
        </button>
    </div>
<%
    }

    // Check for info message
    String infoMessage = (String) request.getAttribute("infoMessage");
    if (infoMessage != null && !infoMessage.trim().isEmpty()) {
%>
    <div class="bg-blue-100 border border-blue-400 text-blue-700 px-4 py-3 rounded mb-4 flex justify-between items-center">
        <span><i class="fas fa-info-circle mr-2"></i><%= infoMessage %></span>
        <button type="button" class="text-blue-700" onclick="this.parentElement.remove();">
            <i class="fas fa-times"></i>
        </button>
    </div>
<%
    }

    // Check for warning message
    String warningMessage = (String) request.getAttribute("warningMessage");
    if (warningMessage != null && !warningMessage.trim().isEmpty()) {
%>
    <div class="bg-yellow-100 border border-yellow-400 text-yellow-700 px-4 py-3 rounded mb-4 flex justify-between items-center">
        <span><i class="fas fa-exclamation-triangle mr-2"></i><%= warningMessage %></span>
        <button type="button" class="text-yellow-700" onclick="this.parentElement.remove();">
            <i class="fas fa-times"></i>
        </button>
    </div>
<%
    }
%>
