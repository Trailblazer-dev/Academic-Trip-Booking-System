<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
    // Redirect to LogoutServlet
    response.sendRedirect(request.getContextPath() + "/LogoutServlet");
%>
