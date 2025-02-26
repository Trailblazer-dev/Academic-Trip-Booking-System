<%@ page import="com.academictrip.dao.DriverVehicleDAO" %>
<%@ page import="com.academictrip.model.DriverVehicle" %>
<%@ page import="com.academictrip.model.Trip" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Assignments</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" type="text/css" href="../css/styles.css">
</head>
<body class="bg-gray-100 p-6">
    <div class="max-w-5xl mx-auto bg-white shadow-md rounded-lg p-6">
        <h1 class="text-2xl font-bold text-center text-gray-800 mb-6">Driver and Vehicle Assignments</h1>
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Trip ID</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Driver ID</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Vehicle ID</th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    <%
                    //	Trip trip = Trip();
                    
                        DriverVehicleDAO driverVehicleDAO = new DriverVehicleDAO();
                        List<DriverVehicle> assignments = driverVehicleDAO.getAllAssignments();
                        for (DriverVehicle assignment : assignments) {
                    %>
                    <tr class="hover:bg-gray-100">
                        <td class="px-6 py-4 whitespace-nowrap"><%= assignment.getDriverId() %></td>
                        <td class="px-6 py-4 whitespace-nowrap"><%= assignment.getVehicleId() %></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
        <div class="mt-4 text-center">
            <a href="../transport/assignDriverVehicle.jsp" class="text-blue-500 hover:text-blue-700 font-semibold">
                Assign Driver and Vehicle
            </a>
        </div>
    </div>
</body>
</html>
