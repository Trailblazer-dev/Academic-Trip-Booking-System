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

    @Override
    public String toString() {
        return "Trip [tripId=" + tripId + ", startDate=" + startDate + ", endDate=" + endDate + "]";
    }
}