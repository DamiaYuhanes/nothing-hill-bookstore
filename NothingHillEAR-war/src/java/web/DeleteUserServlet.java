package web;

import service.UserServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "DeleteUserServlet", urlPatterns = {"/DeleteUserServlet"})
public class DeleteUserServlet extends HttpServlet {

    @EJB
    private UserServiceLocal userService;

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession s = request.getSession(false);
        if (s == null) return false;
        Object role = s.getAttribute("userRole");
        return role != null && "ADMIN".equalsIgnoreCase(role.toString());
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
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                session.setAttribute("error", "Missing user id.");
                response.sendRedirect(request.getContextPath() + "/Admin/ManageUsers");
                return;
            }

            int id = Integer.parseInt(idStr.trim());

            boolean ok = userService.deleteUser(id);   // <-- implement this in your EJB to delete from `users`

            if (ok) {
                session.setAttribute("success", "User deleted successfully.");
            } else {
                session.setAttribute("error", "Failed: Unknown user.");
            }

        } catch (Exception ex) {
            session.setAttribute("error", "Failed: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/Admin/ManageUsers");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Allow GET if you ever use a link instead of a form
        doPost(request, response);
    }
}
