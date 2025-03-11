# Installation Guide - Academic Trip System

This guide provides detailed instructions for installing, configuring, and deploying the Academic Trip System.

## System Requirements

### Server Requirements
- Java JDK 11 or higher
- Apache Tomcat 9.0 or higher
- MySQL 8.0 or higher
- 4GB RAM minimum (8GB recommended)
- 10GB available disk space

### Development Environment Requirements
- Eclipse IDE for Java EE Developers or similar
- Maven 3.6 or higher
- Git

## Installation Steps

### 1. Database Setup

1. Create a new MySQL database:
   ```sql
   CREATE DATABASE academic_trip_system;
   ```

2. Create a dedicated database user:
   ```sql
   CREATE USER 'ats_user'@'localhost' IDENTIFIED BY 'your_strong_password';
   GRANT ALL PRIVILEGES ON academic_trip_system.* TO 'ats_user'@'localhost';
   FLUSH PRIVILEGES;
   ```

3. Import the database schema:
   ```bash
   mysql -u ats_user -p academic_trip_system < database_schema.sql
   ```

4. (Optional) Import sample data:
   ```bash
   mysql -u ats_user -p academic_trip_system < sample_data.sql
   ```

### 2. Application Server Setup

1. Download and install Apache Tomcat from the [official website](https://tomcat.apache.org/download-90.cgi).

2. Configure Tomcat:
   - Edit `conf/tomcat-users.xml` to add administrative users
   - Configure memory settings in `bin/setenv.sh` (Linux/Mac) or `bin/setenv.bat` (Windows):
     ```bash
     export CATALINA_OPTS="-Xms512m -Xmx1024m"
     ```

3. Start Tomcat:
   ```bash
   ./bin/startup.sh  # Linux/Mac
   bin\startup.bat   # Windows
   ```

### 3. Application Deployment

#### Using the WAR file

1. Get the latest release WAR file from the project repository.

2. Deploy the WAR file:
   - Copy the `AcademicTripSystem.war` file to the Tomcat `webapps` directory
   - Tomcat will automatically extract and deploy the application
   - Or deploy through the Tomcat Manager Web Interface (http://localhost:8080/manager)

#### Building from source

1. Clone the repository:
   ```bash
   git clone https://github.com/organization/AcademicTripSystem.git
   ```

2. Navigate to the project directory:
   ```bash
   cd AcademicTripSystem
   ```

3. Configure the database connection:
   - Edit `src/main/resources/database.properties`:
     ```properties
     db.url=jdbc:mysql://localhost:3306/academic_trip_system
     db.username=ats_user
     db.password=your_strong_password
     ```

4. Build the application:
   ```bash
   mvn clean package
   ```

5. Deploy the generated WAR file from the `target` directory to Tomcat.

### 4. Configuration

1. System Configuration:
   - Access the application at `http://localhost:8080/AcademicTripSystem/`
   - Log in with the default administrator account:
     - Username: `admin`
     - Password: `admin123` (change this immediately)

2. Initial Setup:
   - Go to Administration > System Settings
   - Configure email settings for notifications
   - Add faculties and departments
   - Create initial user accounts

## Post-Installation Steps

### Security Hardening

1. Change the default administrator password.

2. Configure SSL/TLS:
   - Generate or obtain SSL certificates
   - Configure Tomcat for HTTPS in `conf/server.xml`
   - Redirect HTTP to HTTPS

3. Set proper file permissions (Linux/Mac):
   ```bash
   chmod -R 750 /path/to/tomcat/webapps/AcademicTripSystem
   ```

### Backup Configuration

1. Database backup:
   - Set up automated MySQL backups:
     ```bash
     mysqldump -u ats_user -p academic_trip_system > backup_$(date +%Y%m%d).sql
     ```

2. Application backup:
   - Back up the configured WAR file and any external configuration files

## Troubleshooting

### Common Issues

1. **Database Connection Errors**
   - Check database credentials in the configuration file
   - Verify that the MySQL server is running
   - Ensure the database user has proper permissions

2. **Application Server Errors**
   - Check Tomcat logs in the `logs` directory
   - Verify JVM memory settings are sufficient
   - Check for conflicting applications on the same port

3. **Permission Issues**
   - Ensure the application has read/write access to its directories
   - Check file ownership and permissions

### Logging

Logs are stored in the following locations:
- Application logs: `[Tomcat]/logs/AcademicTripSystem.log`
- Tomcat logs: `[Tomcat]/logs/catalina.out`

### Getting Help

For additional support:
- Consult the technical documentation
- Submit issues to the project repository
- Contact the development team at dev@academictrip.edu
```

### /home/mwaki/eclipse-workspace2/AcademicTripSystem/docs/technical/development-guide.md

```markdown
// filepath: /home/mwaki/eclipse-workspace2/AcademicTripSystem/docs/technical/development-guide.md
# Development Guide - Academic Trip System

This guide provides information for developers who want to contribute to or extend the Academic Trip System.

## Development Environment Setup

### Prerequisites

1. Java Development Kit (JDK) 11 or higher
2. Eclipse IDE for Java EE Developers or similar (IntelliJ IDEA, NetBeans)
3. Apache Tomcat 9.0 or higher
4. MySQL 8.0 or higher
5. Maven 3.6 or higher
6. Git

### Setting Up the Development Environment

1. Clone the repository:
   ```bash
   git clone https://github.com/organization/AcademicTripSystem.git
   ```

2. Import the project into Eclipse:
   - File > Import > Maven > Existing Maven Projects
   - Browse to the cloned repository directory
   - Select the `pom.xml` file
   - Click Finish

3. Configure the database connection:
   - Edit `src/main/resources/database.properties`:
     ```properties
     db.url=jdbc:mysql://localhost:3306/academic_trip_system
     db.username=ats_user
     db.password=your_password
     ```

4. Configure Tomcat in Eclipse:
   - Window > Preferences > Server > Runtime Environments
   - Add a new Tomcat 9.0 server
   - Point to your Tomcat installation directory

5. Configure the project to use Tomcat:
   - Right-click on the project > Properties
   - Select Targeted Runtimes
   - Check the Tomcat 9.0 server
   - Click Apply and Close

## Project Structure

### Directory Layout

```
AcademicTripSystem/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── academictrip/
│   │   │           ├── controller/  # Servlet classes
│   │   │           ├── dao/         # Data Access Object classes
│   │   │           ├── model/       # Model classes
│   │   │           ├── service/     # Service classes
│   │   │           └── util/        # Utility classes
│   │   ├── resources/               # Configuration files
│   │   └── webapp/                  # Web resources
│   │       ├── WEB-INF/
│   │       ├── css/
│   │       ├── includes/            # JSP includes (headers, footers)
│   │       ├── js/
│   │       ├── lecturer/            # Lecturer module JSP pages
│   │       └── transport/           # Transport module JSP pages
│   └── test/                        # Unit tests
├── docs/                            # Documentation
├── pom.xml                          # Maven configuration
└── README.md                        # Project overview
