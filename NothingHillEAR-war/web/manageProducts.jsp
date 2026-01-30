<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.BookDTO" %>
<%@ page import="java.text.NumberFormat" %>

<%
    // Guard: only ADMIN can access
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get list from request (set by ManageProductsServlet)
    List<BookDTO> books = (List<BookDTO>) request.getAttribute("books");
    if (books == null) {
        books = new java.util.ArrayList<BookDTO>();
    }

    // flash messages from session (set by servlets)
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    if (success != null) { session.removeAttribute("success"); }
    if (error != null) { session.removeAttribute("error"); }

    NumberFormat cf = NumberFormat.getCurrencyInstance();
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Manage Products - Admin</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
    <style>
        html, body {
            height: 100%;
        }
        body {
            margin: 0;
        }

        .page {
            min-height: 100vh;
            display: flex;
            flex-direction: row;
            background:#f1f4f8;
        }

        /* .sidebar and .menu visual styles come from style.css (same as login/admin dashboard) */

        .admin-main {
            flex:1;
            display:flex;
            flex-direction:column;
        }

        .admin-main-inner {
            flex:1;
            padding: 24px 32px 40px 32px;
            box-sizing:border-box;
        }

        .panel{
            background:#fff;
            border-radius:10px;
            box-shadow:0 8px 18px rgba(0,0,0,0.06);
            border: 1px solid rgba(47,63,79,0.10);
            padding: 22px;
        }

        .page-title {
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-bottom:16px;
        }
        .page-title h1 {
            margin:0;
            font-size:26px;
            color:#22343b;
            font-weight:900;
            display:flex;
            align-items:center;
            gap:8px;
        }

        .btn-main {
            display:inline-block;
            background:#1fa06a;
            color:#fff;
            padding:10px 16px;
            border-radius:8px;
            text-decoration:none;
            font-weight:800;
            border:none;
            cursor:pointer;
        }
        .btn-main:hover { filter:brightness(0.95); }

        .msg { padding:10px; border-radius:6px; margin-bottom:12px; font-weight:700; }
        .msg.success { background:#e6f7ea; color:#1b7b3a; }
        .msg.error { background:#ffe6e6; color:#8b1c1c; }

        table.products { width:100%; border-collapse:separate; border-spacing:0 10px; }
        table.products thead th {
            text-align:left;
            padding:10px 14px;
            color:#334;
            font-weight:800;
            font-size:13px;
            background:transparent;
        }
        table.products tbody td {
            background:#fff;
            padding:14px;
            vertical-align:middle;
            border-bottom:1px solid #eef2f5;
            font-size:14px;
            color:#23313a;
        }

        .thumb {
            width:70px;
            height:90px;
            object-fit:cover;
            border-radius:6px;
            box-shadow:0 3px 8px rgba(0,0,0,0.06);
        }
        .title-block { font-weight:800; color:#203847; }
        .small { color:#7b8b90; font-weight:600; font-size:13px; margin-top:2px; }
        .price { color:#ff9f1c; font-weight:900; }

        .action-buttons { display:flex; gap:8px; justify-content:flex-end; }

        .btn-edit {
            background:#0b76ff;
            color:#fff;
            padding:8px 12px;
            border-radius:8px;
            text-decoration:none;
            font-weight:800;
            border:none;
            cursor:pointer;
        }
        .btn-delete {
            background:#ff4d4f;
            color:#fff;
            padding:8px 12px;
            border-radius:8px;
            font-weight:800;
            border:none;
            cursor:pointer;
        }
        .btn-edit:hover, .btn-delete:hover { filter:brightness(0.95); }

        .admin-footer {
            background:#263646;
            color:#ffffff;
            text-align:center;
            padding:10px 0;
            font-weight:800;
            font-size:13px;
        }

        @media (max-width: 1000px) {
            .page { flex-direction:column; }
            .sidebar { width:100%; }
            .admin-main-inner { padding:16px; }
        }
    </style>
</head>
<body>

<div class="page">

    <!-- LEFT SIDEBAR: same style as Admin Dashboard, same menu (Dashboard + Logout) -->
    <div class="sidebar">
        <div class="logo-box">
            <img src="<%=ctx%>/images/logo.jpg" alt="The Nothing Hill Bookshop">
        </div>

        <div class="menu">
            <a href="<%=ctx%>/AdminDashboardServlet"><span>⚙️</span> Admin Dashboard</a>
            <a class="active" href="<%=ctx%>/Admin/ManageProducts"><span>📦</span> Manage Products</a>
            <a href="<%=ctx%>/LogoutServlet"><span>🚪</span> Log out</a>
        </div>
    </div>

    <!-- RIGHT: MAIN CONTENT -->
    <div class="admin-main">
        <div class="admin-main-inner">

            <div class="panel">
                <div class="page-title">
                    <h1>📦 Manage Products</h1>
                    <a class="btn-main" href="<%= ctx %>/AddProductServlet">+ Add New Product</a>
                </div>

                <% if (success != null) { %>
                    <div class="msg success"><%= success %></div>
                <% } %>
                <% if (error != null) { %>
                    <div class="msg error"><%= error %></div>
                <% } %>

                <div style="overflow:auto; margin-top:10px;">
                    <table class="products">
                        <thead>
                        <tr>
                            <th style="width:60px">ID</th>
                            <th style="width:90px">Image</th>
                            <th>Product Name</th>
                            <th style="width:140px">Category</th>
                            <th style="width:120px">Price</th>
                            <th style="width:80px">Stock</th>
                            <th style="width:180px; text-align:right;">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (books.isEmpty()) { %>
                            <tr>
                                <td colspan="7" style="padding:30px; text-align:center; color:#556;">
                                    No product found.
                                </td>
                            </tr>
                        <% } else {
                            for (BookDTO p : books) {
                                String img = p.getImage();
                                if (img == null || img.trim().isEmpty()) img = ctx + "/images/no-image.png";
                        %>
                            <tr>
                                <td><%= p.getId() %></td>
                                <td>
                                    <img class="thumb" src="<%= img %>" alt="thumb">
                                </td>
                                <td>
                                    <div class="title-block"><%= p.getTitle() %></div>
                                    <div class="small"><%= (p.getAuthor() == null ? "" : p.getAuthor()) %></div>
                                </td>
                                <td><span class="small"><%= (p.getCategory()==null? "General": p.getCategory()) %></span></td>
                                <td><span class="price"><%= cf.format(p.getPrice()) %></span></td>
                                <td><%= p.getStock() %></td>
                                <td style="text-align:right;">
                                    <div class="action-buttons">
                                        <form action="<%= ctx %>/Admin/EditProduct" method="get" style="display:inline;">
                                            <input type="hidden" name="id" value="<%= p.getId() %>">
                                            <button type="submit" class="btn-edit">EDIT</button>
                                        </form>

                                        <form action="<%= ctx %>/Admin/DeleteProduct" method="post" style="display:inline;" onsubmit="return confirm('Delete this product?');">
                                            <input type="hidden" name="id" value="<%= p.getId() %>">
                                            <button type="submit" class="btn-delete">DELETE</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <%  } } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

        <div class="admin-footer">
            © 2026 - NothingHillBookshop. Your favorite online bookshop
        </div>
    </div>

</div>

</body>
</html>
