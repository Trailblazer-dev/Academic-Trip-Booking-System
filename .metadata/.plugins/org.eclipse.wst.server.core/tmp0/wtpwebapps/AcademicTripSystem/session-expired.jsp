<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Session Expired - Academic Trip System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <meta http-equiv="refresh" content="5;url=${pageContext.request.contextPath}/login.jsp">
</head>
<body class="bg-gray-100">
    <div class="min-h-screen flex items-center justify-center">
        <div class="bg-white p-8 rounded shadow-md w-full max-w-md">
            <div class="text-center">
                <i class="fas fa-clock text-5xl text-yellow-500 mb-4"></i>
                <h1 class="text-2xl font-bold mb-4">Session Expired</h1>
                <p class="mb-4">Your session has expired due to inactivity.</p>
                <p class="mb-6">You will be redirected to the login page in 5 seconds...</p>
                <a href="${pageContext.request.contextPath}/login.jsp" 
                   class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                    Login Now
                </a>
            </div>
        </div>
    </div>
</body>
</html>
