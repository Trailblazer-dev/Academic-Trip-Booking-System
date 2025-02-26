<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Manage Drivers</title>
</head>
<body>
    <h1>Driver Management</h1>
    <form action="AddDriverServlet" method="post">
        First Name: <input type="text" name="firstName" required><br>
        Last Name: <input type="text" name="lastName" required><br>
        Phone: <input type="tel" name="phone" required><br>
        Email: <input type="email" name="email" required><br>
        <input type="submit" value="Add Driver">
    </form>
</body>
</html>