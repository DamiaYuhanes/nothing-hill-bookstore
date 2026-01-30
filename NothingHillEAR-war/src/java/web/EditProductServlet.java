package web;

import dto.BookDTO;
import service.BookServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "EditProductServlet", urlPatterns = {"/Admin/EditProduct"})
public class EditProductServlet extends HttpServlet {

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

        HttpSession session = request.getSession(false);

        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                session.setAttribute("error", "Missing product id.");
                response.sendRedirect(request.getContextPath() + "/Admin/ManageProducts");
                return;
            }

            int id = Integer.parseInt(idStr);
            BookDTO dto = bookService.findBookDTOById(id);

            if (dto == null) {
                session.setAttribute("error", "Product not found.");
                response.sendRedirect(request.getContextPath() + "/Admin/ManageProducts");
                return;
            }

            request.setAttribute("book", dto);
            request.getRequestDispatcher("/editProduct.jsp").forward(request, response);

        } catch (Exception ex) {
            session.setAttribute("error", "Invalid request: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/Admin/ManageProducts");
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

            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            String image = request.getParameter("image");
            boolean active = request.getParameter("active") != null;

            BigDecimal price = new BigDecimal(
                    (priceStr == null || priceStr.trim().isEmpty()) ? "0.00" : priceStr.trim()
            );
            int stock = (stockStr == null || stockStr.trim().isEmpty()) ? 0 : Integer.parseInt(stockStr.trim());

            boolean ok = bookService.updateProduct(
                    id,
                    title,
                    author,
                    category,
                    description,
                    price,
                    stock,
                    image,
                    active
            );

            if (ok) session.setAttribute("success", "Product updated.");
            else session.setAttribute("error", "Product not found.");

        } catch (Exception ex) {
            session.setAttribute("error", "Failed to update: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/Admin/ManageProducts");
    }
}
