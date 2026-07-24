<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css">
</head>
<body>

<div class="app-header">
    <h1 class="app-title">
        <svg class="cap-icon" width="42" height="42" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
            <path d="M50 15 L95 33 L50 51 L5 33 Z" fill="#2c3e50"/>
            <path d="M28 40 L28 60 Q50 74 72 60 L72 40 L50 49 Z" fill="#3498db"/>
            <rect x="90" y="33" width="3" height="26" fill="#2c3e50"/>
            <circle cx="91.5" cy="61" r="4" fill="#27ae60"/>
        </svg>
        StudentHub
    </h1>
    <div class="app-underline"></div>
</div>

<div class="card">

    <a class="add-new" href="students?action=new">+ Add New Student</a>

    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Course</th>
            <th>Marks</th>
            <th>Actions</th>
        </tr>
        <c:forEach var="s" items="${students}">
            <tr>
                <td>${s.id}</td>
                <td>${s.name}</td>
                <td>${s.email}</td>
                <td>${s.course}</td>
                <td>${s.marks}</td>
                <td>
                    <a class="button" href="students?action=edit&id=${s.id}">Edit</a>
                    <a class="button delete" href="students?action=delete&id=${s.id}"
                       onclick="return confirm('Delete this student?');">Delete</a>
                </td>
            </tr>
        </c:forEach>
    </table>

    <c:if test="${empty students}">
        <p class="empty">No students yet. Click "Add New Student" to create one.</p>
    </c:if>

</div>

</body>
</html>
