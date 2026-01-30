<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="dto.BookDTO"%>

<%
    if (request.getAttribute("books") == null) {
        response.sendRedirect(request.getContextPath() + "/BooksServlet");
        return;
    }

    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");

    String q = (String) request.getAttribute("q");
    String cat = (String) request.getAttribute("cat");
    if (q == null)  q = "";
    if (cat == null) cat = "All";

    List<String> categories = (List<String>) request.getAttribute("categories");
    if (categories == null) categories = Collections.emptyList();

    List<BookDTO> books = (List<BookDTO>) request.getAttribute("books");
    if (books == null) books = Collections.emptyList();

    String success = (String) request.getAttribute("success");
%>

<!DOCTYPE html>
<html>
<head>
    <title>NothingHillBookshop - Books</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
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
            padding: 26px 28px;
            margin-bottom: 22px;
        }
        .grid{
            display:grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 22px;
        }
        .card2{
            background:#fff;
            border-radius:10px;
            box-shadow:0 8px 18px rgba(0,0,0,0.08);
            overflow:hidden;
        }
        .cover{
            width:100%;
            height: 260px;
            background:#e9eef3;
            display:flex;
            align-items:center;
            justify-content:center;
        }
        .cover img{
            width:100%;
            height:100%;
            object-fit: cover;
            display:block;
        }
        .card-body{
            padding: 16px 16px 18px 16px;
        }
        .title{
            font-size: 20px;
            font-weight: 900;
            margin: 0 0 8px 0;
            color:#2f3f4f;
        }
        .desc{
            margin: 0;
            color:#2f3f4f;
            line-height:1.6;
            font-size: 14px;
            min-height: 46px;
            opacity: 0.95;
        }
        .small{
            margin-top:8px;
            font-size:13px;
            color:#4b5b6b;
        }
        .meta{
            display:flex;
            justify-content: space-between;
            align-items:center;
            margin-top: 14px;
        }
        .price{
            font-weight: 900;
            color:#2f3f4f;
        }
        .btn-cart{
            padding: 10px 12px;
            border: 2px solid #2f3f4f;
            background: transparent;
            color:#2f3f4f;
            font-weight: 900;
            border-radius: 4px;
            cursor:pointer;
        }
        .btn-cart:hover{
            background:#2f3f4f;
            color:#fff;
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
            <a href="<%=request.getContextPath()%>/home.jsp"><span>🏠</span> Home</a>
            <a class="active" href="<%=request.getContextPath()%>/BooksServlet"><span>📖</span> Books</a>
            <a href="<%=request.getContextPath()%>/about.jsp"><span>ℹ️</span> About</a>
            <a href="<%=request.getContextPath()%>/CartServlet"><span>🛒</span> Cart</a>

            <% if (userRole != null && "ADMIN".equalsIgnoreCase(userRole)) { %>
                <a href="<%=request.getContextPath()%>/AdminDashboardServlet"><span>🛡️</span> Admin Dashboard</a>
            <% } %>

            <% if (userName == null) { %>
                <a href="<%=request.getContextPath()%>/register.jsp"><span>📝</span> Register</a>
                <a href="<%=request.getContextPath()%>/login.jsp"><span>🔐</span> Log in</a>
            <% } else { %>
                <!-- only for logged-in users -->
                <a href="<%=request.getContextPath()%>/OrderHistoryServlet"><span>📦</span> Order History</a>
                <a href="<%=request.getContextPath()%>/LogoutServlet"><span>🚪</span> Logout</a>
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
                    <h2>📖 Book Catalogue</h2>

                    <form method="get" action="<%=request.getContextPath()%>/BooksServlet">
                        <div style="display:flex; gap:12px; flex-wrap:wrap; align-items:center;">
                            <select name="cat" style="padding:10px;">
                                <option value="All" <%= "All".equalsIgnoreCase(cat) ? "selected" : "" %>>All Categories</option>
                                <% for (String c : categories) { %>
                                    <option value="<%=c%>" <%= c.equalsIgnoreCase(cat) ? "selected" : "" %>><%=c%></option>
                                <% } %>
                            </select>

                            <input type="text" name="q" value="<%= q %>"
                                   placeholder="Search by title, author, or description..."
                                   style="padding:10px; flex:1;">
                            <button type="submit" style="padding:10px 18px;">Search</button>
                        </div>
                    </form>

                </div>

                <div class="grid">
                    <% if (books.isEmpty()) { %>
                        <div style="grid-column:1 / -1; background:#fff; border-radius:10px;
                                    box-shadow:0 8px 18px rgba(0,0,0,0.08); padding:18px;">
                            No books found for this filter/search.
                        </div>
                    <% } %>

                    <% for (BookDTO b : books) {
                           String img = b.getImage();
                           String imgUrl;
                           if (img == null || img.trim().isEmpty()) {
                               imgUrl = request.getContextPath() + "/images/book1.jpg";
                           } else if (img.startsWith("http")) {
                               imgUrl = img;
                           } else if (img.startsWith("/")) {
                               imgUrl = request.getContextPath() + img;
                           } else {
                               imgUrl = request.getContextPath() + "/images/" + img;
                           }
                    %>

                    <div class="card2">
                        <div class="cover">
                            <img src="<%=imgUrl%>"
                                 onerror="this.style.display='none'; this.parentNode.style.background='#e9eef3';"
                                 alt="Book cover">
                        </div>
                        <div class="card-body">
                            <div class="title"><%= b.getTitle() %></div>
                            <p class="desc"><%= b.getDescription() == null ? "" : b.getDescription() %></p>

                            <div class="small">
                                Author: <b><%= b.getAuthor() == null ? "-" : b.getAuthor() %></b>
                                | Category: <b><%= b.getCategory() == null ? "-" : b.getCategory() %></b>
                            </div>

                            <div class="meta">
                                <div class="price">RM <%= String.format("%.2f", b.getPrice()) %></div>

                                <div style="display:flex; gap:8px;">
                                    <!-- Add to cart -->
                                    <form class="inline-form"
                                          action="<%=request.getContextPath()%>/AddToCartServlet"
                                          method="post">
                                        <input type="hidden" name="bookId" value="<%= b.getId() %>">
                                        <button class="btn-cart" type="submit">Add to Cart</button>
                                    </form>

                                    <!-- View details -->
                                    <form class="inline-form"
                                          action="<%=request.getContextPath()%>/BookDetailsServlet"
                                          method="get">
                                        <input type="hidden" name="id" value="<%= b.getId() %>">
                                        <button class="btn-cart" type="submit"
                                                style="border-color:#1d66d1;color:#1d66d1;">
                                            View details
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <% } %>
                </div>

            </div>
        </div>
    </div>

</div>

</body>
</html>
