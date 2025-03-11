package com.academictrip.model;

public class Course {
    private String courseId;
    private String courseName;
    private String facultyId;

    // Reference to Faculty object
    private Faculty faculty;

    // Constructors
    public Course() {}

    public Course(String courseId, String courseName, String facultyId) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.facultyId = facultyId;
    }

    // Getters and setters
    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getFacultyId() {
        return facultyId;
    }

    public void setFacultyId(String facultyId) {
        this.facultyId = facultyId;
    }

    // Alias methods for UI consistency
    public String getName() {
        return courseName;
    }

    public void setName(String name) {
        this.courseName = name;
    }

    public String getCode() {
        return courseId;
    }

    // Faculty relationship methods
    public Faculty getFaculty() {
        return faculty;
    }

    public void setFaculty(Faculty faculty) {
        this.faculty = faculty;
        if (faculty != null) {
            this.facultyId = faculty.getFacultyId();
        }
    }

    @Override
    public String toString() {
        return courseName;
    }
}