package com.school.servlet;

import com.school.dao.StudentDAO;
import com.school.model.Student;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Single front-controller-style servlet for all student CRUD actions.
 * URL pattern: /students
 *
 *   GET  /students              -> list all students
 *   GET  /students?action=new   -> show blank add form
 *   GET  /students?action=edit&id=5   -> show edit form pre-filled
 *   POST /students?action=save  -> insert or update (id present = update)
 *   GET  /students?action=delete&id=5 -> delete and redirect back to list
 */
@WebServlet("/students")
public class StudentServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "new":
                    showForm(req, resp, null);
                    break;
                case "edit":
                    int editId = Integer.parseInt(req.getParameter("id"));
                    Student existing = studentDAO.getStudentById(editId);
                    showForm(req, resp, existing);
                    break;
                case "delete":
                    int deleteId = Integer.parseInt(req.getParameter("id"));
                    studentDAO.deleteStudent(deleteId);
                    resp.sendRedirect("students");
                    break;
                case "list":
                default:
                    listStudents(req, resp);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String course = req.getParameter("course");
        double marks = parseDoubleSafe(req.getParameter("marks"));
        String idParam = req.getParameter("id");

        Student s = new Student();
        s.setName(name);
        s.setEmail(email);
        s.setCourse(course);
        s.setMarks(marks);

        try {
            if (idParam != null && !idParam.isEmpty()) {
                s.setId(Integer.parseInt(idParam));
                studentDAO.updateStudent(s);
            } else {
                studentDAO.addStudent(s);
            }
            resp.sendRedirect("students");
        } catch (SQLException e) {
            throw new ServletException("Database error while saving student", e);
        }
    }

    private void listStudents(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {

        List<Student> students = studentDAO.getAllStudents();
        req.setAttribute("students", students);
        RequestDispatcher rd = req.getRequestDispatcher("/WEB-INF/views/list.jsp");
        rd.forward(req, resp);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse resp, Student student)
            throws ServletException, IOException {

        req.setAttribute("student", student);
        RequestDispatcher rd = req.getRequestDispatcher("/WEB-INF/views/form.jsp");
        rd.forward(req, resp);
    }

    private double parseDoubleSafe(String value) {
        try {
            return Double.parseDouble(value);
        } catch (Exception e) {
            return 0.0;
        }
    }
}
