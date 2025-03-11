package com.academictrip.model;

import java.time.LocalDate;

public class DriverVehicle {
    private String assignmentId;
    private String driverId;
    private String vehicleId;
    private LocalDate startDate;
    private LocalDate endDate;
    private String notes;

    // Transient objects for relationships
    private Driver driver;
    private Vehicle vehicle;

    public DriverVehicle() {
    }

    public DriverVehicle(String assignmentId, String driverId, String vehicleId) {
        this.assignmentId = assignmentId;
        this.driverId = driverId;
        this.vehicleId = vehicleId;
    }

    // Getter and setter for assignmentId
    public String getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(String assignmentId) {
        this.assignmentId = assignmentId;
    }

    // Existing getters and setters for driverId and vehicleId
    public String getDriverId() {
        return driverId;
    }

    public void setDriverId(String driverId) {
        this.driverId = driverId;
    }

    public String getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(String vehicleId) {
        this.vehicleId = vehicleId;
    }

    // New getters and setters for startDate, endDate, and notes
    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    // Add compatibility methods for assignment fields
    public String getDriverVehicleId() {
        return assignmentId;
    }

    public void setDriverVehicleId(String driverVehicleId) {
        this.assignmentId = driverVehicleId;
    }

    public LocalDate getAssignmentStart() {
        return startDate;
    }

    public void setAssignmentStart(LocalDate assignmentStart) {
        this.startDate = assignmentStart;
    }

    public LocalDate getAssignmentEnd() {
        return endDate;
    }

    public void setAssignmentEnd(LocalDate assignmentEnd) {
        this.endDate = assignmentEnd;
    }

    // Driver and Vehicle relationship methods
    public Driver getDriver() {
        return driver;
    }

    public void setDriver(Driver driver) {
        this.driver = driver;
        if (driver != null) {
            this.driverId = driver.getDriverId();
        }
    }

    public Vehicle getVehicle() {
        return vehicle;
    }

    public void setVehicle(Vehicle vehicle) {
        this.vehicle = vehicle;
        if (vehicle != null) {
            this.vehicleId = vehicle.getVehicleId();
        }
    }

    @Override
    public String toString() {
        return "DriverVehicle [assignmentId=" + assignmentId + ", driverId=" + driverId +
               ", vehicleId=" + vehicleId + ", startDate=" + startDate + ", endDate=" + endDate + "]";
    }
}