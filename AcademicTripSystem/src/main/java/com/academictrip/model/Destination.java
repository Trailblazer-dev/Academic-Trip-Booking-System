package com.academictrip.model;

public class Destination {
    private String destinationId;
    private String name;
    private String location;
    private int distance;

    // Constructors
    public Destination() {}
    public Destination(String destinationId, String name) {
        this.destinationId = destinationId;
        this.name = name;
    }
    public Destination(String destinationId, String name, String location, int distance) {
        this.destinationId = destinationId;
        this.name = name;
        this.location = location;
        this.distance = distance;
    }

    // Getters and Setters
    public String getDestinationId() { return destinationId; }
    public void setDestinationId(String destinationId) { this.destinationId = destinationId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public int getDistance() { return distance; }
    public void setDistance(int distance) { this.distance = distance; }

    @Override
    public String toString() {
        return name;
    }
}