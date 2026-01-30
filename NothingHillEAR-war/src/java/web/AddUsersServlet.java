package web;

import service.UserServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AddUsersServlet", urlPatterns = {"/Admin/AddUser"})
public class AddUsersServlet extends HttpServlet {

    @EJB
    private UserServiceLocal userService;

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession s = request.getSession(false);
        if (s == null) return false;
        Object role = s.getAttribute("userRole");
        return role != null && "ADMIN".equalsIgnoreCase(role.toString());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher("/addUser.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        HttpSession session = request.getSession(true);

        try {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            boolean active = request.getParameter("active") != null;

            boolean ok = userService.createUser(name, email, password, role, active);

            if (ok) session.setAttribute("success", "User created.");
            else session.setAttribute("error", "Failed to create user (email may already exist).");

            response.sendRedirect(request.getContextPath() + "/Admin/ManageUsers");

        } catch (Exception ex) {
            session.setAttribute("error", "Failed: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/Admin/ManageUsers");
        }
    }
}
