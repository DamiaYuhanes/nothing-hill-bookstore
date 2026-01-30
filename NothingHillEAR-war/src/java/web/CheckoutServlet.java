package web;

import dto.CartItemDTO;
import service.CartService;
import service.OrderServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {

    @EJB
    private CartService cartService;

    @EJB
    private OrderServiceLocal orderService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            String msg = URLEncoder.encode(
                    "You need to login first to checkout.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=" + msg);
            return;
        }

        List<CartItemDTO> items = cartService.getCartItems(userId);
        double total = cartService.getGrandTotal(userId);

        if (items == null || items.isEmpty()) {
            String msg = URLEncoder.encode(
                    "Your cart is empty. Please add items before checking out.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/CartServlet?msg=" + msg);
            return;
        }

        request.setAttribute("items", items);
        request.setAttribute("total", total);
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            String msg = URLEncoder.encode(
                    "You need to login first to place an order.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=" + msg);
            return;
        }

        String address = request.getParameter("address");
        String city    = request.getParameter("city");
        String postal  = request.getParameter("postalCode");

        if (address == null || address.trim().isEmpty()
                || city == null || city.trim().isEmpty()
                || postal == null || postal.trim().isEmpty()) {

            request.setAttribute("error",
                    "Please fill in all required shipping fields.");

            List<CartItemDTO> items = cartService.getCartItems(userId);
            double total = cartService.getGrandTotal(userId);
            request.setAttribute("items", items);
            request.setAttribute("total", total);

            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            return;
        }

        List<CartItemDTO> items = cartService.getCartItems(userId);
        if (items == null || items.isEmpty()) {
            String msg = URLEncoder.encode(
                    "Your cart is empty. Please add items before checking out.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/CartServlet?msg=" + msg);
            return;
        }

        int orderId;
        try {
            orderId = orderService.createOrderFromCart(userId, address, city, postal);
        } catch (Exception ex) {
            request.setAttribute("error",
                    "Sorry, there was a problem placing your order. Please try again.");
            request.setAttribute("items", items);
            request.setAttribute("total", cartService.getGrandTotal(userId));
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            return;
        }

        if (orderId <= 0) {
            request.setAttribute("error",
                    "Unable to create order. Please review your cart items and try again.");
            request.setAttribute("items", items);
            request.setAttribute("total", cartService.getGrandTotal(userId));
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            return;
        }

        cartService.reduceStockForUserCart(userId);
        cartService.clearCart(userId);

        session.setAttribute("success",
                "Order placed successfully! Thank you for your purchase.");
        response.sendRedirect(request.getContextPath() + "/OrderHistoryServlet");
    }
}
