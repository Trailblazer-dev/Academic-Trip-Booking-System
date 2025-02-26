<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login Error</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center h-screen">
    <div class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 w-full max-w-md text-center">
        <h1 class="text-red-600 text-3xl font-bold mb-4">Login Failed</h1>
        <p class="text-gray-700 text-lg mb-6">
            Invalid username or password.
        </p>
        <a href="login.jsp" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
            Try Again
        </a>
    </div>
</body>
</html>
