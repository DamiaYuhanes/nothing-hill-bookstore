package web;

import dto.OrderSummaryDTO;
import service.OrderServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet("/OrderHistoryServlet")
public class OrderHistoryServlet extends HttpServlet {

    @EJB
    private OrderServiceLocal orderService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            String msg = URLEncoder.encode(
                    "You need to login first to view order history.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=" + msg);
            return;
        }

        List<OrderSummaryDTO> orders = orderService.getOrdersForUser(userId);
        request.setAttribute("orders", orders);

        request.getRequestDispatcher("/orderHistory.jsp").forward(request, response);
    }
}
