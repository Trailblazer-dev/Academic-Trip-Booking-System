package com.academictrip.model;

public class InchargeGroup {
    private String inchargeGroupId;
    private String inchargeId;
    private String groupId;

    // Relationship objects
    private Incharge incharge;
    private TripGroup tripGroup;

    // Constructors
    public InchargeGroup() {}

    public InchargeGroup(String inchargeGroupId, String inchargeId, String groupId) {
        this.inchargeGroupId = inchargeGroupId;
        this.inchargeId = inchargeId;
        this.groupId = groupId;
    }

    // Getters and setters
    public String getInchargeGroupId() {
        return inchargeGroupId;
    }

    public void setInchargeGroupId(String inchargeGroupId) {
        this.inchargeGroupId = inchargeGroupId;
    }

    public String getInchargeId() {
        return inchargeId;
    }

    public void setInchargeId(String inchargeId) {
        this.inchargeId = inchargeId;
    }

    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }

    // Relationship methods
    public Incharge getIncharge() {
        return incharge;
    }

    public void setIncharge(Incharge incharge) {
        this.incharge = incharge;
        if (incharge != null) {
            this.inchargeId = incharge.getInchargeId();
        }
    }

    public TripGroup getTripGroup() {
        return tripGroup;
    }

    public void setTripGroup(TripGroup tripGroup) {
        this.tripGroup = tripGroup;
        if (tripGroup != null) {
            this.groupId = tripGroup.getGroupId();
        }
    }
}