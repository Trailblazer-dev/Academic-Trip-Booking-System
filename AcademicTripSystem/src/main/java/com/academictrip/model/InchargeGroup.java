package com.academictrip.model;

public class InchargeGroup {
    private String inchargeGroupId;
    private String inchargeId;
    private String groupId;

    // Constructors
    public InchargeGroup() {}
    public InchargeGroup(String inchargeGroupId, String inchargeId, String groupId) {
        this.inchargeGroupId = inchargeGroupId;
        this.inchargeId = inchargeId;
        this.groupId = groupId;
    }

    // Getters and Setters
    public String getInchargeGroupId() { return inchargeGroupId; }
    public void setInchargeGroupId(String inchargeGroupId) { this.inchargeGroupId = inchargeGroupId; }
    public String getInchargeId() { return inchargeId; }
    public void setInchargeId(String inchargeId) { this.inchargeId = inchargeId; }
    public String getGroupId() { return groupId; }
    public void setGroupId(String groupId) { this.groupId = groupId; }

    @Override
    public String toString() {
        return "InchargeGroup [inchargeGroupId=" + inchargeGroupId + ", inchargeId=" + inchargeId + "]";
    }
}