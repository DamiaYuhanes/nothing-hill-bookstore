<%-- login.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // If already logged in, go to correct page (admin -> dashboard, customer -> home)
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");

    if (userName != null) {
        if (userRole != null && "ADMIN".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet");
        } else {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
        }
        return;
    }
%>
<%
    String msg = request.getParameter("msg");
    if (msg != null && !msg.trim().isEmpty()) {
%>
    <div class="error"><%= msg %></div>
<%
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>NothingHillBookshop - Login</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>

<div class="page">

    <!-- LEFT SIDEBAR -->
    <div class="sidebar">
        <div class="logo-box">
            <img src="<%=request.getContextPath()%>/images/logo.jpg" alt="The Nothing Hill Bookshop">
        </div>

        <div class="menu">
            <a href="<%=request.getContextPath()%>/home.jsp"><span>🏠</span> Home</a>

            <!-- IMPORTANT: Books should go through BooksServlet if you integrated DB -->
            <a href="<%=request.getContextPath()%>/BooksServlet"><span>📖</span> Books</a>

            <a href="<%=request.getContextPath()%>/about.jsp"><span>ℹ️</span> About</a>
            <a href="<%=request.getContextPath()%>/CartServlet"><span>🛒</span> Cart</a>
            <a href="<%=request.getContextPath()%>/register.jsp"><span>📝</span> Register</a>

            <a class="active" href="<%=request.getContextPath()%>/login.jsp"><span>🔐</span> Log in</a>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main">
        <div class="center-col">

            <div class="top-logo">
                <img src="<%=request.getContextPath()%>/images/logo.jpg" alt="The Nothing Hill Bookshop">
            </div>

            <div class="card">

                <h2>LOGIN</h2>

                <%
                    String err = (String) request.getAttribute("error");
                    if (err != null) {
                %>
                    <div class="error"><%= err %></div>
                <%
                    }
                %>

                <!-- MUST match servlet mapping exactly: /LoginServlet (capital L, S) -->
                <form action="<%=request.getContextPath()%>/LoginServlet" method="post">
                    <div class="field-label">EMAIL</div>
                    <input class="input" type="text" name="email" required>

                    <div class="field-label">PASSWORD</div>
                    <input class="input" type="password" name="password" required>

                    <div class="row">
                        <input type="checkbox" id="remember" name="remember">
                        <label for="remember">Remember me</label>
                    </div>

                    <button class="btn" type="submit">LOG IN</button>
                </form>

                <div class="links">
                    <div>Don't have an account? <a href="<%=request.getContextPath()%>/register.jsp">Register here</a></div>
                    <div style="margin-top:6px;"><a href="#">Forgot password</a></div>
                </div>

            </div>

        </div>
    </div>

</div>

</body>
</html>
