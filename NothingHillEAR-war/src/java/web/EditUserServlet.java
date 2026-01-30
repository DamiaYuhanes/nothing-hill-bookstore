package web;

import dto.UserDTO;
import service.UserServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "EditUserServlet", urlPatterns = {"/Admin/EditUser"})
public class EditUserServlet extends HttpServlet {

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

        HttpSession session = request.getSession(true);

        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                session.setAttribute("error", "Missing user id.");
                response.sendRedirect(request.getContextPath() + "/Admin/ManageUsers");
                return;
            }

            int id = Integer.parseInt(idStr);
            UserDTO u = userService.findUserById(id);

            if (u == null) {
                session.setAttribute("error", "User not found.");
                response.sendRedirect(request.getContextPath() + "/Admin/ManageUsers");
                return;
            }

            request.setAttribute("user", u);
            request.getRequestDispatcher("/editUser.jsp").forward(request, response);

        } catch (Exception ex) {
            session.setAttribute("error", "Invalid request: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/Admin/ManageUsers");
        }
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
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password"); // optional
            String role = request.getParameter("role");
            boolean active = request.getParameter("active") != null;

            String passwordOrNull = (password == null || password.trim().isEmpty())
                    ? null
                    : password.trim();

            boolean ok = userService.updateUser(id, name, email, passwordOrNull, role, active);

            if (ok) session.setAttribute("success", "User updated.");
            else session.setAttribute("error", "Failed to update user (email may already exist).");

        } catch (Exception ex) {
            session.setAttribute("error", "Failed: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/Admin/ManageUsers");
    }
}
