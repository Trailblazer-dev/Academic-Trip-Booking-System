<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Academic Trip System</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <style>
        /* These styles will override the ones in the stylesheet */
        .login-background {
            background-image: url('https://images.unsplash.com/photo-1594608661623-aa0bd3a69799?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2069&q=80');
            background-size: cover;
            background-position: center;
        }
        
        .login-overlay {
            background-color: rgba(26, 37, 47, 0.9);
        }
        
        .input-icon-wrap {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #6B7280;
        }
        
        .input-with-icon {
            padding-left: 40px !important;
        }

        .btn-secondary {
            background-color: var(--secondary);
        }

        .btn-secondary:hover {
            background-color: #d35400;
        }
    </style>
</head>
<body class="login-background">
    <div class="page-wrapper">
        <div class="login-overlay main-content flex items-center justify-center min-h-screen py-12 px-4 sm:px-6 lg:px-8">
            <div class="max-w-md w-full">
                <div class="bg-white shadow-xl rounded-lg overflow-hidden">
                    <!-- Header with logo -->
                    <div class="bg-primary p-6 text-center">
                        <div class="login-logo mb-4">
                            <i class="fas fa-bus"></i>
                        </div>
                        <h2 class="text-xl md:text-2xl font-bold text-white">Academic Trip System</h2>
                        <p class="text-blue-100 mt-1">Educational Journey Management</p>
                    </div>

                    <div class="p-8">
                        <!-- Status Messages -->
                        <% String status = request.getParameter("status"); %>
                        <% if (status != null) { %>
                            <% if (status.equals("logout")) { %>
                                <div class="bg-blue-50 border-l-4 border-blue-500 p-4 mb-6" id="statusAlert">
                                    <div class="flex">
                                        <div class="flex-shrink-0">
                                            <i class="fas fa-info-circle text-blue-500"></i>
                                        </div>
                                        <div class="ml-3">
                                            <p class="text-blue-700">You have been successfully logged out.</p>
                                        </div>
                                        <button onclick="document.getElementById('statusAlert').style.display='none'" class="ml-auto text-blue-500">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                </div>
                            <% } else if (status.equals("error")) { %>
                                <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6" id="errorAlert">
                                    <div class="flex">
                                        <div class="flex-shrink-0">
                                            <i class="fas fa-exclamation-circle text-red-500"></i>
                                        </div>
                                        <div class="ml-3">
                                            <p class="text-red-700">Invalid username or password.</p>
                                        </div>
                                        <button onclick="document.getElementById('errorAlert').style.display='none'" class="ml-auto text-red-500">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                </div>
                            <% } %>
                        <% } %>

                        <form class="space-y-6" action="${pageContext.request.contextPath}/LoginServlet" method="post">
                            <div>
                                <label for="username" class="block text-sm font-medium text-gray-700 mb-2">Username</label>
                                <div class="input-icon-wrap">
                                    <i class="fas fa-user input-icon"></i>
                                    <input id="username" name="username" type="text" autocomplete="username" required 
                                        class="form-input input-with-icon w-full border-gray-300 rounded-md shadow-sm 
                                        focus:ring-primary focus:border-primary focus:ring-2 transition-all" 
                                        placeholder="Enter your username">
                                </div>
                            </div>

                            <div>
                                <label for="password" class="block text-sm font-medium text-gray-700 mb-2">Password</label>
                                <div class="input-icon-wrap">
                                    <i class="fas fa-lock input-icon"></i>
                                    <input id="password" name="password" type="password" autocomplete="current-password" required 
                                        class="form-input input-with-icon w-full border-gray-300 rounded-md shadow-sm
                                        focus:ring-primary focus:border-primary focus:ring-2 transition-all" 
                                        placeholder="Enter your password">
                                </div>
                            </div>

                            <div class="flex items-center justify-between">
                                <div class="flex items-center">
                                    <input id="remember-me" name="remember-me" type="checkbox" 
                                        class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded">
                                    <label for="remember-me" class="ml-2 block text-sm text-gray-900">
                                        Remember me
                                    </label>
                                </div>

                                <div class="text-sm">
                                    <a href="#" class="font-medium text-secondary hover:text-primary-dark transition-colors">
                                        Forgot password?
                                    </a>
                                </div>
                            </div>

                            <div>
                                <button type="submit" class="btn btn-secondary w-full flex justify-center py-3 px-4 rounded-md shadow-md hover:shadow-lg transition-all">
                                    <span class="mr-2">Sign in</span>
                                    <i class="fas fa-sign-in-alt"></i>
                                </button>
                            </div>
                        </form>
                        
                        <div class="mt-6 text-center text-sm">
                            <p class="text-gray-600">
                                For access issues, please contact your system administrator
                            </p>
                        </div>
                    </div>
                </div>
                
                <div class="mt-4 text-center text-xs text-white">
                    <p>© 2023 Academic Trip System. All rights reserved.</p>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Auto-hide alerts after 5 seconds
        window.onload = function() {
            setTimeout(function() {
                const alerts = document.querySelectorAll('#statusAlert, #errorAlert');
                alerts.forEach(function(alert) {
                    if (alert) alert.style.display = 'none';
                });
            }, 5000);
            
            // Add focus animation
            const inputs = document.querySelectorAll('input[type="text"], input[type="password"]');
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentNode.querySelector('.input-icon').style.color = '#e67e22';
                });
                
                input.addEventListener('blur', function() {
                    this.parentNode.querySelector('.input-icon').style.color = '#6B7280';
                });
            });
        }
    </script>
</body>
</html>
