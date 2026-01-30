<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.BookDTO"%>

<%
    BookDTO b = (BookDTO) request.getAttribute("book");
    if (b == null) {
        response.sendRedirect(request.getContextPath() + "/BooksServlet");
        return;
    }

    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");

    String ctx = request.getContextPath();
    String success = (String) request.getAttribute("success");

    String img = b.getImage();
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

<!DOCTYPE html>
<html>
<head>
    <title><%= b.getTitle() %> - Details</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
    <style>
        body{
            margin:0;
            background:#f4f6f9; /* same family as catalogue */
        }
        .page-wrap{
            width: 100%;
            max-width: 1400px;
            margin: 0 auto;
            padding: 18px;
        }
        .panel{
            background:#fff;
            border-radius:10px;
            box-shadow:0 8px 18px rgba(0,0,0,0.08);
            padding: 22px 24px;
            margin-bottom: 22px;
        }

        .detail-card{
            background:#fff;
            border-radius:10px;
            box-shadow:0 8px 18px rgba(0,0,0,0.08);
            padding:24px;
            display:flex;
            gap:24px;
        }
        .detail-cover{
            width:260px;
            min-width:260px;
            height:360px;
            background:#e9eef3;
            border-radius:8px;
            overflow:hidden;
            display:flex;
            align-items:center;
            justify-content:center;
        }
        .detail-cover img{
            width:100%;
            height:100%;
            object-fit:cover;
            display:block;
        }

        .detail-body{
            flex:1;
            display:flex;
            flex-direction:column;
        }
        .detail-title{
            font-size:26px;
            font-weight:900;
            margin:0 0 6px 0;
            color:#2f3f4f;
        }
        .detail-author{
            margin:0 0 12px 0;
            color:#6b7a8a;
            font-size:14px;
        }
        .badge-cat{
            display:inline-block;
            padding:4px 8px;
            border-radius:999px;
            background:#e9f2ff;
            color:#1d66d1;
            font-size:11px;
            font-weight:900;
            margin-left:6px;
        }
        .detail-meta{
            font-size:13px;
            color:#4b5b6b;
            margin-bottom:12px;
        }
        .detail-desc{
            font-size:14px;
            color:#2f3f4f;
            line-height:1.7;
            margin-bottom:18px;
            max-height:160px;
            overflow:auto;
        }
        .detail-price{
            font-size:22px;
            font-weight:900;
            color:#2f3f4f;
            margin-bottom:12px;
        }

        .detail-actions{
            margin-top:auto;
            display:flex;
            gap:10px;
            align-items:center;
        }
        .btn-primary{
            padding:10px 18px;
            border-radius:4px;
            border:none;
            background:#2f3f4f;
            color:#fff;
            font-weight:900;
            cursor:pointer;
        }
        .btn-outline{
            padding:10px 18px;
            border-radius:4px;
            border:2px solid #2f3f4f;
            background:transparent;
            color:#2f3f4f;
            font-weight:900;
            cursor:pointer;
            text-decoration:none;
        }
        .link-back{
            display:inline-block;
            margin-top:14px;
            color:#2f3f4f;
            font-weight:900;
            text-decoration:none;
        }

        @media (max-width:900px){
            .detail-card{
                flex-direction:column;
                align-items:center;
            }
            .detail-cover{
                width:220px;
                height:320px;
            }
            .detail-body{
                width:100%;
            }
        }
    </style>
</head>
<body>

<div class="page">

    <div class="sidebar">
        <div class="logo-box">
            <img src="<%=ctx%>/images/logo.jpg" alt="The Nothing Hill Bookshop">
        </div>

        <div class="menu">
            <a href="<%=ctx%>/home.jsp"><span>🏠</span> Home</a>
            <a class="active" href="<%=ctx%>/BooksServlet"><span>📖</span> Books</a>
            <a href="<%=ctx%>/about.jsp"><span>ℹ️</span> About</a>
            <a href="<%=ctx%>/CartServlet"><span>🛒</span> Cart</a>

            <% if (userRole != null && "ADMIN".equalsIgnoreCase(userRole)) { %>
                <a href="<%=ctx%>/AdminDashboardServlet"><span>🛡️</span> Admin Dashboard</a>
            <% } %>

            <% if (userName == null) { %>
                <a href="<%=ctx%>/register.jsp"><span>📝</span> Register</a>
                <a href="<%=ctx%>/login.jsp"><span>🔐</span> Log in</a>
            <% } else { %>
                <a href="<%=ctx%>/OrderHistoryServlet"><span>📦</span> Order History</a>
                <a href="<%=ctx%>/LogoutServlet"><span>🚪</span> Logout</a>
            <% } %>
        </div>
    </div>

    <div class="main">
        <div class="center-col">
            <div class="page-wrap">

                <% if (success != null) { %>
                    <div style="background:#e6f7ea;color:#1b7b3a;padding:10px;border-radius:6px;margin-bottom:12px;">
                        <%= success %>
                    </div>
                <% } %>

                <div class="panel">
                    <h2>📖 Book Details</h2>
                </div>

                <div class="detail-card">
                    <div class="detail-cover">
                        <img src="<%=imgUrl%>"
                             alt="Book cover"
                             onerror="this.style.display='none'; this.parentNode.style.background='#e9eef3';">
                    </div>

                    <div class="detail-body">
                        <h1 class="detail-title"><%= b.getTitle() %></h1>
                        <p class="detail-author">
                            by <b><%= b.getAuthor() == null ? "-" : b.getAuthor() %></b>
                            <% if (b.getCategory() != null) { %>
                                <span class="badge-cat"><%= b.getCategory() %></span>
                            <% } %>
                        </p>

                        <div class="detail-meta">
                            Stock: <b><%= b.getStock() %></b>
                        </div>

                        <div class="detail-desc">
                            <%= b.getDescription() == null
                                    ? "No description provided yet for this book."
                                    : b.getDescription() %>
                        </div>

                        <div class="detail-price">
                            RM <%= String.format("%.2f", b.getPrice()) %>
                        </div>

                        <div class="detail-actions">
                            <form action="<%=ctx%>/AddToCartServlet" method="post">
                                <input type="hidden" name="bookId" value="<%= b.getId() %>">
                                <button type="submit" class="btn-primary">Add to Cart</button>
                            </form>

                            <a href="<%=ctx%>/BooksServlet" class="btn-outline">
                                Back to books
                            </a>
                        </div>
                    </div>
                </div>

                <a href="<%=ctx%>/BooksServlet" class="link-back">← Back to catalogue</a>

            </div>
        </div>
    </div>

</div>

</body>
</html>
