package com.academictrip.controller;

import com.academictrip.dao.*;
import com.academictrip.model.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

public class AddTripServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get all form parameters
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String inchargeFirstName = request.getParameter("inchargeFirstName");
        String inchargeLastName = request.getParameter("inchargeLastName");
        String inchargePhone = request.getParameter("inchargePhone");
        String inchargeEmail = request.getParameter("inchargeEmail");
        String groupName = request.getParameter("groupName");
        int studentCount = Integer.parseInt(request.getParameter("studentCount"));
        String courseName = request.getParameter("courseName");
        String facultyName = request.getParameter("facultyName");
        String destinationName = request.getParameter("destinationName");

        
        try {
        	 System.out.println("=== STARTING TRIP CREATION ===");
            // 1. Faculty
            FacultyDAO facultyDAO = new FacultyDAO();
            Faculty faculty = facultyDAO.findFacultyByName(facultyName);
            if (faculty == null) {
                faculty = new Faculty();
                faculty.setName(facultyName);
                facultyDAO.insertFaculty(faculty); // Auto-generates faculty_id
            }

            // 2. Course
            CourseDAO courseDAO = new CourseDAO();
            Course course = courseDAO.findCourseByName(courseName);
            if (course == null) {
                course = new Course();
                course.setCourseName(courseName);
                course.setFacultyId(faculty.getFacultyId());
                courseDAO.insertCourse(course); // Auto-generates course_id
            }

            // 3. Incharge
            InchargeDAO inchargeDAO = new InchargeDAO();
            Incharge incharge = inchargeDAO.findInchargeByEmail(inchargeEmail);
            if (incharge == null) {
                incharge = new Incharge();
                incharge.setFirstName(inchargeFirstName);
                incharge.setLastName(inchargeLastName);
                incharge.setPhoneNumber(Integer.parseInt(inchargePhone));
                incharge.setEmail(inchargeEmail);
                incharge.setFacultyId(faculty.getFacultyId());
                inchargeDAO.insertIncharge(incharge); // Auto-generates incharge_id
            }

            
            // 5. Destination
            DestinationDAO destinationDAO = new DestinationDAO();
            Destination destination = destinationDAO.findDestinationByName(destinationName);
            if (destination == null) {
                destination = new Destination();
                destination.setName(destinationName);
                destinationDAO.insertDestination(destination); // Auto-generates destination_id
            }

            // 6. Trip_Group
            TripGroupDAO tripGroupDAO = new TripGroupDAO();
            TripGroup tripGroup = new TripGroup();
            tripGroup.setGroupName(groupName);
            tripGroup.setStudentNumber(studentCount);
            tripGroup.setCourseId(course.getCourseId());
            tripGroupDAO.insertTripGroup(tripGroup);
            
            // 4. Incharge_Group
            InchargeGroupDAO inchargeGroupDAO = new InchargeGroupDAO();
            InchargeGroup group = new InchargeGroup();
            group.setInchargeId(incharge.getInchargeId());
            group.setGroupId(tripGroup.getGroupId());  // Use TripGroup's generated ID
            inchargeGroupDAO.insertInchargeGroup(group);

            // 6. Create temporary driver-vehicle assignment
            DriverVehicleDAO driverVehicleDAO = new DriverVehicleDAO();
            DriverVehicle tempAssignment = new DriverVehicle();
            tempAssignment.setDriverId("DEFAULT"); // Use a placeholder driver
            tempAssignment.setVehicleId("DEFAULT"); // Use a placeholder vehicle
            String driverVehicleId = driverVehicleDAO.insertAssignment(tempAssignment);


            // 7. Trip
            TripDAO tripDAO = new TripDAO();
            Trip trip = new Trip();
            trip.setStartDate(startDate);
            trip.setEndDate(endDate);
            trip.setInchargeGroupId(group.getInchargeGroupId());
            trip.setDestinationId(destination.getDestinationId());

            tripDAO.insertTrip(trip); // This now generates trip_id
            
      

            response.sendRedirect(request.getContextPath() + "/success.jsp");
            
            
         // After each DAO operation
            System.out.println("Inserted Faculty: " + faculty);
            System.out.println("Inserted Course: " + course);
            System.out.println("Inserted Incharge: " + incharge);
            System.out.println("Inserted Destination: " + destination);
            
            System.out.println("=== TRIP CREATION SUCCESSFUL ===");

        } catch (SQLException e) {
        	// Enhanced error logging
            System.err.println("SQL Error Code: " + e.getErrorCode());
            System.err.println("SQL State: " + e.getSQLState());
            e.printStackTrace();
            request.setAttribute("error", e);
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}