package web;

import dto.UserDTO;
import service.UserServiceLocal;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @EJB
    private UserServiceLocal userService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        UserDTO u = userService.login(email, password);

        if (u == null) {
            request.setAttribute("error", "Invalid email/password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Block login if INACTIVE
        if (u.getStatus() != null && "INACTIVE".equalsIgnoreCase(u.getStatus())) {
            request.setAttribute("error", "Login failed: Email has been deactivated.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        // These attributes drive cart and UI
        session.setAttribute("userId", u.getId());  // used by CartServlet/CartService
        session.setAttribute(
                "userName",
                (u.getName() != null && !u.getName().trim().isEmpty())
                        ? u.getName()
                        : u.getEmail()
        );
        session.setAttribute("userRole", u.getRole());

        if ("ADMIN".equalsIgnoreCase(u.getRole())) {
            response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet");
        } else {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
        }
    }
}
