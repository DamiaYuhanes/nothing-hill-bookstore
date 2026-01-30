<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="dto.CartItemDTO"%>

<%
    String ctx      = request.getContextPath();
    String userName = (String) session.getAttribute("userName");

    List<CartItemDTO> items = (List<CartItemDTO>) request.getAttribute("items");
    Double totalObj = (Double) request.getAttribute("total");

    if (items == null) items = Collections.emptyList();
    double grandTotal = (totalObj == null) ? 0.0 : totalObj.doubleValue();

    boolean empty = items.isEmpty();

    String successMsg = (String) session.getAttribute("success");
    if (successMsg != null) {
        session.removeAttribute("success");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>NothingHillBookshop - Cart</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
    <style>
        html, body { height: 100%; }
        body { margin:0; }
        .page { min-height: 100vh; display:flex; background:#eef2f7; }

        .main { width: 100%; }
        .center-col{
            width: 100%;
            padding: 24px 28px;
            box-sizing: border-box;
        }
        .wrap{
            width: 100%;
            max-width: 1100px;
            margin: 0 auto;
        }

        .cart-title{
            text-align:center; font-size: 24px; letter-spacing: 4px; font-weight: 900;
            color:#2f3f4f; margin: 10px 0 8px 0;
        }
        .title-line{
            height:2px; background:#2f3f4f; opacity:0.65; width: 80%;
            margin: 0 auto 26px auto;
        }

        .empty-box{
            background: #cfeef4; border-left: 4px solid #1aa0b2; border-radius: 10px;
            padding: 44px 20px; text-align:center; box-shadow:0 8px 18px rgba(0,0,0,0.08);
        }
        .empty-icon{ font-size: 42px; opacity: 0.25; margin-bottom: 8px; }
        .empty-box h2{ margin: 0; color:#0d5a66; font-size: 28px; font-weight: 900; }
        .empty-box p{ margin: 8px 0 20px 0; color:#0d5a66; opacity: 0.9; }

        .alert-success{
            margin-bottom:12px;
            padding:10px 12px;
            border-radius:6px;
            background:#e6f7ea;
            border:1px solid #b7eb8f;
            color:#237804;
            font-weight:700;
        }

        .btn-dark{
            background:#2f3f4f; color:#fff; border:none; padding: 12px 18px; border-radius: 4px;
            font-weight: 900; cursor:pointer; min-width: 160px;
        }

        .table-wrap{
            width: 100%;
            background:#fff; border-radius:10px; box-shadow:0 8px 18px rgba(0,0,0,0.08);
            overflow:hidden; border: 1px solid rgba(47,63,79,0.15);
        }

        .thead, .row{
            display:grid;
            grid-template-columns: minmax(360px, 1.6fr) 140px 230px 170px 160px;
            column-gap: 12px;
            align-items:center;
        }

        .thead{
            background:#3a4f63; color:#fff; font-weight:900;
            padding: 14px 16px; font-size: 14px;
        }

        .row{
            padding: 16px 16px;
            border-top: 1px solid rgba(47,63,79,0.12);
            background:#fff;
        }

        .prod{ display:flex; gap: 14px; align-items:center; }
        .thumb{
            width: 56px; height: 80px; background:#e9eef3;
            border: 1px solid rgba(47,63,79,0.12);
            border-radius: 4px; overflow:hidden; flex-shrink:0;
            display:flex; align-items:center; justify-content:center;
        }
        .thumb img{ width:100%; height:100%; object-fit: cover; display:block; }

        .pname{ font-weight: 900; color:#2f3f4f; font-size: 18px; margin: 0; }
        .pid{ font-size: 12px; color:#2f3f4f; opacity:0.7; margin-top: 4px; }

        .money{ font-weight: 900; color:#2f3f4f; }

        .qtybox{ display:flex; gap: 8px; align-items:center; justify-content:center; flex-wrap: wrap; }
        .qtyinput{
            width: 72px; padding: 8px 10px; border: 1px solid #d9dee5; border-radius: 3px;
        }

        .btn-update{
            background: transparent; border: 1px solid rgba(47,63,79,0.55);
            color:#2f3f4f; font-weight: 900; padding: 8px 12px; border-radius: 3px; cursor:pointer;
        }

        .btn-remove{
            background:#e63946; color:#fff; border:none; font-weight: 900;
            padding: 10px 14px; border-radius: 3px; cursor:pointer;
        }

        .btn-clear{
            background:#2f3f4f; color:#fff; border:none; font-weight: 900;
            padding: 10px 16px; border-radius: 3px; cursor:pointer;
        }

        .total-row{
            display:flex; justify-content:flex-end; gap: 16px;
            padding: 18px 16px; border-top: 1px solid rgba(47,63,79,0.12);
            background:#f7f8fa; font-size: 20px; font-weight: 900; color:#2f3f4f;
        }

        .actions{
            width: 100%;
            display:flex;
            justify-content:space-between;
            margin-top: 18px;
            gap: 18px;
        }
        .actions a{ flex: 1; }

        .btn-outline{
            width: 100%;
            background: transparent; border: 2px solid #2f3f4f; color:#2f3f4f;
            padding: 16px 26px; font-weight: 900; border-radius: 3px; cursor:pointer;
            letter-spacing: 2px;
        }

        .btn-checkout{
            width: 100%;
            background:#2f3f4f; border:none; color:#fff;
            padding: 16px 26px; font-weight: 900; border-radius: 3px; cursor:pointer;
            letter-spacing: 2px;
        }

        .footerbar{
            margin-top: 22px; background:#2f3f4f; color:#fff; text-align:center;
            padding: 14px 10px; border-radius: 0 0 10px 10px;
        }

        .cart-tools{
            display:flex;
            justify-content: flex-end;
            gap: 12px;
            margin: 0 0 12px 0;
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

            <a class="active" href="<%=ctx%>/CartServlet"><span>🛒</span> Cart</a>

            <% if (userName == null) { %>
                <a href="<%=ctx%>/register.jsp"><span>📝</span> Register</a>
                <a href="<%=ctx%>/login.jsp"><span>🔐</span> Log in</a>
            <% } else { %>
                <!-- only when logged in -->
                <a href="<%=ctx%>/OrderHistoryServlet"><span>📦</span> Order History</a>
                <a href="<%=ctx%>/LogoutServlet"><span>🚪</span> Logout</a>
            <% } %>
        </div>
    </div>

    <!-- MAIN -->
    <div class="main">
        <div class="center-col">
            <div class="wrap">

                <div class="cart-title">YOUR SHOPPING CART</div>
                <div class="title-line"></div>

                <% if (empty) { %>

                    <div class="empty-box">
                        <div class="empty-icon">🛒</div>
                        <h2>Your cart is empty!</h2>
                        <p>Looks like you haven't added any books to your cart yet.</p>

                        <a href="<%=ctx%>/BooksServlet">
                            <button class="btn-dark" type="button">Start Shopping</button>
                        </a>
                    </div>

                    <div class="footerbar">
                        © 2026 - NothingHillBookshop. Your favorite online bookshop
                    </div>

                <% } else { %>

                    <% if (successMsg != null) { %>
                        <div class="alert-success"><%= successMsg %></div>
                    <% } %>

                    <div class="cart-tools">
                        <form class="inline-form"
                              action="<%=ctx%>/CartServlet"
                              method="post"
                              onsubmit="return confirm('Clear all items in your cart?');">
                            <input type="hidden" name="action" value="clear">
                            <button class="btn-clear" type="submit">Clear Cart</button>
                        </form>
                    </div>

                    <div class="table-wrap">

                        <div class="thead">
                            <div>PRODUCT</div>
                            <div style="text-align:right;">PRICE</div>
                            <div style="text-align:center;">QUANTITY</div>
                            <div style="text-align:right;">SUBTOTAL</div>
                            <div style="text-align:center;">ACTION</div>
                        </div>

                        <%
                            for (CartItemDTO it : items) {

                                int bookId = it.getBookId();
                                String title = it.getTitle();
                                double price = it.getPrice();
                                int qty = it.getQuantity();
                                String img = it.getImage();
                                double sub = price * qty;

                                String imgUrl;
                                if (img == null || img.trim().isEmpty()) {
                                    imgUrl = ctx + "/images/book1.jpg";
                                } else if (img.startsWith("http")) {
                                    imgUrl = img;
                                } else if (img.startsWith("/")) {
                                    imgUrl = ctx + img;
                                } else {
                                    imgUrl = ctx + "/images/" + img;
                                }
                        %>

                        <div class="row">
                            <div class="prod">
                                <div class="thumb">
                                    <img src="<%= imgUrl %>" onerror="this.style.display='none';" alt="cover">
                                </div>
                                <div>
                                    <div class="pname"><%= title %></div>
                                    <div class="pid">Product ID: <%= bookId %></div>
                                </div>
                            </div>

                            <div class="money" style="text-align:right;">
                                RM<%= String.format("%.2f", price) %>
                            </div>

                            <div style="text-align:center;">
                                <form class="inline-form" action="<%=ctx%>/CartServlet" method="post">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="bookId" value="<%= bookId %>">

                                    <div class="qtybox">
                                        <input class="qtyinput" type="number" min="1" name="qty" value="<%= qty %>">
                                        <button class="btn-update" type="submit">Update</button>
                                    </div>
                                </form>
                            </div>

                            <div class="money" style="text-align:right;">
                                RM<%= String.format("%.2f", sub) %>
                            </div>

                            <div style="text-align:center;">
                                <form class="inline-form" action="<%=ctx%>/CartServlet" method="post"
                                      onsubmit="return confirm('Remove this item?');">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="bookId" value="<%= bookId %>">
                                    <button class="btn-remove" type="submit">Remove</button>
                                </form>
                            </div>
                        </div>

                        <% } %>

                        <div class="total-row">
                            <div>Grand Total:</div>
                            <div>RM<%= String.format("%.2f", grandTotal) %></div>
                        </div>

                    </div>

                    <div class="actions">
                        <a href="<%=ctx%>/BooksServlet">
                            <button class="btn-outline" type="button">CONTINUE SHOPPING</button>
                        </a>
                        <a href="<%=ctx%>/CheckoutServlet">
                            <button class="btn-checkout" type="button">PROCEED TO CHECKOUT</button>
                        </a>
                    </div>

                    <div class="footerbar">
                        © 2026 - NothingHillBookshop. Your favorite online bookshop
                    </div>

                <% } %>

            </div>
        </div>
    </div>

</div>

</body>
</html>