<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unauthorized Access - Academic Trip System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .error-container {
            text-align: center;
            max-width: 600px;
            margin: 5rem auto;
        }
        .error-icon {
            font-size: 5rem;
            color: var(--danger);
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="container">
        <div class="error-container">
            <div class="error-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h1 class="mb-3">Unauthorized Access</h1>
            <p class="mb-4">You don't have permission to access this resource. Please contact your administrator if you believe this is an error.</p>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                <i class="fas fa-home mr-2"></i> Return to Home
            </a>
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
