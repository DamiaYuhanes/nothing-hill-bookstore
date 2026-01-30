package web;

import service.UserServiceLocal;
import service.BookServiceLocal;
import service.OrderServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {

    @EJB
    private UserServiceLocal userService;

    @EJB
    private BookServiceLocal bookService;

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

        // total users
        long totalUsers = userService.countUsers();          // you implement this

        // total products
        long totalProducts = bookService.listAllBooks().size();

        // total orders
        long totalOrders = orderService.getAdminOrders("ALL").size();

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);

        request.getRequestDispatcher("/adminDashboard.jsp")
               .forward(request, response);
    }
}
