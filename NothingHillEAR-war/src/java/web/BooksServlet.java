package web;

import dto.BookDTO;
import service.BookServiceLocal;

import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "BooksServlet", urlPatterns = {"/BooksServlet", "/books"})
public class BooksServlet extends HttpServlet {

    @EJB
    private BookServiceLocal bookService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String q = request.getParameter("q");
        String cat = request.getParameter("cat");

        if (q == null) q = "";
        if (cat == null) cat = "All";

        try {
            List<BookDTO> books = bookService.findBooks(q, cat);
            List<String> categories = bookService.getCategoryNames();

            request.setAttribute("books", books);
            request.setAttribute("categories", categories);
            request.setAttribute("q", q);
            request.setAttribute("cat", cat);

            request.getRequestDispatcher("/books.jsp").forward(request, response);
        } catch (Exception ex) {
            log("Error in BooksServlet.doGet: " + ex.getMessage(), ex);
            request.setAttribute("error", "Failed to load books: " + ex.getMessage());
            request.getRequestDispatcher("/books.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
