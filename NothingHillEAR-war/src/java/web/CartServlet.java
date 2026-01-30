package web;

import dto.CartItemDTO;
import service.CartService;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    @EJB
    private CartService cartService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            String msg = URLEncoder.encode("You need to login first to view your cart.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=" + msg);
            return;
        }

        List<CartItemDTO> items = cartService.getCartItems(userId.intValue());
        double total = cartService.getGrandTotal(userId.intValue());

        request.setAttribute("items", items);
        request.setAttribute("total", total);

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            String msg = URLEncoder.encode("You need to login first to update your cart.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=" + msg);
            return;
        }

        String action = request.getParameter("action");

        if (action != null) {
            if ("clear".equalsIgnoreCase(action)) {
                cartService.clearCart(userId.intValue());
            } else {
                String bookIdStr = request.getParameter("bookId");
                if (bookIdStr != null) {
                    int bookId = Integer.parseInt(bookIdStr);

                    if ("update".equalsIgnoreCase(action)) {
                        String qtyStr = request.getParameter("qty");
                        int qty = 1;
                        try { qty = Integer.parseInt(qtyStr); } catch (Exception ignore) {}
                        if (qty < 1) qty = 1;
                        cartService.updateQuantity(userId.intValue(), bookId, qty);

                    } else if ("remove".equalsIgnoreCase(action)) {
                        cartService.removeItem(userId.intValue(), bookId);
                    }
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/CartServlet");
    }
}
