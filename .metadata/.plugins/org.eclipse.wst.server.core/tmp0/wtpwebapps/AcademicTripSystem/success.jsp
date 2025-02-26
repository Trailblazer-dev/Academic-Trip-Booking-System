<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Success</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex items-center justify-center h-screen bg-slate-700">
    <div class="bg-white p-8 shadow-lg rounded-lg text-center max-w-md">
        <!-- Success Icon & Message -->
        <div class="flex justify-center">
            <svg class="w-16 h-16 text-green-500" fill="none" stroke="currentColor" stroke-width="2" 
                viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" 
                    d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
        </div>
        
        <h1 class="text-2xl font-semibold text-gray-700 mt-4">Operation Successful!</h1>
        <p class="text-gray-500 mt-2">Your trip has been added successfully.</p>

        <!-- Navigation Buttons -->
        <div class="mt-6 space-y-3">
            <a href="lecturer/addTrip.jsp" 
                class="block w-full bg-blue-600 text-white py-2 rounded-md text-lg font-medium hover:bg-blue-700 transition">
                ➕ Add Another Trip
            </a>
            <a href="lecturer/viewTimetable.jsp" 
                class="block w-full bg-gray-600 text-white py-2 rounded-md text-lg font-medium hover:bg-gray-700 transition">
                📅 View Timetable
            </a>
        </div>
    </div>
</body>
</html>
