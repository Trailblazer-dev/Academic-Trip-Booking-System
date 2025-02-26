<%@ page import="com.academictrip.dao.TripDAO" %>
<%@ page import="com.academictrip.model.Trip" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Trip List</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-8">
    <div class="max-w-5xl mx-auto bg-white shadow-lg rounded-lg p-6">
        <h1 class="text-2xl font-bold text-gray-700 mb-4 text-center">Trip List</h1>

        <table class="w-full border-collapse border border-gray-200 shadow-sm rounded-lg">
            <thead class="bg-blue-600 text-white">
                <tr>
                    <th class="p-3 border">Trip ID</th>
                    <th class="p-3 border">Start Date</th>
                    <th class="p-3 border">End Date</th>
                    <th class="p-3 border">Destination</th>
                    <th class="p-3 border">Incharge Group</th>
                </tr>
            </thead>
            <tbody class="bg-white">
                <%
                    TripDAO tripDAO = new TripDAO();
                    List<Trip> trips = tripDAO.getAllTrips();
                    for (Trip trip : trips) {
                %>
                <tr class="border hover:bg-gray-100 transition">
                    <td class="p-3 border text-center"><%= trip.getTripId() %></td>
                    <td class="p-3 border text-center"><%= trip.getStartDate() %></td>
                    <td class="p-3 border text-center"><%= trip.getEndDate() %></td>
                    <td class="p-3 border text-center"><%= trip.getDestinationId() %></td>
                    <td class="p-3 border text-center"><%= trip.getInchargeGroupId() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
