package web;

import dto.BookDTO;
import service.BookServiceLocal;

import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ManageProductsServlet", urlPatterns = {"/Admin/ManageProducts"})
public class ManageProductsServlet extends HttpServlet {

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

        List<BookDTO> books = bookService.listAllBooks();
        request.setAttribute("books", books);

        request.getRequestDispatcher("/manageProducts.jsp").forward(request, response);
    }
}
