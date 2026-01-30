<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="dto.OrderSummaryDTO"%>
<%@page import="dto.OrderItemLine"%>

<%
    String ctx      = request.getContextPath();
    String userName = (String) session.getAttribute("userName");

    @SuppressWarnings("unchecked")
    List<OrderSummaryDTO> orders =
            (List<OrderSummaryDTO>) request.getAttribute("orders");
    if (orders == null) {
        orders = Collections.emptyList();
    }

    String flash = (String) session.getAttribute("success");
    if (flash != null) {
        session.removeAttribute("success");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>NothingHillBookshop - Order History</title>
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

        .wrap{
            width:100%;
            max-width:980px;
            margin:0 auto;
        }

        .title{
            font-size:26px;
            font-weight:900;
            color:#2f3f4f;
            letter-spacing:2px;
            margin:4px 0 4px 0;
        }
        .title-line{
            height:2px;
            background:#2f3f4f;
            opacity:0.6;
            margin-bottom:18px;
        }

        .order-card{
            background:#ffffff;
            border-radius:10px;
            padding:18px 18px 16px 18px;
            box-shadow:0 8px 18px rgba(0,0,0,0.08);
            border:1px solid rgba(47,63,79,0.12);
            margin-bottom:18px;
        }

        .empty-card{
            background:#ffffff;
            border-radius:10px;
            padding:22px 22px 20px 22px;
            box-shadow:0 8px 18px rgba(0,0,0,0.08);
            border:1px solid rgba(47,63,79,0.12);
            text-align:center;
            font-size:15px;
            color:#2f3f4f;
        }

        .order-header{
            display:flex;
            justify-content:space-between;
            align-items:center;
            gap:12px;
            font-size:14px;
        }
        .order-header-main{
            font-weight:900;
            color:#2f3f4f;
        }
        .order-header-sub{
            margin-top:4px;
            color:#2f3f4f;
            opacity:0.85;
        }

        .status-badges{
            display:flex;
            flex-direction:column;
            gap:6px;
        }
        .badge{
            padding:4px 10px;
            border-radius:4px;
            font-size:12px;
            font-weight:900;
            border:2px solid;
            text-align:center;
            min-width:90px;
        }

        .badge-delivered{
            border-color:#16a34a;
            color:#166534;
            background:#dcfce7;
        }
        .badge-shipping{
            border-color:#facc15;
            color:#854d0e;
            background:#fef9c3;
        }
        .badge-processing{
            border-color:#2563eb;
            color:#1d4ed8;
            background:#dbeafe;
        }
        .badge-pending{
            border-color:#9ca3af;
            color:#4b5563;
            background:#e5e7eb;
        }
        .badge-cancel{
            border-color:#dc2626;
            color:#b91c1c;
            background:#fee2e2;
        }

        .section-label{
            margin-top:14px;
            font-weight:900;
            color:#2f3f4f;
            font-size:15px;
        }
        .section-line{
            height:1px;
            background:rgba(47,63,79,0.18);
            margin:4px 0 10px 0;
        }

        .item-row{
            display:flex;
            gap:16px;
        }
        .thumb{
            width:72px;
            height:108px;
            background:#e9eef3;
            border-radius:4px;
            border:1px solid rgba(47,63,79,0.12);
            overflow:hidden;
            flex-shrink:0;
        }
        .thumb img{
            width:100%;
            height:100%;
            object-fit:cover;
            display:block;
        }
        .item-info{
            flex:1;
        }
        .item-title{
            font-weight:900;
            font-size:18px;
            color:#2f3f4f;
        }
        .item-price{
            margin-top:4px;
            font-size:14px;
            color:#2f3f4f;
        }

        .item-qtytotal{
            text-align:right;
            font-size:14px;
            font-weight:900;
            color:#2f3f4f;
        }

        .order-footer{
            margin-top:12px;
            display:flex;
            justify-content:space-between;
            align-items:center;
            gap:10px;
        }
        .ship-text{
            font-size:14px;
            color:#2f3f4f;
        }

        .btn-danger{
            padding:8px 14px;
            border-radius:4px;
            border:none;
            background:#e63946;
            color:#ffffff;
            font-weight:900;
            cursor:pointer;
        }

        .footerbar{
            margin-top:22px;
            background:#2f3f4f;
            color:#fff;
            text-align:center;
            padding:10px 10px;
            border-radius:0 0 10px 10px;
        }

        @media (max-width: 900px){
            .order-header{
                flex-direction:column;
                align-items:flex-start;
            }
            .order-footer{
                flex-direction:column;
                align-items:flex-start;
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
            <a class="active" href="<%=ctx%>/OrderHistoryServlet"><span>📦</span> Order History</a>

            <% if (userName == null) { %>
                <a href="<%=ctx%>/register.jsp"><span>📝</span> Register</a>
                <a href="<%=ctx%>/login.jsp"><span>🔐</span> Log in</a>
            <% } else { %>
                <a href="<%=ctx%>/LogoutServlet"><span>🚪</span> Logout</a>
            <% } %>
        </div>
    </div>

    <!-- MAIN -->
    <div class="main">
        <div class="center-col">
            <div class="wrap">

                <% if (flash != null) { %>
                    <div style="background:#e6f7ea;color:#1b7b3a;padding:10px;border-radius:6px;margin-bottom:12px;">
                        <%= flash %>
                    </div>
                <% } %>

                <div class="title">ORDER HISTORY</div>
                <div class="title-line"></div>

                <% if (orders.isEmpty()) { %>
                    <div class="empty-card">
                        No orders yet. Start shopping to place your first order.
                    </div>
                <% } else { %>

                    <% for (OrderSummaryDTO o : orders) {
                           List<OrderItemLine> lines = o.getItems();
                           OrderItemLine first = (lines == null || lines.isEmpty()) ? null : lines.get(0);
                    %>
                    <div class="order-card">

                        <div class="order-header">
                            <div>
                                <div class="order-header-main">
                                    ORDER # <%= o.getOrderCode() %>
                                </div>
                                <div class="order-header-sub">
                                    <%= new java.text.SimpleDateFormat("MMM dd, yyyy")
                                            .format(o.getOrderDate()) %>
                                    &nbsp;&nbsp;
                                    RM<%= (o.getTotalAmount() == null)
                                            ? "0.00"
                                            : String.format("%.2f",
                                                    o.getTotalAmount().doubleValue()) %>
                                </div>
                            </div>

                            <div class="status-badges">
                                <%
                                    String st = o.getStatus();
                                    if (st == null || st.trim().isEmpty()) {
                                        st = "PENDING";
                                    }
                                    String css;
                                    if ("DELIVERED".equalsIgnoreCase(st)) {
                                        css = "badge-delivered";
                                    } else if ("CANCELLED".equalsIgnoreCase(st)) {
                                        css = "badge-cancel";
                                    } else if ("SHIPPING".equalsIgnoreCase(st)) {
                                        css = "badge-shipping";
                                    } else if ("PROCESSING".equalsIgnoreCase(st)) {
                                        css = "badge-processing";
                                    } else {
                                        css = "badge-pending";
                                    }
                                %>
                                <div class="badge <%= css %>"><%= st %></div>
                            </div>
                        </div>

                        <div class="section-label">Items Ordered</div>
                        <div class="section-line"></div>

                        <% if (first != null) {
                               java.math.BigDecimal unit = first.getUnitPrice();
                               int qty = first.getQuantity();
                               java.math.BigDecimal lineTotal =
                                   (unit == null
                                       ? java.math.BigDecimal.ZERO
                                       : unit.multiply(java.math.BigDecimal.valueOf(qty)));
                        %>
                        <div class="item-row">
                            <div class="thumb">
                                <img src="<%= (first.getImage() == null || first.getImage().trim().isEmpty())
                                        ? ctx + "/images/book1.jpg"
                                        : (first.getImage().startsWith("http") ? first.getImage()
                                           : ctx + "/images/" + first.getImage()) %>"
                                     onerror="this.style.display='none';">
                            </div>
                            <div class="item-info">
                                <div class="item-title"><%= first.getTitle() %></div>
                                <div class="item-price">
                                    RM<%= unit == null
                                            ? "0.00"
                                            : String.format("%.2f", unit.doubleValue()) %> each
                                </div>
                            </div>
                            <div class="item-qtytotal">
                                QTY: <%= qty %><br>
                                RM<%= String.format("%.2f", lineTotal.doubleValue()) %>
                            </div>
                        </div>
                        <% } %>

                        <div class="order-footer">
                            <div class="ship-text">
                                Shipping to:
                                <%= o.getShipAddress() %>,
                                <%= o.getShipCity() %>,
                                <%= o.getShipPostal() %>
                            </div>
                            <div>
                                <form action="<%=ctx%>/CancelOrderServlet" method="post"
                                      onsubmit="return confirm('Are you sure you want to cancel this order?');">
                                    <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                                    <button class="btn-danger" type="submit">CANCEL ORDER</button>
                                </form>
                            </div>
                        </div>

                    </div>
                    <% } %>
                <% } %>

                <div class="footerbar">
                    © 2026 - NothingHillBookshop. Your favorite online bookshop
                </div>

            </div>
        </div>
    </div>

</div>

</body>
</html>
