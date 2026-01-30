package web;

import service.OrderServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "CancelOrderServlet", urlPatterns = {"/CancelOrderServlet"})
public class CancelOrderServlet extends HttpServlet {

    @EJB
    private OrderServiceLocal orderService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);

        String idStr = request.getParameter("orderId");
        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("success", "Invalid order.");
            response.sendRedirect(request.getContextPath() + "/OrderHistoryServlet");
            return;
        }

        try {
            int orderId = Integer.parseInt(idStr.trim());

            // Optional: check that this order belongs to the logged-in user

            boolean ok = orderService.cancelOrder(orderId);

            if (ok) {
                session.setAttribute("success", "Order has been cancelled.");
            } else {
                session.setAttribute("success", "Unable to cancel order.");
            }

        } catch (NumberFormatException ex) {
            session.setAttribute("success", "Invalid order id.");
        }

        response.sendRedirect(request.getContextPath() + "/OrderHistoryServlet");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
