# Database Schema - Academic Trip System

This document describes the database schema for the Academic Trip System, including tables, relationships, and key fields.

## Entity Relationship Diagram

![Entity Relationship Diagram](../images/erd-diagram.png)

## Database Tables

### 1. users

Stores system user information.

| Column      | Type                         | Constraints           | Description                    |
|-------------|------------------------------|------------------------|-------------------------------|
| id          | INT                          | PRIMARY KEY, AUTO_INCREMENT | Unique identifier for the user |
| username    | VARCHAR(50)                  | NOT NULL, UNIQUE      | User's login username          |
| password    | VARCHAR(255)                 | NOT NULL              | Hashed password                |
| role        | ENUM('lecturer','transport') | NOT NULL              | User role (lecturer, transport) |

### 2. Trip

Stores academic trip information.

| Column          | Type         | Constraints      | Description                      |
|-----------------|--------------|------------------|----------------------------------|
| trip_id         | VARCHAR(10)  | PRIMARY KEY      | Unique identifier for the trip   |
| start_date      | DATE         | NOT NULL         | Trip departure date              |
| end_date        | DATE         | NOT NULL         | Trip return date                 |
| incharge_group_id | VARCHAR(10)  | FOREIGN KEY      | Reference to Incharge_Group table |
| driver_vehicle_id | VARCHAR(10)  | FOREIGN KEY, NULL | Reference to Driver_Vehicle table |
| destination_id  | VARCHAR(10)  | FOREIGN KEY      | Reference to Destination table   |

### 3. Destination

Stores destination information.

| Column        | Type         | Constraints      | Description                          |
|---------------|--------------|------------------|--------------------------------------|
| destination_id | VARCHAR(10)  | PRIMARY KEY      | Unique identifier for the destination |
| name          | VARCHAR(255) | NOT NULL         | Destination name                     |

### 4. Faculty

Stores faculty information.

| Column     | Type         | Constraints      | Description                       |
|------------|--------------|------------------|-----------------------------------|
| faculty_id | VARCHAR(10)  | PRIMARY KEY      | Unique identifier for the faculty |
| name       | VARCHAR(255) | YES              | Faculty name                      |

### 5. Course

Stores course information.

| Column     | Type         | Constraints      | Description                      |
|------------|--------------|------------------|----------------------------------|
| course_id  | VARCHAR(10)  | PRIMARY KEY      | Unique identifier for the course |
| course_name| VARCHAR(255) | NOT NULL         | Course name                      |
| faculty_id | VARCHAR(10)  | FOREIGN KEY      | Reference to Faculty table       |

### 6. Trip_Group

Stores student group information for trips.

| Column        | Type         | Constraints      | Description                    |
|---------------|--------------|------------------|--------------------------------|
| group_id      | VARCHAR(10)  | PRIMARY KEY      | Unique identifier for the group|
| group_name    | VARCHAR(255) | NOT NULL         | Group name                     |
| student_number| INT          | NOT NULL         | Number of students in the group|
| course_id     | VARCHAR(10)  | NOT NULL         | Reference to Course table      |

### 7. Incharge

Stores information about trip supervisors.

| Column      | Type         | Constraints      | Description                       |
|-------------|--------------|------------------|-----------------------------------|
| incharge_id | VARCHAR(10)  | PRIMARY KEY      | Unique identifier for the incharge|
| first_name  | VARCHAR(255) | NOT NULL         | First name                        |
| last_name   | VARCHAR(255) | NOT NULL         | Last name                         |
| phone_number| INT          | NOT NULL         | Contact phone number              |
| email       | VARCHAR(100) | NOT NULL         | Email address                     |
| faculty_id  | VARCHAR(10)  | FOREIGN KEY      | Reference to Faculty table        |

### 8. Incharge_Group

Links incharges to trip groups.

| Column      | Type         | Constraints      | Description                        |
|-------------|--------------|------------------|------------------------------------|
| incharge_group_id | VARCHAR(10)  | PRIMARY KEY      | Unique identifier                  |
| incharge_id | VARCHAR(10)  | FOREIGN KEY      | Reference to Incharge table        |
| group_id    | VARCHAR(10)  | FOREIGN KEY      | Reference to Trip_Group table      |

### 9. Driver

Stores driver information.

| Column      | Type         | Constraints      | Description                       |
|-------------|--------------|------------------|-----------------------------------|
| driver_id   | VARCHAR(10)  | PRIMARY KEY      | Unique identifier for the driver  |
| firstname   | VARCHAR(255) | NOT NULL         | First name                        |
| lastname    | VARCHAR(255) | NOT NULL         | Last name                         |
| phone_number| VARCHAR(20)  | YES              | Contact phone number              |
| email       | VARCHAR(100) | NOT NULL         | Email address                     |

### 10. Vehicle

Stores vehicle information.

| Column       | Type         | Constraints      | Description                       |
|--------------|--------------|------------------|-----------------------------------|
| vehicle_id   | VARCHAR(10)  | PRIMARY KEY      | Unique identifier for the vehicle |
| make         | VARCHAR(10)  | NOT NULL         | Vehicle manufacturer              |
| model        | VARCHAR(20)  | NOT NULL         | Vehicle model                     |
| year         | DATE         | NOT NULL         | Manufacturing year                |
| capacity     | INT          | NOT NULL         | Passenger capacity                |
| plate_number | VARCHAR(8)   | NOT NULL         | Vehicle registration number       |

### 11. Driver_Vehicle

Links drivers to vehicles for trip assignments.

| Column          | Type         | Constraints      | Description                           |
|-----------------|--------------|------------------|---------------------------------------|
| driver_vehicle_id | VARCHAR(10)  | PRIMARY KEY      | Unique identifier                     |
| driver_id       | VARCHAR(10)  | FOREIGN KEY      | Reference to Driver table            |
| vehicle_id      | VARCHAR(10)  | FOREIGN KEY      | Reference to Vehicle table           |
| assignment_start| DATE         | NOT NULL         | Assignment start date                 |
| assigment_end   | DATE         | NOT NULL         | Assignment end date                   |

## Key Relationships

1. **users to Trip**: Implicit relationship through user roles (lecturers create trips)
2. **Trip to Destination**: Many-to-one (Many trips can go to the same destination)
3. **Trip to Driver_Vehicle**: One-to-one (Each trip has at most one driver-vehicle assignment)
4. **Trip to Incharge_Group**: One-to-one (Each trip has one supervisor group)
5. **Incharge_Group to Incharge**: Many-to-one (Many groups can have the same supervisor)
6. **Incharge_Group to Trip_Group**: Many-to-one (Many supervisor groups can be for the same trip group)
7. **Trip_Group to Course**: Many-to-one (Many groups can be from the same course)
8. **Course to Faculty**: Many-to-one (Many courses can be from the same faculty)
9. **Driver to Driver_Vehicle**: One-to-many (One driver can be assigned to multiple trips over time)
10. **Vehicle to Driver_Vehicle**: One-to-many (One vehicle can be assigned to multiple trips over time)

## Indexes

- users table: username (UNIQUE)
- Trip table: destination_id, incharge_group_id, driver_vehicle_id
- Driver_Vehicle table: driver_id, vehicle_id, assignment_start, assigment_end
