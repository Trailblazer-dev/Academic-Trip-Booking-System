package com.academictrip.model;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import com.academictrip.dao.CourseDAO;
import com.academictrip.dao.DestinationDAO;
import com.academictrip.dao.InchargeGroupDAO;
import com.academictrip.dao.TripGroupDAO;

public class Trip {
    private String tripId;
    private LocalDate startDate;
    private LocalDate endDate;
    private String inchargeGroupId;
    private String driverVehicleId;
    private String destinationId;
    private String purpose; // Additional field not in DB schema
    private Destination destination; // Reference to Destination object

    // Additional fields for relationships
    private Course course;
    private Faculty faculty;
    private InchargeGroup inchargeGroup;
    private DriverVehicle driverVehicle;
    private String notes;
    private LocalDate createdAt;
    private String inchargeId;
    private String lecturerId;

    // Constructors
    public Trip() {}

    public Trip(String tripId, LocalDate startDate, LocalDate endDate, String destinationId,
                String driverVehicleId, String inchargeGroupId) {
        this.tripId = tripId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.destinationId = destinationId;
        this.driverVehicleId = driverVehicleId;
        this.inchargeGroupId = inchargeGroupId;
    }

    // Core getter and setter methods
    public String getTripId() { return tripId; }
    public void setTripId(String tripId) { this.tripId = tripId; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public String getInchargeGroupId() { return inchargeGroupId; }
    public void setInchargeGroupId(String inchargeGroupId) { this.inchargeGroupId = inchargeGroupId; }

    public String getDriverVehicleId() { return driverVehicleId; }
    public void setDriverVehicleId(String driverVehicleId) { this.driverVehicleId = driverVehicleId; }

    public String getDestinationId() { return destinationId; }
    public void setDestinationId(String destinationId) { this.destinationId = destinationId; }

    // Alias methods for UI consistency
    public LocalDate getDepartureDate() { return startDate; }
    public LocalDate getReturnDate() { return endDate; }

    /**
     * Checks if trip is completed (end date is in the past)
     * @return true if trip is completed, false otherwise
     */
    public boolean isCompleted() {
        return endDate != null && endDate.isBefore(LocalDate.now());
    }

    // Purpose field methods (not in DB schema but needed for UI)
    public String getPurpose() { return purpose != null ? purpose : "Academic Trip"; }
    public void setPurpose(String purpose) { this.purpose = purpose; }

    // Destination object methods
    public Destination getDestination() {
        // Lazy load destination if needed
        if (destination == null && destinationId != null) {
            try {
                DestinationDAO destinationDAO = new DestinationDAO();
                destination = destinationDAO.getDestinationById(destinationId);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return destination;
    }

    public void setDestination(Destination destination) {
        this.destination = destination;
        if (destination != null) {
            this.destinationId = destination.getDestinationId();
        }
    }

    // Helper methods for JSP formatting
    public String getStartDateFormatted() {
        return startDate != null ? startDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) : null;
    }

    public String getEndDateFormatted() {
        return endDate != null ? endDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) : null;
    }

    // Methods to get related data
    public String getCourseTitle() {
        try {
            // Get the incharge group to find the group_id
            InchargeGroupDAO inchargeGroupDAO = new InchargeGroupDAO();
            InchargeGroup inchargeGroup = inchargeGroupDAO.getInchargeGroupById(this.getInchargeGroupId());

            if (inchargeGroup != null) {
                // Get the trip group to find the course_id
                TripGroupDAO tripGroupDAO = new TripGroupDAO();
                TripGroup tripGroup = tripGroupDAO.getTripGroupById(inchargeGroup.getGroupId());

                if (tripGroup != null) {
                    // Get the course name using course_id
                    CourseDAO courseDAO = new CourseDAO();
                    Course course = courseDAO.getCourseById(tripGroup.getCourseId());

                    if (course != null) {
                        return course.getCourseName();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    public int getNumberOfStudents() {
        try {
            // Get the incharge group to find the group_id
            InchargeGroupDAO inchargeGroupDAO = new InchargeGroupDAO();
            InchargeGroup inchargeGroup = inchargeGroupDAO.getInchargeGroupById(this.getInchargeGroupId());

            if (inchargeGroup != null) {
                // Get the trip group to find student numbers
                TripGroupDAO tripGroupDAO = new TripGroupDAO();
                TripGroup tripGroup = tripGroupDAO.getTripGroupById(inchargeGroup.getGroupId());

                if (tripGroup != null) {
                    return tripGroup.getStudentNumber();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Id getter and setter
    public String getId() {
        return this.getTripId();
    }

    // Trip date accessor for UI consistency
    public LocalDate getTripDate() {
        return this.getStartDate();
    }

    // Enhanced getter for Course that ensures non-null return
    public Course getCourse() {
        if (course == null) {
            // Create a default Course if none exists
            course = new Course();
            course.setCourseName("Not Assigned");
            course.setCourseId("N/A");
        }
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    // Enhanced getter for Faculty that ensures non-null return
    public Faculty getFaculty() {
        if (faculty == null) {
            // Create a default Faculty if none exists
            faculty = new Faculty();
            faculty.setName("Not Assigned");
        }
        return faculty;
    }

    public void setFaculty(Faculty faculty) {
        this.faculty = faculty;
    }

    // Getter and setter for inchargeGroup
    public InchargeGroup getInchargeGroup() {
        return inchargeGroup;
    }

    public void setInchargeGroup(InchargeGroup inchargeGroup) {
        this.inchargeGroup = inchargeGroup;
    }

    // Getter and setter for createdAt
    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }

    // Getter and setter for notes
    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    // Getter and setter for inchargeId
    public String getInchargeId() {
        return inchargeId;
    }

    public void setInchargeId(String inchargeId) {
        this.inchargeId = inchargeId;
    }

    // Getter and setter for lecturerId
    public String getLecturerId() {
        return lecturerId;
    }

    public void setLecturerId(String lecturerId) {
        this.lecturerId = lecturerId;
    }

    // Getter and setter for driverVehicle
    public DriverVehicle getDriverVehicle() {
        return driverVehicle;
    }

    public void setDriverVehicle(DriverVehicle driverVehicle) {
        this.driverVehicle = driverVehicle;
        if (driverVehicle != null) {
            this.driverVehicleId = driverVehicle.getDriverVehicleId();
        }
    }

    @Override
    public String toString() {
        return "Trip [tripId=" + tripId + ", startDate=" + startDate + ", endDate=" + endDate + "]";
    }
}