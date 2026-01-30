package web;

import service.BookServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "AddProductServlet", urlPatterns = {"/AddProductServlet"})
public class AddProductServlet extends HttpServlet {

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

        request.getRequestDispatcher("/addProduct.jsp").forward(request, response);
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

            bookService.addProduct(title, author, category, description, price, stock, image, active);

            session.setAttribute("success", "Product added successfully.");
            response.sendRedirect(request.getContextPath() + "/Admin/ManageProducts");

        } catch (Exception ex) {
            session.setAttribute("error", "Failed to add product: " + ex.getMessage());
            request.getRequestDispatcher("/addProduct.jsp").forward(request, response);
        }
    }
}
