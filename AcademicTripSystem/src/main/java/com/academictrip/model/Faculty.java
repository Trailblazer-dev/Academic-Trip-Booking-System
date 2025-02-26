package com.academictrip.model;

public class Faculty {
    private String facultyId;
    private String name;

    // Constructors
    public Faculty() {}
    public Faculty(String facultyId, String name) {
        this.facultyId = facultyId;
        this.name = name;
    }

    // Getters and Setters
    public String getFacultyId() { return facultyId; }
    public void setFacultyId(String facultyId) { this.facultyId = facultyId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    @Override
    public String toString() {
        return "Faculty [facultyId=" + facultyId + ", name=" + name + "]";
    }
}