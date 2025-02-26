package com.academictrip.model;

public class Destination {
    private String destinationId;
    private String name;

    // Constructors
    public Destination() {}
    public Destination(String destinationId, String name) {
        this.destinationId = destinationId;
        this.name = name;
    }

    // Getters and Setters
    public String getDestinationId() { return destinationId; }
    public void setDestinationId(String destinationId) { this.destinationId = destinationId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    @Override
    public String toString() {
        return "Destination [destinationId=" + destinationId + ", name=" + name + "]";
    }
}