package web;

import service.UserServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ToggleUserStatusServlet", urlPatterns = {"/Admin/ToggleUserStatus"})
public class ToggleUserStatusServlet extends HttpServlet {

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
            String to = request.getParameter("to"); // ACTIVE / INACTIVE

            if (idStr == null || to == null) {
                session.setAttribute("error", "Failed: Missing parameter.");
                response.sendRedirect(request.getContextPath() + "/Admin/ManageUsers");
                return;
            }

            int id = Integer.parseInt(idStr);
            boolean active = "ACTIVE".equalsIgnoreCase(to);

            boolean ok = userService.setActive(id, active);

            if (ok) {
                if (active) session.setAttribute("success", "User activated successfully.");
                else session.setAttribute("success", "User deactivated successfully.");
            } else {
                session.setAttribute("error", "Failed: Unknown user.");
            }

        } catch (Exception ex) {
            session.setAttribute("error", "Failed: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/Admin/ManageUsers");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
