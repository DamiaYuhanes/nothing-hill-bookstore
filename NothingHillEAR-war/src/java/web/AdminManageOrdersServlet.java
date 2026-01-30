package web.admin;

import dto.AdminOrderRowDTO;
import service.OrderServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet("/Admin/ManageOrders")
public class AdminManageOrdersServlet extends HttpServlet {

    @EJB
    private OrderServiceLocal orderService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (session == null) ? null : (String) session.getAttribute("userRole");
        if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String status = request.getParameter("status");
        if (status == null || status.trim().isEmpty()) {
            status = "ALL";
        }

        List<AdminOrderRowDTO> orders = orderService.getAdminOrders(status);

        request.setAttribute("orders", orders);
        request.setAttribute("statusFilter", status);

        String success = (session != null) ? (String) session.getAttribute("success") : null;
        String error   = (session != null) ? (String) session.getAttribute("error")   : null;
        if (session != null) {
            session.removeAttribute("success");
            session.removeAttribute("error");
        }
        request.setAttribute("success", success);
        request.setAttribute("error", error);

        request.getRequestDispatcher("/admin_manage_orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (session == null) ? null : (String) session.getAttribute("userRole");
        if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action      = request.getParameter("action");      // "save" or "cancel"
        String orderIdStr  = request.getParameter("orderId");
        String status      = request.getParameter("statusSelect");
        String currentFilt = request.getParameter("currentFilter");
        if (currentFilt == null || currentFilt.trim().isEmpty()) currentFilt = "ALL";

        boolean ok = false;
        try {
            int orderId = Integer.parseInt(orderIdStr);

            if ("save".equalsIgnoreCase(action)) {
                ok = orderService.updateOrderStatus(orderId, status);
                session.setAttribute(ok ? "success" : "error",
                        ok ? "Order status updated." : "Unable to update order status.");
            } else if ("cancel".equalsIgnoreCase(action)) {
                ok = orderService.cancelOrder(orderId);
                session.setAttribute(ok ? "success" : "error",
                        ok ? "Order cancelled." : "Unable to cancel order.");
            } else {
                session.setAttribute("error", "Unknown action.");
            }
        } catch (Exception ex) {
            session.setAttribute("error", "Failed to update order. Please try again.");
        }

        response.sendRedirect(request.getContextPath()
                + "/Admin/ManageOrders?status=" + URLEncoder.encode(currentFilt, "UTF-8"));
    }
}
