package com.academictrip.model;

public class Incharge {
    private String inchargeId;
    private String firstName;
    private String lastName;
    private int phoneNumber;
    private String email;
    private String facultyId;
    private Faculty faculty;

    // Constructors
    public Incharge() {}
    public Incharge(String inchargeId, String firstName, String lastName, int phoneNumber, String email, String facultyId) {
        this.inchargeId = inchargeId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.facultyId = facultyId;
    }

    // Getters and Setters
    public String getInchargeId() { return inchargeId; }
    public void setInchargeId(String inchargeId) { this.inchargeId = inchargeId; }
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public int getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(int phoneNumber) { this.phoneNumber = phoneNumber; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getFacultyId() { return facultyId; }
    public void setFacultyId(String facultyId) { this.facultyId = facultyId; }

    // For backward compatibility
    public void setName(String name) {
        if (name != null && !name.isEmpty()) {
            String[] parts = name.split(" ", 2);
            this.firstName = parts[0];
            if (parts.length > 1) {
                this.lastName = parts[1];
            } else {
                this.lastName = "";
            }
        }
    }

    // Faculty relationship
    public Faculty getFaculty() {
        return faculty;
    }
    public void setFaculty(Faculty faculty) {
        this.faculty = faculty;
        if (faculty != null) {
            this.facultyId = faculty.getFacultyId();
        }
    }

    public String getFullName() {
        return firstName + " " + lastName;
    }

    // Additional alias methods for JSP consistency
    public String getName() {
        return getFullName();
    }

    public String getPhone() {
        return String.valueOf(phoneNumber);
    }

    @Override
    public String toString() {
        return "Incharge [inchargeId=" + inchargeId + ", firstName=" + firstName + ", lastName=" + lastName + "]";
    }
}