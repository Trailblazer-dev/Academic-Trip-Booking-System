<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Assign Driver/Vehicle</title>
</head>
<body>
    <h1>Assign Driver & Vehicle</h1>
    <form action="AssignDriverVehicleServlet" method="post">
        <label>Trip ID: 
            <input type="text" name="tripId" required>
        </label>
        
        <label>Driver ID: 
            <input type="text" name="driverId" required>
        </label>
        
        <label>Vehicle ID: 
            <input type="text" name="vehicleId" required>
        </label>
        
        <input type="submit" value="Assign">
    </form>
</body>
</html>