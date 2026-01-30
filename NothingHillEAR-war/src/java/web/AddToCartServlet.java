/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package web;

import service.CartService;
import java.io.IOException;
import java.net.URLEncoder;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {

    @EJB
    private CartService cartService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // If user opens servlet directly, go back to catalogue
        response.sendRedirect(request.getContextPath() + "/BooksServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            String msg = URLEncoder.encode("You need to login first before adding items to cart.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=" + msg);
            return;
        }

        String bookIdStr = request.getParameter("bookId");
        if (bookIdStr == null || bookIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/BooksServlet");
            return;
        }

        int bookId = Integer.parseInt(bookIdStr);

        // IMPORTANT: your CartService method name must match
        cartService.addToCart(userId.intValue(), bookId);

        response.sendRedirect(request.getContextPath() + "/CartServlet");
    }
}
