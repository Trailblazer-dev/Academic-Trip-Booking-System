/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/9.0.98
 * Generated at: 2025-03-27 04:18:27 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.transport;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.academictrip.dao.DriverDAO;
import com.academictrip.dao.DriverVehicleDAO;
import com.academictrip.model.Driver;
import com.academictrip.model.DriverVehicle;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public final class manageDrivers_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent,
                 org.apache.jasper.runtime.JspSourceImports {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  private static final java.util.Set<java.lang.String> _jspx_imports_packages;

  private static final java.util.Set<java.lang.String> _jspx_imports_classes;

  static {
    _jspx_imports_packages = new java.util.LinkedHashSet<>(4);
    _jspx_imports_packages.add("javax.servlet");
    _jspx_imports_packages.add("javax.servlet.http");
    _jspx_imports_packages.add("javax.servlet.jsp");
    _jspx_imports_classes = new java.util.LinkedHashSet<>(10);
    _jspx_imports_classes.add("com.academictrip.dao.DriverDAO");
    _jspx_imports_classes.add("com.academictrip.model.DriverVehicle");
    _jspx_imports_classes.add("java.util.List");
    _jspx_imports_classes.add("com.academictrip.model.Driver");
    _jspx_imports_classes.add("com.academictrip.dao.DriverVehicleDAO");
    _jspx_imports_classes.add("java.util.Map");
    _jspx_imports_classes.add("java.util.HashMap");
  }

  private volatile javax.el.ExpressionFactory _el_expressionfactory;
  private volatile org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public java.util.Set<java.lang.String> getPackageImports() {
    return _jspx_imports_packages;
  }

  public java.util.Set<java.lang.String> getClassImports() {
    return _jspx_imports_classes;
  }

  public javax.el.ExpressionFactory _jsp_getExpressionFactory() {
    if (_el_expressionfactory == null) {
      synchronized (this) {
        if (_el_expressionfactory == null) {
          _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
        }
      }
    }
    return _el_expressionfactory;
  }

  public org.apache.tomcat.InstanceManager _jsp_getInstanceManager() {
    if (_jsp_instancemanager == null) {
      synchronized (this) {
        if (_jsp_instancemanager == null) {
          _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
        }
      }
    }
    return _jsp_instancemanager;
  }

  public void _jspInit() {
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
      throws java.io.IOException, javax.servlet.ServletException {

    if (!javax.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
      final java.lang.String _jspx_method = request.getMethod();
      if ("OPTIONS".equals(_jspx_method)) {
        response.setHeader("Allow","GET, HEAD, POST, OPTIONS");
        return;
      }
      if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method)) {
        response.setHeader("Allow","GET, HEAD, POST, OPTIONS");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSPs only permit GET, POST or HEAD. Jasper also permits OPTIONS");
        return;
      }
    }

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");

    // Your existing code for driver management
    DriverDAO driverDAO = new DriverDAO();
    List<Driver> drivers = driverDAO.getAllDrivers();
    
    // Get messages from session
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    
    // Clear messages after retrieving
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");

      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html lang=\"en\">\n");
      out.write("<head>\n");
      out.write("    <meta charset=\"UTF-8\">\n");
      out.write("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n");
      out.write("    <title>Manage Drivers | Academic Trip System</title>\n");
      out.write("    <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css\">\n");
      out.write("    <link rel=\"stylesheet\" href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/css/styles.css\">\n");
      out.write("    <script src=\"https://cdn.tailwindcss.com\"></script>\n");
      out.write("</head>\n");
      out.write("<body class=\"bg-gray-50\">\n");
      out.write("    <div class=\"page-wrapper\">\n");
      out.write("        <!-- Include standardized header -->\n");
      out.write("        ");
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "../includes/transportHeader.jsp", out, false);
      out.write("\n");
      out.write("        \n");
      out.write("        <div class=\"main-content\">\n");
      out.write("            <div class=\"container mx-auto px-4 py-8\">\n");
      out.write("                <div class=\"flex justify-between items-center mb-6\">\n");
      out.write("                    <h1 class=\"text-2xl font-bold text-gray-800\">\n");
      out.write("                        <i class=\"fas fa-users mr-2 text-secondary\"></i>Manage Drivers\n");
      out.write("                    </h1>\n");
      out.write("                    <button id=\"addDriverBtn\" class=\"btn btn-secondary hover:bg-orange-700 text-white py-2 px-4 rounded-lg flex items-center\">\n");
      out.write("                        <i class=\"fas fa-plus-circle mr-2\"></i> Add New Driver\n");
      out.write("                    </button>\n");
      out.write("                </div>\n");
      out.write("                \n");
      out.write("                <!-- Dashboard Stats -->\n");
      out.write("                <div class=\"grid grid-cols-1 md:grid-cols-3 gap-6 mb-6\">\n");
      out.write("                    <div class=\"bg-white rounded-lg shadow-md p-6 border-t-4 border-blue-500\">\n");
      out.write("                        <div class=\"flex items-center\">\n");
      out.write("                            <div class=\"p-3 rounded-full bg-blue-100 mr-4\">\n");
      out.write("                                <i class=\"fas fa-user text-xl text-blue-500\"></i>\n");
      out.write("                            </div>\n");
      out.write("                            <div>\n");
      out.write("                                <h3 class=\"text-lg font-semibold text-gray-700\">Total Drivers</h3>\n");
      out.write("                                ");
 
                                    int totalDrivers = driverDAO.getAllDrivers().size();
                                
      out.write("\n");
      out.write("                                <p class=\"text-2xl font-bold text-gray-800\">");
      out.print( totalDrivers );
      out.write("</p>\n");
      out.write("                            </div>\n");
      out.write("                        </div>\n");
      out.write("                    </div>\n");
      out.write("                    \n");
      out.write("                    <div class=\"bg-white rounded-lg shadow-md p-6 border-t-4 border-green-500\">\n");
      out.write("                        <div class=\"flex items-center\">\n");
      out.write("                            <div class=\"p-3 rounded-full bg-green-100 mr-4\">\n");
      out.write("                                <i class=\"fas fa-check-circle text-xl text-green-500\"></i>\n");
      out.write("                            </div>\n");
      out.write("                            <div>\n");
      out.write("                                <h3 class=\"text-lg font-semibold text-gray-700\">Active Assignments</h3>\n");
      out.write("                                ");
 
                                    DriverVehicleDAO dvDAO = new DriverVehicleDAO();
                                    int activeAssignments = dvDAO.getAllAssignments().size();
                                
      out.write("\n");
      out.write("                                <p class=\"text-2xl font-bold text-gray-800\">");
      out.print( activeAssignments );
      out.write("</p>\n");
      out.write("                            </div>\n");
      out.write("                        </div>\n");
      out.write("                    </div>\n");
      out.write("                    \n");
      out.write("                    <div class=\"bg-white rounded-lg shadow-md p-6 border-t-4 border-purple-500\">\n");
      out.write("                        <div class=\"flex items-center\">\n");
      out.write("                            <div class=\"p-3 rounded-full bg-purple-100 mr-4\">\n");
      out.write("                                <i class=\"fas fa-calendar-alt text-xl text-purple-500\"></i>\n");
      out.write("                            </div>\n");
      out.write("                            <div>\n");
      out.write("                                <h3 class=\"text-lg font-semibold text-gray-700\">Available Drivers</h3>\n");
      out.write("                                <p class=\"text-2xl font-bold text-gray-800\">");
      out.print( totalDrivers - activeAssignments );
      out.write("</p>\n");
      out.write("                            </div>\n");
      out.write("                        </div>\n");
      out.write("                    </div>\n");
      out.write("                </div>\n");
      out.write("                \n");
      out.write("                <!-- Search & Filter Bar -->\n");
      out.write("                <div class=\"bg-white p-4 rounded-lg shadow mb-6\">\n");
      out.write("                    <div class=\"flex flex-col md:flex-row justify-between items-center\">\n");
      out.write("                        <div class=\"relative w-full md:w-64 mb-4 md:mb-0\">\n");
      out.write("                            <input type=\"text\" id=\"driverSearch\" placeholder=\"Search drivers...\" \n");
      out.write("                                   class=\"w-full pl-10 pr-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-400\">\n");
      out.write("                            <i class=\"fas fa-search absolute left-3 top-3 text-gray-400\"></i>\n");
      out.write("                        </div>\n");
      out.write("                        <div class=\"flex space-x-4\">\n");
      out.write("                            <select id=\"filterStatus\" class=\"rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400\">\n");
      out.write("                                <option value=\"all\">All Status</option>\n");
      out.write("                                <option value=\"active\">Active</option>\n");
      out.write("                                <option value=\"inactive\">Available</option>\n");
      out.write("                            </select>\n");
      out.write("                            <button id=\"refreshBtn\" class=\"bg-gray-200 hover:bg-gray-300 text-gray-700 py-2 px-4 rounded-lg\">\n");
      out.write("                                <i class=\"fas fa-sync-alt mr-2\"></i> Refresh\n");
      out.write("                            </button>\n");
      out.write("                        </div>\n");
      out.write("                    </div>\n");
      out.write("                </div>\n");
      out.write("                \n");
      out.write("                <!-- Driver List -->\n");
      out.write("                <div class=\"bg-white rounded-lg shadow-md overflow-hidden\">\n");
      out.write("                    <div class=\"overflow-x-auto\">\n");
      out.write("                        <table id=\"driversTable\" class=\"min-w-full divide-y divide-gray-200\">\n");
      out.write("                            <thead class=\"bg-gray-100\">\n");
      out.write("                                <tr>\n");
      out.write("                                    <th scope=\"col\" class=\"px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider\">Driver ID</th>\n");
      out.write("                                    <th scope=\"col\" class=\"px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider\">Name</th>\n");
      out.write("                                    <th scope=\"col\" class=\"px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider\">Phone</th>\n");
      out.write("                                    <th scope=\"col\" class=\"px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider\">Email</th>\n");
      out.write("                                    <th scope=\"col\" class=\"px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider\">Status</th>\n");
      out.write("                                    <th scope=\"col\" class=\"px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider\">Actions</th>\n");
      out.write("                                </tr>\n");
      out.write("                            </thead>\n");
      out.write("                            <tbody class=\"bg-white divide-y divide-gray-200\">\n");
      out.write("                                ");
 
                                    // Get map of driver IDs to assignment status
                                    Map<String, Boolean> driverAssignmentMap = new HashMap<>();
                                    List<DriverVehicle> assignments = dvDAO.getAllAssignments();
                                    
                                    for (DriverVehicle dv : assignments) {
                                        driverAssignmentMap.put(dv.getDriverId(), true);
                                    }
                                    
                                    for (Driver driver : drivers) {
                                        boolean isAssigned = driverAssignmentMap.containsKey(driver.getDriverId());
                                
      out.write("\n");
      out.write("                                <tr class=\"hover:bg-gray-50 transition\">\n");
      out.write("                                    <td class=\"px-6 py-4 whitespace-nowrap text-sm text-gray-500\">");
      out.print( driver.getDriverId() );
      out.write("</td>\n");
      out.write("                                    <td class=\"px-6 py-4 whitespace-nowrap\">\n");
      out.write("                                        <div class=\"flex items-center\">\n");
      out.write("                                            <div class=\"flex-shrink-0 h-10 w-10 bg-blue-100 rounded-full flex items-center justify-center\">\n");
      out.write("                                                <i class=\"fas fa-user text-blue-500\"></i>\n");
      out.write("                                            </div>\n");
      out.write("                                            <div class=\"ml-4\">\n");
      out.write("                                                <div class=\"text-sm font-medium text-gray-900\">");
      out.print( driver.getFirstname() );
      out.write(' ');
      out.print( driver.getLastname() );
      out.write("</div>\n");
      out.write("                                            </div>\n");
      out.write("                                        </div>\n");
      out.write("                                    </td>\n");
      out.write("                                    <td class=\"px-6 py-4 whitespace-nowrap text-sm text-gray-500\">");
      out.print( driver.getPhoneNumber() );
      out.write("</td>\n");
      out.write("                                    <td class=\"px-6 py-4 whitespace-nowrap text-sm text-gray-500\">");
      out.print( driver.getEmail() );
      out.write("</td>\n");
      out.write("                                    <td class=\"px-6 py-4 whitespace-nowrap\">\n");
      out.write("                                        <span class=\"px-2 inline-flex text-xs leading-5 font-semibold rounded-full \n");
      out.write("                                              ");
      out.print( isAssigned ? "bg-green-100 text-green-800" : "bg-yellow-100 text-yellow-800" );
      out.write("\">\n");
      out.write("                                            ");
      out.print( isAssigned ? "Active" : "Available" );
      out.write("\n");
      out.write("                                        </span>\n");
      out.write("                                    </td>\n");
      out.write("                                    <td class=\"px-6 py-4 whitespace-nowrap text-sm font-medium\">\n");
      out.write("                                        <div class=\"flex space-x-2\">\n");
      out.write("                                            <button onclick=\"openEditModal('");
      out.print(driver.getDriverId());
      out.write("', '");
      out.print(driver.getFirstname());
      out.write("', '");
      out.print(driver.getLastname());
      out.write("', '");
      out.print(driver.getPhoneNumber());
      out.write("', '");
      out.print(driver.getEmail());
      out.write("')\" class=\"text-indigo-600 hover:text-indigo-900\">\n");
      out.write("                                                <i class=\"fas fa-edit\"></i> Edit\n");
      out.write("                                            </button>\n");
      out.write("                                            <button onclick=\"confirmDelete('");
      out.print(driver.getDriverId());
      out.write("', '");
      out.print(driver.getFirstname());
      out.write(' ');
      out.print(driver.getLastname());
      out.write("')\" class=\"text-red-600 hover:text-red-900\">\n");
      out.write("                                                <i class=\"fas fa-trash-alt\"></i> Delete\n");
      out.write("                                            </button>\n");
      out.write("                                        </div>\n");
      out.write("                                    </td>\n");
      out.write("                                </tr>\n");
      out.write("                                ");
 } 
      out.write("\n");
      out.write("                            </tbody>\n");
      out.write("                        </table>\n");
      out.write("                    </div>\n");
      out.write("                </div>\n");
      out.write("            </div>\n");
      out.write("        </div>\n");
      out.write("        \n");
      out.write("        <footer>\n");
      out.write("            <div class=\"footer-content\">\n");
      out.write("                <p>&copy; 2023 Academic Trip System. All rights reserved.</p>\n");
      out.write("                <p class=\"mt-2 text-sm text-gray-300\">Transport Management Module</p>\n");
      out.write("            </div>\n");
      out.write("        </footer>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <!-- Your existing JavaScript code -->\n");
      out.write("    <script>\n");
      out.write("        $(document).ready(function() {\n");
      out.write("            // Initialize DataTable\n");
      out.write("            $('#driversTable').DataTable({\n");
      out.write("                \"paging\": true,\n");
      out.write("                \"ordering\": true,\n");
      out.write("                \"info\": true,\n");
      out.write("                \"searching\": true,\n");
      out.write("                \"lengthChange\": true,\n");
      out.write("                \"pageLength\": 10,\n");
      out.write("                \"language\": {\n");
      out.write("                    \"search\": \"\",\n");
      out.write("                    \"searchPlaceholder\": \"Search drivers...\"\n");
      out.write("                },\n");
      out.write("                \"dom\": '<\"top\"f>rt<\"bottom\"lip><\"clear\">'\n");
      out.write("            });\n");
      out.write("            \n");
      out.write("            // Add Driver Modal\n");
      out.write("            $('#addDriverBtn').click(function() {\n");
      out.write("                $('#addDriverModal').removeClass('hidden');\n");
      out.write("            });\n");
      out.write("            \n");
      out.write("            $('#closeAddModal').click(function() {\n");
      out.write("                $('#addDriverModal').addClass('hidden');\n");
      out.write("            });\n");
      out.write("            \n");
      out.write("            // View Driver Modal\n");
      out.write("            $('.view-driver').click(function() {\n");
      out.write("                const driverId = $(this).data('id');\n");
      out.write("                \n");
      out.write("                // In a real application, fetch driver details via AJAX\n");
      out.write("                // For demo, we'll use data from the table\n");
      out.write("                const row = $(this).closest('tr');\n");
      out.write("                const name = row.find('td:eq(1)').text().trim();\n");
      out.write("                const phone = row.find('td:eq(2)').text().trim();\n");
      out.write("                const email = row.find('td:eq(3)').text().trim();\n");
      out.write("                const status = row.find('td:eq(4)').text().trim();\n");
      out.write("                \n");
      out.write("                // Populate modal with driver details\n");
      out.write("                $('#driverDetails').html(`\n");
      out.write("                    <div class=\"text-center text-xl font-bold mb-2\">");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${name}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("</div>\n");
      out.write("                    <div class=\"text-center text-gray-500 mb-4\">");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${driverId}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("</div>\n");
      out.write("                    <div class=\"grid grid-cols-1 gap-3\">\n");
      out.write("                        <div class=\"flex items-center\">\n");
      out.write("                            <div class=\"w-8 text-gray-500\"><i class=\"fas fa-phone\"></i></div>\n");
      out.write("                            <div>");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${phone}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("</div>\n");
      out.write("                        </div>\n");
      out.write("                        <div class=\"flex items-center\">\n");
      out.write("                            <div class=\"w-8 text-gray-500\"><i class=\"fas fa-envelope\"></i></div>\n");
      out.write("                            <div>");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${email}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("</div>\n");
      out.write("                        </div>\n");
      out.write("                        <div class=\"flex items-center\">\n");
      out.write("                            <div class=\"w-8 text-gray-500\"><i class=\"fas fa-circle\"></i></div>\n");
      out.write("                            <div>");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${status}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("</div>\n");
      out.write("                        </div>\n");
      out.write("                    </div>\n");
      out.write("                `);\n");
      out.write("                \n");
      out.write("                $('#viewDriverModal').removeClass('hidden');\n");
      out.write("            });\n");
      out.write("            \n");
      out.write("            $('#closeViewModal').click(function() {\n");
      out.write("                $('#viewDriverModal').addClass('hidden');\n");
      out.write("            });\n");
      out.write("            \n");
      out.write("            // Filter functionality\n");
      out.write("            $('#filterStatus').change(function() {\n");
      out.write("                const value = $(this).val();\n");
      out.write("                if (value === \"all\") {\n");
      out.write("                    $('#driversTable tbody tr').show();\n");
      out.write("                } else if (value === \"active\") {\n");
      out.write("                    $('#driversTable tbody tr').hide();\n");
      out.write("                    $('#driversTable tbody tr:contains(\"Active\")').show();\n");
      out.write("                } else if (value === \"inactive\") {\n");
      out.write("                    $('#driversTable tbody tr').hide();\n");
      out.write("                    $('#driversTable tbody tr:contains(\"Available\")').show();\n");
      out.write("                }\n");
      out.write("            });\n");
      out.write("            \n");
      out.write("            // Refresh button\n");
      out.write("            $('#refreshBtn').click(function() {\n");
      out.write("                location.reload();\n");
      out.write("            });\n");
      out.write("            \n");
      out.write("            // Close modals when clicking outside\n");
      out.write("            $(window).click(function(e) {\n");
      out.write("                if ($(e.target).is('#addDriverModal')) {\n");
      out.write("                    $('#addDriverModal').addClass('hidden');\n");
      out.write("                }\n");
      out.write("                if ($(e.target).is('#viewDriverModal')) {\n");
      out.write("                    $('#viewDriverModal').addClass('hidden');\n");
      out.write("                }\n");
      out.write("            });\n");
      out.write("        });\n");
      out.write("\n");
      out.write("        function confirmDelete(driverId, driverName) {\n");
      out.write("            document.getElementById('deleteDriverId').value = driverId;\n");
      out.write("            document.getElementById('deleteConfirmationText').textContent = \n");
      out.write("                `Are you sure you want to delete the driver ");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${driverName}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("? This action cannot be undone.`;\n");
      out.write("            document.getElementById('deleteModal').classList.remove('hidden');\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        function closeModal(modalId) {\n");
      out.write("            document.getElementById(modalId).classList.add('hidden');\n");
      out.write("        }\n");
      out.write("    </script>\n");
      out.write("</body>\n");
      out.write("</html>\n");
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
