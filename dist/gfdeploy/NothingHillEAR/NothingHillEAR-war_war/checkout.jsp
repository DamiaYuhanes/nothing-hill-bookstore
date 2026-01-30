<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="dto.CartItemDTO"%>

<%
    String ctx      = request.getContextPath();
    String userName = (String) session.getAttribute("userName");

    List<CartItemDTO> items = (List<CartItemDTO>) request.getAttribute("items");
    if (items == null) items = Collections.emptyList();

    double grandTotal = 0.0;
    for (CartItemDTO it : items) {
        grandTotal += it.getPrice() * it.getQuantity();
    }

    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>NothingHillBookshop - Checkout</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">

    <style>
        html, body{
            height:100%;
            margin:0;
            background:#eef2f7;
        }

        .page{
            min-height:100vh;
            display:flex;
            background:#eef2f7;
        }

        .sidebar{
            width:220px;
            flex-shrink:0;
        }

        .main{
            flex:1;
        }

        .center-col{
            width:100%;
            padding:24px 28px;
            box-sizing:border-box;
        }

        /* outer card similar to .home-card */
        .home-card{
            background:#e9eef3;
            border-radius:16px;
            padding:24px 26px 28px 26px;
            box-shadow:0 8px 18px rgba(0,0,0,0.08);
            width:980px;
            max-width:100%;
            margin:0 auto;
        }

        .chk-title{
            font-size:26px;
            font-weight:900;
            color:#2f3f4f;
            letter-spacing:2px;
            margin:4px 0 4px 0;
            text-align:left;
        }
        .chk-sub{
            font-size:15px;
            color:#2f3f4f;
            opacity:0.9;
            margin:2px 0 10px 0;
        }
        .chk-line{
            height:1px;
            background:rgba(47,63,79,0.22);
            margin:14px 0 18px 0;
        }

        /* inner section like .section-wrap */
        .section-wrap{
            background:#ffffff;
            border-radius:14px;
            padding: 22px 22px 24px 22px;
            box-shadow:0 8px 18px rgba(0,0,0,0.08);
        }

        .section-title{
            font-size:18px;
            color:#2f3f4f;
            font-weight:900;
            margin:0 0 10px 0;
        }

        .layout{
            display:grid;
            grid-template-columns: minmax(0,1.5fr) minmax(0,1.1fr);
            gap:20px;
        }

        .card{
            background:#f6f8fb;
            border-radius:10px;
            padding:18px 18px 20px 18px;
            box-shadow:0 4px 12px rgba(0,0,0,0.05);
            border:1px solid rgba(47,63,79,0.08);
            box-sizing:border-box;
            min-width:0;
        }

        .card-title{
            font-weight:900;
            font-size:16px;
            color:#2f3f4f;
            margin:0 0 10px 0;
        }

        .field-label{
            font-size:12px;
            font-weight:800;
            color:#2f3f4f;
            margin-bottom:6px;
            text-transform:uppercase;
            letter-spacing:1px;
        }
        .input{
            width:100%;
            padding:10px 12px;
            border-radius:4px;
            border:1px solid #d5dde5;
            font-size:14px;
            box-sizing:border-box;
            background:#ffffff;
        }
        .row-2{
            display:grid;
            grid-template-columns: minmax(0,1.1fr) minmax(0,1fr);
            gap:14px;
            margin-top:14px;
        }

        .error-box{
            background:#ffe6e6;
            border:1px solid #ffb3b3;
            color:#8b1c1c;
            padding:10px 12px;
            border-radius:6px;
            font-weight:700;
            margin-bottom:12px;
        }

        .summary-list{
            margin-top:4px;
            border-top:1px solid #e2e7ec;
            padding-top:6px;
        }
        .summary-item{
            display:flex;
            justify-content:space-between;
            font-size:14px;
            margin-bottom:4px;
        }
        .summary-item strong{
            font-weight:800;
        }
        .summary-total{
            margin-top:10px;
            border-top:1px solid #e2e7ec;
            padding-top:10px;
            display:flex;
            justify-content:space-between;
            font-weight:900;
            font-size:16px;
            color:#2f3f4f;
        }

        .btn-place{
            width:100%;
            margin-top:16px;
            padding:12px 16px;
            background:#1fa06a;
            color:#ffffff;
            border:none;
            border-radius:6px;
            font-weight:900;
            cursor:pointer;
            letter-spacing:1px;
            box-shadow:0 6px 14px rgba(0,0,0,0.12);
        }
        .btn-place:hover{ filter:brightness(0.97); }

        .footerbar{
            margin-top: 28px;
            background:#2f3f4f;
            color:#fff;
            text-align:center;
            padding: 14px 10px;
            border-radius: 0 0 10px 10px;
            width:980px;
            max-width:100%;
            margin-left:auto;
            margin-right:auto;
        }

        @media (max-width: 900px){
            .layout{
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="page">

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="logo-box">
            <img src="<%=ctx%>/images/logo.jpg" alt="The Nothing Hill Bookshop">
        </div>

        <div class="menu">
            <a href="<%=ctx%>/home.jsp"><span>🏠</span> Home</a>
            <a href="<%=ctx%>/BooksServlet"><span>📖</span> Books</a>
            <a href="<%=ctx%>/about.jsp"><span>ℹ️</span> About</a>
            <a href="<%=ctx%>/CartServlet"><span>🛒</span> Cart</a>
            <a class="active" href="#"><span>📦</span> Checkout</a>

            <% if (userName == null) { %>
                <a href="<%=ctx%>/register.jsp"><span>📝</span> Register</a>
                <a href="<%=ctx%>/login.jsp"><span>🔐</span> Log in</a>
            <% } else { %>
                <a href="<%=ctx%>/OrderHistoryServlet"><span>📦</span> Order History</a>
                <a href="<%=ctx%>/LogoutServlet"><span>🚪</span> Logout</a>
            <% } %>
        </div>
    </div>

    <!-- MAIN -->
    <div class="main">
        <div class="center-col">

            <!-- big wrapper like home-card -->
            <div class="home-card">

                <div class="chk-title">CHECKOUT</div>
                <div class="chk-sub">Review your order and enter your shipping details.</div>
                <div class="chk-line"></div>

                <!-- inner section like section-wrap -->
                <div class="section-wrap">

                    <div class="layout">

                        <!-- SHIPPING INFORMATION -->
                        <div class="card">
                            <h2 class="card-title">Shipping Information</h2>

                            <% if (error != null) { %>
                                <div class="error-box"><%= error %></div>
                            <% } %>

                            <form action="<%=ctx%>/CheckoutServlet" method="post">

                                <div style="margin-bottom:12px;">
                                    <div class="field-label">Address *</div>
                                    <input class="input" type="text" name="address" placeholder="Enter address..." required>
                                </div>

                                <div class="row-2">
                                    <div>
                                        <div class="field-label">City *</div>
                                        <input class="input" type="text" name="city" placeholder="Enter city" required>
                                    </div>
                                    <div>
                                        <div class="field-label">Postal Code *</div>
                                        <input class="input" type="text" name="postalCode" placeholder="Enter postal code" required>
                                    </div>
                                </div>

                                <button class="btn-place" type="submit">PLACE ORDER</button>
                            </form>
                        </div>

                        <!-- ORDER SUMMARY -->
                        <div class="card">
                            <h2 class="card-title">Order Summary</h2>

                            <div class="summary-list">
                                <% for (CartItemDTO it : items) {
                                       double lineTotal = it.getPrice() * it.getQuantity();
                                %>
                                    <div class="summary-item">
                                        <span>
                                            <strong><%= it.getTitle() %></strong>
                                            &nbsp;×&nbsp;<%= it.getQuantity() %>
                                        </span>
                                        <span>
                                            RM<%= String.format("%.2f", lineTotal) %>
                                        </span>
                                    </div>
                                <% } %>
                            </div>

                            <div class="summary-total">
                                <span>Total to pay</span>
                                <span>RM<%= String.format("%.2f", grandTotal) %></span>
                            </div>

                        </div>

                    </div><!-- /layout -->

                </div><!-- /section-wrap -->

            </div><!-- /home-card -->

            <div class="footerbar">
                © 2026 - NothingHillBookshop. Your favorite online bookshop
            </div>

        </div>
    </div>

</div>

</body>
</html>
