package com.academictrip.model;

public class Driver {
    private String driverId;
    private String firstname;
    private String lastname;
    private String phoneNumber;
    private String email;

    // Constructors
    public Driver() {}

    public Driver(String driverId, String firstname, String lastname, String phoneNumber, String email) {
        this.driverId = driverId;
        this.firstname = firstname;
        this.lastname = lastname;
        this.phoneNumber = phoneNumber;
        this.email = email;
    }

    // Getters and Setters
    public String getDriverId() { return driverId; }
    public void setDriverId(String driverId) { this.driverId = driverId; }

    public String getFirstname() { return firstname; }
    public void setFirstname(String firstname) { this.firstname = firstname; }

    public String getLastname() { return lastname; }
    public void setLastname(String lastname) { this.lastname = lastname; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    /**
     * Get the full name (firstname + lastname)
     * @return Full name or null if both first and last names are null
     */
    public String getFullName() {
        if (firstname != null && lastname != null) {
            return firstname + " " + lastname;
        } else if (firstname != null) {
            return firstname;
        } else if (lastname != null) {
            return lastname;
        }
        return null;
    }

    // Alias methods for JSP consistency
    public String getName() {
        return getFullName();
    }

    public String getPhone() {
        return this.phoneNumber != null ? this.phoneNumber.toString() : "";
    }

    @Override
    public String toString() {
        return "Driver [driverId=" + driverId + ", name=" + getFullName() + "]";
    }
}