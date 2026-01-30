package web;

import dto.BookDTO;
import service.BookServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "BookDetailsServlet", urlPatterns = {"/BookDetailsServlet"})
public class BookDetailsServlet extends HttpServlet {

    @EJB
    private BookServiceLocal bookService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/BooksServlet");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            BookDTO book = bookService.findBookDTOById(id);

            if (book == null) {
                request.getSession(true).setAttribute("success", "Book not found.");
                response.sendRedirect(request.getContextPath() + "/BooksServlet");
                return;
            }

            request.setAttribute("book", book);
            request.getRequestDispatcher("/bookDetails.jsp").forward(request, response);

        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/BooksServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
