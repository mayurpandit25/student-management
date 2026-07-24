<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>${student != null ? 'Edit' : 'Add'} Student</title>
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
    <h2 style="margin-top:0; color:#2c3e50;">${student != null ? 'Edit' : 'Add New'} Student</h2>

    <form class="student-form" action="students" method="post">
        <% if (request.getAttribute("student") != null) { %>
            <input type="hidden" name="id" value="<%= ((com.school.model.Student) request.getAttribute("student")).getId() %>">
        <% } %>

        <label for="name">Name</label>
        <input type="text" id="name" name="name" required
               value="<%= request.getAttribute("student") != null ? ((com.school.model.Student) request.getAttribute("student")).getName() : "" %>">

        <label for="email">Email</label>
        <input type="email" id="email" name="email" required
               value="<%= request.getAttribute("student") != null ? ((com.school.model.Student) request.getAttribute("student")).getEmail() : "" %>">

        <label for="course">Course</label>
        <input type="text" id="course" name="course" required
               value="<%= request.getAttribute("student") != null ? ((com.school.model.Student) request.getAttribute("student")).getCourse() : "" %>">

        <label for="marks">Marks</label>
        <input type="number" step="0.01" id="marks" name="marks" required
               value="<%= request.getAttribute("student") != null ? ((com.school.model.Student) request.getAttribute("student")).getMarks() : "" %>">

        <button type="submit">Save</button>
    </form>

    <a class="back" href="students">&larr; Back to list</a>
</div>

</body>
</html>
