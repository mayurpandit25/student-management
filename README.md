# Student Management System

## Prerequisites 

1. **Java JDK 21**
   ```bash
   sudo apt update
   sudo apt install -y openjdk-21-jdk
   java --version
   ```

2. **Maven**
   ```bash
   sudo apt install -y maven
   mvn -version
   ```

3. **MySQL Server**
   ```bash
   sudo apt install -y mysql-server
   sudo systemctl start mysql
   sudo systemctl enable mysql
   ```

4. **Download Apache Tomcat 10 or 11**

## Step 1 — Create the database

```bash
mysql -u root -p < sql/schema.sql
```

This creates database `school_db` with a `students` table.

## Step 2 — Configure the app's DB connection

Edit `src/main/resources/db.properties`:

```properties
db.url=jdbc:mysql://localhost:3306/school_db?useSSL=false&serverTimezone=UTC
db.user=root
db.password=YOUR_MYSQL_PASSWORD
```

## Step 3 — Build the WAR with Maven

From the project root (where `pom.xml` lives):

```bash
mvn clean package
```

Maven will compile everything and produce:

```
target/student-management.war
```

That single file is the whole application.

## Step 4 — Deploy to Tomcat

Copy the WAR into Tomcat's `webapps` folder, then start Tomcat:

```bash
sudo cp target/student-management.war /opt/tomcat/webapps/student.war
sudo /opt/tomcat/bin/startup.sh
```

## Step 5 — Open it in a browser

```
http://<server-ip>:8080/student/
```

## Troubleshooting

- **404 at the URL**: check `sudo /opt/tomcat/bin/catalina.sh version` for
  the port Tomcat is on, and confirm the WAR unpacked into
  `/opt/tomcat/webapps/student-management/`.
- **500 error / stack trace mentioning `com.mysql.cj.jdbc.Driver`**: make
  sure `mysql-connector-j` was pulled by Maven (`mvn dependency:tree`) and
  is present in `WEB-INF/lib/` inside the WAR.
- **Access denied for user**: fix `db.user` / `db.password` in
  `db.properties`, then `mvn clean package` again (properties are baked
  into the WAR at build time).
