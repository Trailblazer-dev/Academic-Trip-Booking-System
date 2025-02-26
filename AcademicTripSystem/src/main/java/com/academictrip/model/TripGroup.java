package com.academictrip.model;

public class TripGroup {
    private String groupId;
    private String groupName;
    private int studentNumber;
    private String courseId;

    // Constructors
    public TripGroup() {}
    public TripGroup(String groupId, String groupName, int studentNumber, String courseId) {
        this.groupId = groupId;
        this.groupName = groupName;
        this.studentNumber = studentNumber;
        this.courseId = courseId;
    }

    // Getters and Setters
    public String getGroupId() { return groupId; }
    public void setGroupId(String groupId) { this.groupId = groupId; }
    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }
    public int getStudentNumber() { return studentNumber; }
    public void setStudentNumber(int studentNumber) { this.studentNumber = studentNumber; }
    public String getCourseId() { return courseId; }
    public void setCourseId(String courseId) { this.courseId = courseId; }

    @Override
    public String toString() {
        return "TripGroup [groupId=" + groupId + ", groupName=" + groupName + "]";
    }
}