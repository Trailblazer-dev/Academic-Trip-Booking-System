<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.academictrip.dao.TripDAO, com.academictrip.model.Trip" %>
<%@ page import="com.academictrip.dao.DriverDAO, com.academictrip.model.Driver" %>
<%@ page import="com.academictrip.dao.VehicleDAO, com.academictrip.model.Vehicle" %>
<html>
<head>
    <title>Assign Resources</title>
</head>
<body>
    <h1>Assign Driver & Vehicle</h1>
    <form action="AssignResourcesServlet" method="post">
        <label>Select Trip:
            <select name="tripId" required>
                <% for (Trip trip : new TripDAO().getAllTrips()) { %>
                    <option value="<%= trip.getTripId() %>">
                        <%= trip.getTripId() %> - <%= trip.getStartDate() %>
                    </option>
                <% } %>
            </select>
        </label><br>
        
        <label>Select Driver:
            <select name="driverId" required>
                <% for (Driver driver : new DriverDAO().getAllDrivers()) { %>
                    <option value="<%= driver.getDriverId() %>">
                        <%= driver.getFirstname() %> <%= driver.getLastname() %>
                    </option>
                <% } %>
            </select>
        </label><br>
        
        <label>Select Vehicle:
            <select name="vehicleId" required>
                <% for (Vehicle vehicle : new VehicleDAO().getAllVehicles()) { %>
                    <option value="<%= vehicle.getVehicleId() %>">
                        <%= vehicle.getMake() %> <%= vehicle.getModel() %>
                    </option>
                <% } %>
            </select>
        </label><br>
        
        <input type="submit" value="Assign Resources">
    </form>
</body>
</html>