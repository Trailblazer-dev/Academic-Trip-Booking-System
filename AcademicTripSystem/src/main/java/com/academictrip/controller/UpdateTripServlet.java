package com.academictrip.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
// NOTE: @WebServlet annotation is NOT used here because this servlet is configured in web.xml
// Adding the annotation would cause duplicate mapping errors
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.academictrip.dao.CourseDAO;
import com.academictrip.dao.DestinationDAO;
import com.academictrip.dao.FacultyDAO;
import com.academictrip.dao.InchargeDAO;
import com.academictrip.dao.InchargeGroupDAO;
import com.academictrip.dao.TripDAO;
import com.academictrip.dao.TripGroupDAO;
import com.academictrip.model.Course;
import com.academictrip.model.Destination;
import com.academictrip.model.Faculty;
import com.academictrip.model.Incharge;
import com.academictrip.model.InchargeGroup;
import com.academictrip.model.Trip;
import com.academictrip.model.TripGroup;

/**
 * Servlet implementation class UpdateTripServlet
 * Handles updating existing trips in the system
 *
 * IMPORTANT: This servlet is configured in web.xml and should NOT use @WebServlet annotation
 */
public class UpdateTripServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Get all form parameters
        String tripId = request.getParameter("tripId");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String inchargeFirstName = request.getParameter("inchargeFirstName");
        String inchargeLastName = request.getParameter("inchargeLastName");
        String inchargePhone = request.getParameter("inchargePhone");
        String inchargeEmail = request.getParameter("inchargeEmail");
        String groupName = request.getParameter("groupName");
        String studentCountStr = request.getParameter("studentCount");
        String courseName = request.getParameter("courseName");
        String facultyName = request.getParameter("facultyName");
        String destinationName = request.getParameter("destinationName");

        // Validate required fields
        if (tripId == null || startDate == null || endDate == null || inchargeFirstName == null ||
            inchargeLastName == null || inchargePhone == null || inchargeEmail == null ||
            groupName == null || studentCountStr == null || courseName == null ||
            facultyName == null || destinationName == null) {

            session.setAttribute("errorMessage", "All fields are required");
            response.sendRedirect(request.getContextPath() + "/lecturer/editTrip.jsp?id=" + tripId);
            return;
        }

        int studentCount;
        try {
            studentCount = Integer.parseInt(studentCountStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid student count");
            response.sendRedirect(request.getContextPath() + "/lecturer/editTrip.jsp?id=" + tripId);
            return;
        }

        try {
            // Get existing trip to update
            TripDAO tripDAO = new TripDAO();
            Trip trip = tripDAO.getTripById(tripId);

            if (trip == null) {
                session.setAttribute("errorMessage", "Trip not found");
                response.sendRedirect(request.getContextPath() + "/lecturer/dashboard.jsp");
                return;
            }

            // 1. Faculty
            FacultyDAO facultyDAO = new FacultyDAO();
            Faculty faculty = facultyDAO.findFacultyByName(facultyName);
            if (faculty == null) {
                faculty = new Faculty();
                faculty.setName(facultyName);
                facultyDAO.insertFaculty(faculty);
            }

            // 2. Course
            CourseDAO courseDAO = new CourseDAO();
            Course course = courseDAO.findCourseByName(courseName);
            if (course == null) {
                course = new Course();
                course.setCourseName(courseName);
                course.setFacultyId(faculty.getFacultyId());
                courseDAO.insertCourse(course);
            }

            // 3. Destination
            DestinationDAO destinationDAO = new DestinationDAO();
            Destination destination = destinationDAO.findDestinationByName(destinationName);
            if (destination == null) {
                destination = new Destination();
                destination.setName(destinationName);
                destinationDAO.insertDestination(destination);
            }

            // 4. Process incharge and group information
            InchargeDAO inchargeDAO = new InchargeDAO();
            Incharge incharge = inchargeDAO.findInchargeByEmail(inchargeEmail);

            if (incharge == null) {
                // Create new incharge
                incharge = new Incharge();
                incharge.setFirstName(inchargeFirstName);
                incharge.setLastName(inchargeLastName);
                incharge.setPhoneNumber(Integer.parseInt(inchargePhone));
                incharge.setEmail(inchargeEmail);
                incharge.setFacultyId(faculty.getFacultyId());
                inchargeDAO.insertIncharge(incharge);
            } else {
                // Update existing incharge
                incharge.setFirstName(inchargeFirstName);
                incharge.setLastName(inchargeLastName);
                incharge.setPhoneNumber(Integer.parseInt(inchargePhone));
                inchargeDAO.updateIncharge(incharge);
            }

            // 5. Get the existing incharge group info
            InchargeGroupDAO inchargeGroupDAO = new InchargeGroupDAO();
            InchargeGroup inchargeGroup = inchargeGroupDAO.getInchargeGroupById(trip.getInchargeGroupId());

            // 6. Update trip group information
            TripGroupDAO tripGroupDAO = new TripGroupDAO();
            TripGroup tripGroup;

            if (inchargeGroup != null) {
                // Update existing trip group
                tripGroup = tripGroupDAO.getTripGroupById(inchargeGroup.getGroupId());
                if (tripGroup != null) {
                    tripGroup.setGroupName(groupName);
                    tripGroup.setStudentNumber(studentCount);
                    tripGroup.setCourseId(course.getCourseId());
                    tripGroupDAO.updateTripGroup(tripGroup);

                    // Update incharge in the incharge group
                    inchargeGroup.setInchargeId(incharge.getInchargeId());
                    inchargeGroupDAO.updateInchargeGroup(inchargeGroup);
                }
            }

            // 7. Update trip dates and destination
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate startLocalDate = LocalDate.parse(startDate, formatter);
            LocalDate endLocalDate = LocalDate.parse(endDate, formatter);

            trip.setStartDate(startLocalDate);
            trip.setEndDate(endLocalDate);
            trip.setDestinationId(destination.getDestinationId());

            // Update the trip in the database
            tripDAO.updateTrip(trip);

            // After successful update, redirect to view trip
            session.setAttribute("successMessage", "Trip updated successfully!");
            response.sendRedirect(request.getContextPath() + "/lecturer/viewTrip.jsp?id=" + tripId);

        } catch (SQLException e) {
            // Log error and redirect with error message
            e.printStackTrace();
            session.setAttribute("errorMessage", "Failed to update trip: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/lecturer/editTrip.jsp?id=" + tripId);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/lecturer/editTrip.jsp?id=" + tripId);
        }
    }
}