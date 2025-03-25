<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error | Academic Trip System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="max-w-2xl w-full bg-white rounded-lg shadow-lg p-8 m-4">
        <div class="text-center mb-6">
            <div class="text-red-500 text-6xl mb-4">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h1 class="text-2xl font-bold text-gray-800 mb-4">Something went wrong!</h1>
            <div class="bg-red-50 border border-red-300 rounded-md p-4 text-left mb-6">
                <h2 class="font-bold text-red-700">Error Details:</h2>
                <p class="text-red-700 mt-1">
                    <% if(exception != null) { %>
                        <%= exception.getMessage() != null ? exception.getMessage() : "An unknown error occurred" %>
                    <% } else { %>
                        <%= request.getAttribute("javax.servlet.error.message") != null ? 
                            request.getAttribute("javax.servlet.error.message") : "Unknown error" %>
                    <% } %>
                </p>
                
                <% if(exception != null) { %>
                    <div class="mt-4">
                        <div class="font-bold text-red-700">Stack Trace:</div>
                        <div class="overflow-auto max-h-40 p-2 bg-red-100 text-xs text-red-800 font-mono mt-1">
                            <% 
                                java.io.StringWriter sw = new java.io.StringWriter();
                                java.io.PrintWriter pw = new java.io.PrintWriter(sw);
                                exception.printStackTrace(pw);
                                out.println(sw.toString().replace("\n", "<br/>").replace("    ", "&nbsp;&nbsp;&nbsp;&nbsp;"));
                            %>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
        
        <div class="flex justify-center space-x-4">            
            <a href="${pageContext.request.contextPath}/" class="bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded transition-colors">
                <i class="fas fa-home mr-2"></i>Go to Login
            </a>
        </div>
    </div>
</body>
</html>