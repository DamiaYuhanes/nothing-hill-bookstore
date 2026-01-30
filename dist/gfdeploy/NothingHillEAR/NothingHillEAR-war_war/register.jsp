<%-- 
    Document   : register
    Created on : 16 Jan 2026, 9:04:36 am
    Author     : Damia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>NothingHillBookshop - Register</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
        <style>
            .grid2 {
                display:flex;
                gap:18px;
            }
            .grid2 > div {
                flex:1;
            }
            .small-note {
                font-size:12px;
                color:#666;
                margin-top:-18px;
                margin-bottom:18px;
            }
            .ok {
                color:#0a7a2f;
                font-weight:700;
                margin-bottom:14px;
                text-align:center;
            }
        </style>
    </head>
    <body>

        <div class="page">

            <div class="sidebar">
                <div class="logo-box">
                    <img src="<%=request.getContextPath()%>/images/logo.jpg" alt="The Nothing Hill Bookshop">
                </div>

                <div class="menu">
                    <a href="home.jsp"><span>🏠</span> Home</a>
                    <a href="books.jsp"><span>📖</span> Books</a>
                    <a href="about.jsp"><span>ℹ️</span> About</a>
                    <a href="cart.jsp"><span>🛒</span> Cart</a>
                    <a class="active" href="register.jsp"><span>📝</span> Register</a>
                    <a href="login.jsp"><span>🔐</span> Log in</a>
                </div>

            </div>

            <div class="main">
                <div class="center-col">

                    <div class="top-logo">
                        <img src="<%=request.getContextPath()%>/images/logo.jpg" alt="The Nothing Hill Bookshop">
                    </div>

                    <div class="card">
                        <h2>REGISTER</h2>

                        <%
                            String err = (String) request.getAttribute("error");
                            String ok = (String) request.getAttribute("ok");
                            if (err != null) {
                        %>
                        <div class="error"><%= err%></div>
                        <%
                            }
                            if (ok != null) {
                        %>
                        <div class="ok"><%= ok%></div>
                        <%
                            }
                        %>

                        <form action="RegisterServlet" method="post">

                            <div class="grid2">
                                <div>
                                    <div class="field-label">FIRST NAME</div>
                                    <input class="input" type="text" name="firstName" required>
                                </div>
                                <div>
                                    <div class="field-label">LAST NAME</div>
                                    <input class="input" type="text" name="lastName" required>
                                </div>
                            </div>

                            <div class="field-label">USERNAME</div>
                            <input class="input" type="text" name="username" required>
                            <div class="small-note">Tip: you can type the same as your email.</div>

                            <div class="field-label">EMAIL</div>
                            <input class="input" type="email" name="email" required>

                            <div class="field-label">PASSWORD</div>
                            <input class="input" type="password" name="password" required>

                            <div class="field-label">CONFIRM PASSWORD</div>
                            <input class="input" type="password" name="confirmPassword" required>

                            <div class="row">
                                <input type="checkbox" id="agree" name="agree">
                                <label for="agree">I agree to the Terms of Service and Privacy Policy</label>
                            </div>

                            <button class="btn" type="submit">REGISTER</button>
                        </form>

                        <div class="links">
                            <div>Already have an account? <a href="login.jsp">Login here</a></div>
                        </div>
                    </div>

                </div>
            </div>

        </div>

    </body>
</html>
