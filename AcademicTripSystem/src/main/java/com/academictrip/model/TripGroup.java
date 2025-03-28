package com.academictrip.model;

public class TripGroup {
    private String groupId;
    private String groupName;
    private int studentNumber;
    private String courseId;

    // Relationship object
    private Course course;

    // Constructors
    public TripGroup() {}

    public TripGroup(String groupId, String groupName, int studentNumber, String courseId) {
        this.groupId = groupId;
        this.groupName = groupName;
        this.studentNumber = studentNumber;
        this.courseId = courseId;
    }

    // Getters and setters
    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public int getStudentNumber() {
        return studentNumber;
    }

    public void setStudentNumber(int studentNumber) {
        this.studentNumber = studentNumber;
    }

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    // Relationship methods
    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
        if (course != null) {
            this.courseId = course.getCourseId();
        }
    }
}