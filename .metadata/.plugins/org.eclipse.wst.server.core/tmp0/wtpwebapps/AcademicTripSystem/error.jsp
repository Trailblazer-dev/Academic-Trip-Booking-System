<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<html>
<head>
    <title>Error</title>
</head>
<body>
    <h1>Something went wrong!</h1>
    <p><%= exception != null ? exception.getMessage() : "Unknown error" %></p>
    <a href="lecturer/addTrip.jsp">Back to Trip Form</a>
</body>
</html>