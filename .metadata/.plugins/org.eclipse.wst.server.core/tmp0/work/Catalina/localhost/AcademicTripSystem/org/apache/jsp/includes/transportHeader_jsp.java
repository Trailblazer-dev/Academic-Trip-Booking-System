/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/9.0.98
 * Generated at: 2025-03-10 20:28:33 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.includes;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.academictrip.model.User;

public final class transportHeader_jsp extends org.apache.jasper.runtime.HttpJspBase
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
    _jspx_imports_classes = new java.util.LinkedHashSet<>(2);
    _jspx_imports_classes.add("com.academictrip.model.User");
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

      out.write('\n');
      out.write('\n');

    // Define these variables here so they're available to all pages that include this header
    String pageName = request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1);
    User currentUser = (User) session.getAttribute("user");
    
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<div class=\"bg-indigo-800 shadow-md\">\n");
      out.write("    <div class=\"max-w-7xl mx-auto px-2 sm:px-4 lg:px-8\">\n");
      out.write("        <div class=\"relative flex items-center justify-between h-16\">\n");
      out.write("            <!-- Mobile menu button -->\n");
      out.write("            <div class=\"absolute inset-y-0 left-0 flex items-center sm:hidden\">\n");
      out.write("                <button type=\"button\" id=\"mobile-menu-button\"\n");
      out.write("                        class=\"inline-flex items-center justify-center p-2 rounded-md text-indigo-200 hover:text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white\">\n");
      out.write("                    <span class=\"sr-only\">Open main menu</span>\n");
      out.write("                    <i class=\"fas fa-bars text-xl\"></i>\n");
      out.write("                </button>\n");
      out.write("            </div>\n");
      out.write("            \n");
      out.write("            <!-- Logo and site name -->\n");
      out.write("            <div class=\"flex-1 flex items-center justify-center sm:items-stretch sm:justify-start\">\n");
      out.write("                <div class=\"flex-shrink-0 flex items-center\">\n");
      out.write("                    <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/dashboard.jsp\" class=\"flex items-center\">\n");
      out.write("                        <i class=\"fas fa-bus-alt text-white text-2xl\"></i>\n");
      out.write("                        <span class=\"ml-2 text-white font-bold text-lg hidden md:block\">ATS Transport</span>\n");
      out.write("                    </a>\n");
      out.write("                </div>\n");
      out.write("                \n");
      out.write("                <!-- Desktop Navigation -->\n");
      out.write("                <div class=\"hidden sm:block sm:ml-6\">\n");
      out.write("                    <nav class=\"flex space-x-1\">\n");
      out.write("                        <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/transport/dashboard.jsp\" \n");
      out.write("                           class=\"px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-indigo-600 flex items-center transition-colors ");
      out.print( pageName.equals("dashboard.jsp") ? "bg-indigo-700" : "" );
      out.write("\">\n");
      out.write("                            <i class=\"fas fa-tachometer-alt mr-1\"></i> Dashboard\n");
      out.write("                        </a>\n");
      out.write("                        <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/transport/manageDrivers.jsp\" \n");
      out.write("                           class=\"px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-indigo-600 flex items-center transition-colors ");
      out.print( pageName.equals("manageDrivers.jsp") ? "bg-indigo-700" : "" );
      out.write("\">\n");
      out.write("                            <i class=\"fas fa-user-tie mr-1\"></i> Drivers\n");
      out.write("                        </a>\n");
      out.write("                        <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/transport/manageVehicles.jsp\" \n");
      out.write("                           class=\"px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-indigo-600 flex items-center transition-colors ");
      out.print( pageName.equals("manageVehicles.jsp") ? "bg-indigo-700" : "" );
      out.write("\">\n");
      out.write("                            <i class=\"fas fa-car mr-1\"></i> Vehicles\n");
      out.write("                        </a>\n");
      out.write("                        <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/transport/assignResources.jsp\" \n");
      out.write("                           class=\"px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-indigo-600 flex items-center transition-colors ");
      out.print( pageName.equals("assignResources.jsp") ? "bg-indigo-700" : "" );
      out.write("\">\n");
      out.write("                            <i class=\"fas fa-clipboard-list mr-1\"></i> Assign\n");
      out.write("                        </a>\n");
      out.write("                        <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/transport/viewAssignments.jsp\" \n");
      out.write("                           class=\"px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-indigo-600 flex items-center transition-colors ");
      out.print( pageName.equals("viewAssignments.jsp") ? "bg-indigo-700" : "" );
      out.write("\">\n");
      out.write("                            <i class=\"fas fa-list-alt mr-1\"></i> Assignments\n");
      out.write("                        </a>\n");
      out.write("                    </nav>\n");
      out.write("                </div>\n");
      out.write("            </div>\n");
      out.write("            \n");
      out.write("            <!-- User Menu -->\n");
      out.write("            <div class=\"hidden md:block\">\n");
      out.write("                <div class=\"flex items-center\">\n");
      out.write("                    <div class=\"relative ml-3\">\n");
      out.write("                        <button type=\"button\" \n");
      out.write("                                class=\"max-w-xs flex items-center text-sm rounded-full text-white focus:outline-none transition-colors group\"\n");
      out.write("                                id=\"userMenuButton\" \n");
      out.write("                                onclick=\"document.getElementById('userDropdown').classList.toggle('hidden')\">\n");
      out.write("                            <span class=\"bg-indigo-600 p-2 rounded-lg group-hover:bg-indigo-700\">\n");
      out.write("                                <i class=\"fas fa-user-circle text-xl mr-2\"></i>\n");
      out.write("                                ");
 if(currentUser != null) { 
      out.write("\n");
      out.write("                                ");
      out.print( currentUser.getUsername() );
      out.write("\n");
      out.write("                                ");
 } 
      out.write("\n");
      out.write("                                <i class=\"fas fa-chevron-down ml-1 text-xs\"></i>\n");
      out.write("                            </span>\n");
      out.write("                        </button>\n");
      out.write("                        \n");
      out.write("                        <!-- Profile dropdown panel -->\n");
      out.write("                        <div id=\"userDropdown\" class=\"hidden origin-top-right absolute right-0 mt-2 w-48 rounded-md shadow-lg py-1 bg-white ring-1 ring-black ring-opacity-5 focus:outline-none z-10\" role=\"menu\" aria-orientation=\"vertical\" aria-labelledby=\"user-menu-button\">\n");
      out.write("                            <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/profile.jsp\" class=\"block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100\" role=\"menuitem\">\n");
      out.write("                                <i class=\"fas fa-user mr-2\"></i> Your Profile\n");
      out.write("                            </a>\n");
      out.write("                            <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/settings.jsp\" class=\"block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100\" role=\"menuitem\">\n");
      out.write("                                <i class=\"fas fa-cog mr-2\"></i> Settings\n");
      out.write("                            </a>\n");
      out.write("                            <hr class=\"my-1\">\n");
      out.write("                            <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/logout\" class=\"block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100\" role=\"menuitem\">\n");
      out.write("                                <i class=\"fas fa-sign-out-alt mr-2\"></i> Sign out\n");
      out.write("                            </a>\n");
      out.write("                        </div>\n");
      out.write("                    </div>\n");
      out.write("                </div>\n");
      out.write("            </div>\n");
      out.write("        </div>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <!-- Mobile menu, show/hide based on menu state -->\n");
      out.write("    <div class=\"sm:hidden hidden\" id=\"mobile-menu\">\n");
      out.write("        <div class=\"px-2 pt-2 pb-3 space-y-1 bg-indigo-800 border-t border-indigo-700\">\n");
      out.write("            <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/transport/dashboard.jsp\" \n");
      out.write("               class=\"block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors ");
      out.print( pageName.equals("dashboard.jsp") ? "bg-indigo-700" : "" );
      out.write("\">\n");
      out.write("                <i class=\"fas fa-tachometer-alt mr-2\"></i> Dashboard\n");
      out.write("            </a>\n");
      out.write("            \n");
      out.write("            <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/transport/manageDrivers.jsp\" \n");
      out.write("               class=\"block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors ");
      out.print( pageName.equals("manageDrivers.jsp") ? "bg-indigo-700" : "" );
      out.write("\">\n");
      out.write("                <i class=\"fas fa-user-tie mr-2\"></i> Manage Drivers\n");
      out.write("            </a>\n");
      out.write("            \n");
      out.write("            <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/transport/manageVehicles.jsp\" \n");
      out.write("               class=\"block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors ");
      out.print( pageName.equals("manageVehicles.jsp") ? "bg-indigo-700" : "" );
      out.write("\">\n");
      out.write("                <i class=\"fas fa-car mr-2\"></i> Manage Vehicles\n");
      out.write("            </a>\n");
      out.write("            \n");
      out.write("            <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/transport/assignResources.jsp\" \n");
      out.write("               class=\"block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors ");
      out.print( pageName.equals("assignResources.jsp") ? "bg-indigo-700" : "" );
      out.write("\">\n");
      out.write("                <i class=\"fas fa-clipboard-list mr-2\"></i> Assign Resources\n");
      out.write("            </a>\n");
      out.write("            \n");
      out.write("            <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/transport/viewAssignments.jsp\" \n");
      out.write("               class=\"block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors ");
      out.print( pageName.equals("viewAssignments.jsp") ? "bg-indigo-700" : "" );
      out.write("\">\n");
      out.write("                <i class=\"fas fa-list-alt mr-2\"></i> View Assignments\n");
      out.write("            </a>\n");
      out.write("            \n");
      out.write("            <hr class=\"border-indigo-600 my-2\">\n");
      out.write("            \n");
      out.write("            <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/profile.jsp\" \n");
      out.write("               class=\"block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors\">\n");
      out.write("                <i class=\"fas fa-user mr-2\"></i> Your Profile\n");
      out.write("            </a>\n");
      out.write("            \n");
      out.write("            <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/settings.jsp\" \n");
      out.write("               class=\"block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors\">\n");
      out.write("                <i class=\"fas fa-cog mr-2\"></i> Settings\n");
      out.write("            </a>\n");
      out.write("            \n");
      out.write("            <a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null));
      out.write("/logout\" \n");
      out.write("               class=\"block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-indigo-600 transition-colors\">\n");
      out.write("                <i class=\"fas fa-sign-out-alt mr-2\"></i> Sign out\n");
      out.write("            </a>\n");
      out.write("        </div>\n");
      out.write("    </div>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<script>\n");
      out.write("    // Toggle mobile menu\n");
      out.write("    document.getElementById('mobile-menu-button').addEventListener('click', function() {\n");
      out.write("        document.getElementById('mobile-menu').classList.toggle('hidden');\n");
      out.write("    });\n");
      out.write("    \n");
      out.write("    // Close dropdown when clicking outside\n");
      out.write("    document.addEventListener('click', function(event) {\n");
      out.write("        const userMenuButton = document.getElementById('userMenuButton');\n");
      out.write("        const userDropdown = document.getElementById('userDropdown');\n");
      out.write("        \n");
      out.write("        if (userMenuButton && userDropdown && !userMenuButton.contains(event.target) && !userDropdown.contains(event.target)) {\n");
      out.write("            userDropdown.classList.add('hidden');\n");
      out.write("        }\n");
      out.write("    });\n");
      out.write("</script>\n");
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
