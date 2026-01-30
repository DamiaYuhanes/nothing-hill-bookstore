<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dto.BookDTO" %>
<%@ page import="java.text.NumberFormat" %>

<%
    // Guard: admin only
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    BookDTO book = (BookDTO) request.getAttribute("book");
    if (book == null) {
        // If no book in request, redirect back
        response.sendRedirect(request.getContextPath() + "/Admin/ManageProducts");
        return;
    }

    String ctx = request.getContextPath();
    NumberFormat nf = NumberFormat.getNumberInstance();
    nf.setMinimumFractionDigits(2);
    nf.setMaximumFractionDigits(2);

    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    if (success != null) {
        session.removeAttribute("success");
    }
    if (error != null) {
        session.removeAttribute("error");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Edit Product - <%= book.getTitle()%></title>
        <link rel="stylesheet" href="<%= ctx%>/css/style.css">

        <style>
            html, body {
                height:100%;
                margin:0;
            }

            .page {
                min-height:100vh;
                display:flex;
                flex-direction:row;
                background:#f1f4f8;
            }

            /* Sidebar same family as admin pages */
            .sidebar{
                width:260px;
                background:#2f3f4f;
                color:#fff;
                padding:22px 18px;
                box-sizing:border-box;
            }
            .logo-box{
                text-align:center;
                margin-bottom:22px;
            }
            .logo-box img{
                width:180px;
                max-width:100%;
            }
            .menu a{
                display:block;
                padding:10px 12px;
                color:#fff;
                text-decoration:none;
                border-radius:6px;
                margin-bottom:6px;
                font-weight:600;
            }
            .menu a span{
                margin-right:6px;
            }
            .menu a:hover,
            .menu a.active{
                background:rgba(255,255,255,0.10);
            }

            /* Main area */
            .admin-main{
                flex:1;
                display:flex;
                flex-direction:column;
            }

            .admin-main-inner{
                flex:1;
                padding:32px 40px 40px 40px;
                box-sizing:border-box;
                display:flex;
                justify-content:center;
                align-items:flex-start;
            }

            .edit-wrapper{
                width:100%;
                max-width:1100px;
            }

            .panel{
                background:#ffffff;
                border-radius:12px;
                padding:26px 28px 30px 28px;
                box-shadow:0 10px 24px rgba(0,0,0,0.08);
                border:1px solid rgba(47,63,79,0.08);
            }

            .panel-header{
                display:flex;
                justify-content:space-between;
                align-items:center;
                gap:14px;
                margin-bottom:18px;
            }
            .panel-header-left h2{
                margin:0;
                font-size:26px;
                font-weight:900;
                color:#233540;
            }
            .panel-header-left small{
                display:block;
                margin-top:4px;
                color:#7a8a92;
                font-weight:600;
            }

            .btn{
                padding:10px 16px;
                border-radius:8px;
                font-weight:800;
                text-decoration:none;
                border:none;
                cursor:pointer;
                font-size:14px;
            }
            .btn.secondary{
                background:#ffffff;
                border:2px solid #233540;
                color:#233540;
            }
            .btn.primary{
                background:#233540;
                color:#ffffff;
            }

            .msg{
                padding:10px 12px;
                border-radius:6px;
                margin-bottom:12px;
                font-weight:700;
                font-size:14px;
            }
            .msg.success{
                background:#e6f7ea;
                color:#1b7b3a;
            }
            .msg.error{
                background:#ffe6e6;
                color:#8b1c1c;
            }

            .form-row{
                display:flex;
                gap:18px;
                margin-bottom:14px;
                flex-wrap:wrap;
            }
            .col{
                flex:1;
                min-width:220px;
            }
            label{
                display:block;
                font-weight:700;
                margin-bottom:6px;
                color:#2f3f4f;
                font-size:14px;
            }
            input[type=text],
            input[type=number],
            textarea{
                width:100%;
                padding:10px 11px;
                border-radius:6px;
                border:1px solid #dde2e7;
                box-sizing:border-box;
                font-size:14px;
            }
            textarea{
                resize:vertical;
            }

            .footer-row{
                display:flex;
                align-items:center;
                gap:12px;
                margin-top:16px;
            }
            .footer-row > div:last-child{
                margin-left:auto;
            }

            .admin-footer{
                background:#263646;
                color:#ffffff;
                text-align:center;
                padding:10px 0;
                font-weight:800;
                font-size:13px;
            }

            @media (max-width: 900px){
                .page{
                    flex-direction:column;
                }
                .sidebar{
                    width:100%;
                }
                .admin-main-inner{
                    padding:20px;
                }
            }
        </style>
    </head>
    <body>

        <div class="page">

            <!-- Sidebar -->
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

            <div class="admin-main">
                <div class="admin-main-inner">
                    <div class="edit-wrapper">
                        <div class="panel">

                            <div class="panel-header">
                                <div class="panel-header-left">
                                    <h2>Edit Product</h2>
                                    <small>Editing: <%= book.getTitle()%></small>
                                </div>
                            </div>

                            <% if (success != null) {%>
                            <div class="msg success"><%= success%></div>
                            <% } %>
                            <% if (error != null) {%>
                            <div class="msg error"><%= error%></div>
                            <% }%>

                            <form action="<%= ctx%>/Admin/EditProduct" method="post">
                                <input type="hidden" name="id" value="<%= book.getId()%>">

                                <div class="form-row">
                                    <div class="col">
                                        <label>Product Name</label>
                                        <input type="text" name="title" value="<%= book.getTitle()%>" required>
                                    </div>
                                    <div class="col">
                                        <label>Author</label>
                                        <input type="text" name="author" value="<%= book.getAuthor() == null ? "" : book.getAuthor()%>">
                                    </div>
                                </div>

                                <div style="margin-bottom:14px;">
                                    <label>Description</label>
                                    <textarea name="description" rows="6"><%= book.getDescription() == null ? "" : book.getDescription()%></textarea>
                                </div>

                                <div class="form-row">
                                    <div class="col">
                                        <label>Price (e.g. 25.00)</label>
                                        <input type="text" name="price" value="<%= nf.format(book.getPrice())%>" required>
                                    </div>
                                    <div class="col">
                                        <label>Stock Quantity</label>
                                        <input type="number" name="stock" min="0" value="<%= book.getStock()%>">
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="col">
                                        <label>Category</label>
                                        <input type="text" name="category" value="<%= book.getCategory() == null ? "General" : book.getCategory()%>">
                                    </div>
                                    <div class="col">
                                        <label>Image URL (optional)</label>
                                        <input type="text" name="image" value="<%= book.getImage() == null ? "" : book.getImage()%>">
                                    </div>
                                </div>

                                <div class="footer-row" style="margin-top:18px;">
                                    <div>
                                        <a href="<%= ctx%>/AdminDashboardServlet"
                                           style="font-weight:900; color:#6b2b9f; text-decoration:none;">
                                            ← Back to Dashboard
                                        </a>
                                    </div>

                                    <div>
                                        <label style="margin-right:12px;">
                                            <input type="checkbox" name="active" checked> Product is Active
                                        </label>
                                        <button type="submit" class="btn primary">Save Changes</button>
                                    </div>
                                </div>

                            </form>

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
