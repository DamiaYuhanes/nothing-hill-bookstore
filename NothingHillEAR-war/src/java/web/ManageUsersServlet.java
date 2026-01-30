package web;

import dto.UserDTO;
import service.UserServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(
        name = "ManageUsersServlet",
        urlPatterns = {
                "/Admin/ManageUsers",
                "/Admin/ManageUsersServlet",
                "/ManageUsersServlet"
        }
)
public class ManageUsersServlet extends HttpServlet {

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

        List<UserDTO> users;
        try {
            users = userService.listAllUsers();
        } catch (Exception ex) {
            // If list fails, show an empty list but surface the error message
            HttpSession session = request.getSession(true);
            String msg = ex.getMessage();
            if (msg == null || msg.trim().isEmpty()) {
                msg = "Unexpected error.";
            }
            session.setAttribute("error", "Failed: " + msg);
            users = java.util.Collections.emptyList();
        }

        request.setAttribute("users", users);
        request.getRequestDispatcher("/manageUsers.jsp").forward(request, response);
    }
}
