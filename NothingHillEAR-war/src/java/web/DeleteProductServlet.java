package web;

import service.BookServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "DeleteProductServlet", urlPatterns = {"/Admin/DeleteProduct"})
public class DeleteProductServlet extends HttpServlet {

    @EJB
    private BookServiceLocal bookService;

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        Object role = session.getAttribute("userRole");
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
                session.setAttribute("error", "Missing product id.");
                response.sendRedirect(request.getContextPath() + "/Admin/ManageProducts");
                return;
            }

            int id = Integer.parseInt(idStr);

            boolean ok = bookService.deleteProduct(id);
            if (ok) session.setAttribute("success", "Product deleted.");
            else session.setAttribute("error", "Product not found.");

        } catch (Exception ex) {
            session.setAttribute("error", "Failed to delete: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/Admin/ManageProducts");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
