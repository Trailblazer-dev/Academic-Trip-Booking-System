<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.academictrip.dao.TripDAO, com.academictrip.model.Trip" %>
<%@ page import="com.academictrip.dao.DriverDAO, com.academictrip.model.Driver" %>
<%@ page import="com.academictrip.dao.VehicleDAO, com.academictrip.model.Vehicle" %>
<html>
<head>
    <title>Assign Resources</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="max-w-lg mx-auto mt-10 p-6 bg-white shadow-md rounded-lg">
        <h1 class="text-2xl font-bold text-center text-gray-800 mb-6">Assign Driver & Vehicle</h1>
        <form action="${pageContext.request.contextPath}/transport/assignResources" method="post" class="space-y-4">
            <div>
                <label for="tripId" class="block text-gray-700 font-medium mb-1">Select Trip</label>
                <select name="tripId" id="tripId" required class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-300">
                    <% for (Trip trip : new TripDAO().getAllTrips()) { %>
                        <option value="<%= trip.getTripId() %>">
                            <%= trip.getTripId() %> - <%= trip.getStartDate() %>
                        </option>
                    <% } %>
                </select>
            </div>
            <div>
                <label for="driverId" class="block text-gray-700 font-medium mb-1">Select Driver</label>
                <select name="driverId" id="driverId" required class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-300">
                    <% for (Driver driver : new DriverDAO().getAllDrivers()) { %>
                        <option value="<%= driver.getDriverId() %>">
                            <%= driver.getFirstname() %> <%= driver.getLastname() %>
                        </option>
                    <% } %>
                </select>
            </div>
            <div>
                <label for="vehicleId" class="block text-gray-700 font-medium mb-1">Select Vehicle</label>
                <select name="vehicleId" id="vehicleId" required class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-300">
                    <% for (Vehicle vehicle : new VehicleDAO().getAllVehicles()) { %>
                        <option value="<%= vehicle.getVehicleId() %>">
                            <%= vehicle.getMake() %> <%= vehicle.getModel() %>
                        </option>
                    <% } %>
                </select>
            </div>
            <div class="text-center">
                <button type="submit" class="w-full bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded focus:outline-none focus:ring-2 focus:ring-blue-300 transition duration-200">
                    Assign Resources
                </button>
            </div>
        </form>
    </div>
</body>
</html>
