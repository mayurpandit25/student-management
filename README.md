# Student Management System — Monolithic WAR Demo

A classic, single-deployable-unit Java web app for teaching the traditional
(pre-microservices) deployment model:

```
Browser  -->  Tomcat  -->  Servlet (StudentServlet)  -->  DAO (JDBC)  -->  MySQL
                            |
                            v
                          JSP views (list.jsp / form.jsp)
```

Everything — UI, business logic, DB access — is packaged into **one WAR
file** and dropped into Tomcat. This is deliberately the opposite of
microservices: one codebase, one build, one deployable artifact, one server
process.

## Project layout

```
student-management/
├── pom.xml                          # Maven build -> produces student-management.war
├── sql/schema.sql                   # Creates the MySQL database + table + sample rows
├── src/main/java/com/school/
│   ├── model/Student.java           # Plain data object
│   ├── dao/StudentDAO.java          # All JDBC/SQL code
│   ├── util/DBUtil.java             # Opens JDBC connections using db.properties
│   └── servlet/StudentServlet.java  # Handles list / add / edit / delete
├── src/main/resources/db.properties # MySQL connection settings (EDIT THIS)
└── src/main/webapp/
    ├── index.jsp                    # Redirects to /students
    └── WEB-INF/
        ├── web.xml
        └── views/list.jsp, form.jsp
```

## Prerequisites (on the Linux machine)

1. **Java JDK 21**
   ```bash
   sudo apt update
   sudo apt install -y openjdk-21-jdk
   java -version
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

4. **Apache Tomcat 10 or 11** (download & extract manually — apt versions vary)

   This app is built against the **Jakarta EE** (`jakarta.servlet.*`) namespace,
   so it requires **Tomcat 10.1.x or Tomcat 11.0.x** — it will NOT deploy on
   Tomcat 9 or earlier (those use the older `javax.servlet` namespace).

   Tomcat 10.1.x:
   ```bash
   cd /opt
   sudo wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.34/bin/apache-tomcat-10.1.34.tar.gz
   sudo tar xzf apache-tomcat-10.1.34.tar.gz
   sudo mv apache-tomcat-10.1.34 tomcat
   sudo chmod +x /opt/tomcat/bin/*.sh
   ```
   (Check https://tomcat.apache.org/download-10.cgi for the latest 10.1.x link.)

   Tomcat 11.0.x:
   ```bash
   cd /opt
   sudo wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.6/bin/apache-tomcat-11.0.6.tar.gz
   sudo tar xzf apache-tomcat-11.0.6.tar.gz
   sudo mv apache-tomcat-11.0.6 tomcat
   sudo chmod +x /opt/tomcat/bin/*.sh
   ```
   (Check https://tomcat.apache.org/download-11.cgi for the latest 11.x link.)

   Either version works with this WAR unchanged — pick whichever matches your
   environment.

## Step 1 — Create the database

```bash
mysql -u root -p < sql/schema.sql
```

This creates database `school_db` with a `students` table and 3 sample rows.

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
sudo cp target/student-management.war /opt/tomcat/webapps/
sudo /opt/tomcat/bin/startup.sh
```

Tomcat auto-detects and unpacks new WAR files in `webapps/`. Watch the log:

```bash
tail -f /opt/tomcat/logs/catalina.out
```

## Step 5 — Open it in a browser

```
http://<server-ip>:8080/student-management/
```

You should see the student list, and can Add / Edit / Delete rows — each
action goes through the servlet, into the DAO, out over JDBC to MySQL.

## Redeploying after a code change

```bash
sudo /opt/tomcat/bin/shutdown.sh
mvn clean package
sudo cp target/student-management.war /opt/tomcat/webapps/
sudo /opt/tomcat/bin/startup.sh
```

(Tomcat can hot-deploy WAR replacement while running, but a clean
shutdown/startup avoids classloader-related confusion in a classroom
setting.)

## Teaching notes — what to point out to students

- **One artifact, one deployment**: the WAR contains the compiled classes,
  JSPs, and libraries (JSTL, MySQL driver) all together. Compare this later
  to a microservices setup where each piece would be its own container/image.
- **DBUtil / StudentDAO separation**: shows why you don't hardcode SQL inside
  servlets — a natural lead-in to explaining layered architecture, and later,
  splitting a monolith into services along these same seams.
- **No connection pool**: intentionally simple (`DriverManager.getConnection`
  per request) so the JDBC mechanics are visible. Good follow-up exercise:
  have students swap in a `DataSource`/connection pool and measure the
  difference.
- **Single point of scaling/failure**: if this Tomcat instance goes down, the
  whole app is down — a good motivator for the microservices discussion that
  follows.

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
