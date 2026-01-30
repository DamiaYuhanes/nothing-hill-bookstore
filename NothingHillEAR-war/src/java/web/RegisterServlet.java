/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package web;

import util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final String CHECK_EMAIL_SQL =
        "SELECT id FROM users WHERE email=?";

    private static final String INSERT_SQL =
        "INSERT INTO users (name, email, password, role, status) VALUES (?, ?, ?, 'CUSTOMER', 'ACTIVE')";

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String username = request.getParameter("username"); // not stored for now
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");
        String agree = request.getParameter("agree");

        // 1) Check empty
        if (isEmpty(firstName) || isEmpty(lastName) || isEmpty(username)
                || isEmpty(email) || isEmpty(password) || isEmpty(confirm)) {
            request.setAttribute("error", "Please fill in all fields.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 2) Password match
        if (!password.equals(confirm)) {
            request.setAttribute("error", "Password and Confirm Password must match.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 3) Must agree
        if (agree == null) {
            request.setAttribute("error", "You must agree to the terms and conditions.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        String fullName = firstName.trim() + " " + lastName.trim();

        try (Connection conn = DBConnection.getConnection()) {

            // 4) Check email already exists
            try (PreparedStatement ps = conn.prepareStatement(CHECK_EMAIL_SQL)) {
                ps.setString(1, email.trim());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        request.setAttribute("error", "Email already registered. Please login.");
                        request.getRequestDispatcher("register.jsp").forward(request, response);
                        return;
                    }
                }
            }

            // 5) Insert
            try (PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
                ps.setString(1, fullName);
                ps.setString(2, email.trim());
                ps.setString(3, password);
                ps.executeUpdate();
            }

            request.setAttribute("ok", "Register success! Please login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
