package web;

import dto.UserDTO;
import service.UserServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ToggleUserActiveServlet", urlPatterns = {"/Admin/ToggleUserActive"})
public class ToggleUserActiveServlet extends HttpServlet {

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
            String activeStr = request.getParameter("active");

            if (idStr == null || idStr.trim().isEmpty() ||
                activeStr == null || activeStr.trim().isEmpty()) {
                session.setAttribute("error", "Missing request parameter.");
                response.sendRedirect(request.getContextPath() + "/Admin/ManageUsersServlet");
                return;
            }

            if (!"0".equals(activeStr) && !"1".equals(activeStr)) {
                session.setAttribute("error", "Invalid request parameter.");
                response.sendRedirect(request.getContextPath() + "/Admin/ManageUsersServlet");
                return;
            }

            int id;
            try {
                id = Integer.parseInt(idStr.trim());
            } catch (NumberFormatException nfe) {
                session.setAttribute("error", "Invalid user id.");
                response.sendRedirect(request.getContextPath() + "/Admin/ManageUsersServlet");
                return;
            }

            // Optional: prevent admin from deactivating their own account
            UserDTO current = (UserDTO) session.getAttribute("user");
            if (current != null && current.getId() == id) {
                session.setAttribute("error", "You cannot deactivate your own account.");
                response.sendRedirect(request.getContextPath() + "/Admin/ManageUsersServlet");
                return;
            }

            boolean active = "1".equals(activeStr);

            boolean ok = userService.setActive(id, active);

            if (ok) {
                session.setAttribute("success", active
                        ? "User activated successfully."
                        : "User deactivated successfully.");
            } else {
                session.setAttribute("error", "Failed: Unknown user.");
            }

        } catch (Exception ex) {
            String msg = ex.getMessage();
            if (msg == null || msg.trim().isEmpty()) {
                msg = "Unexpected error.";
            }
            session.setAttribute("error", "Failed: " + msg);
        }

        response.sendRedirect(request.getContextPath() + "/Admin/ManageUsersServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
