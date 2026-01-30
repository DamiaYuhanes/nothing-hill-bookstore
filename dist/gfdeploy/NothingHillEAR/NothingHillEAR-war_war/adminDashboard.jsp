<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Number totalUsersN    = (Number) request.getAttribute("totalUsers");
    Number totalProductsN = (Number) request.getAttribute("totalProducts");
    Number totalOrdersN   = (Number) request.getAttribute("totalOrders");

    long totalUsers    = (totalUsersN == null) ? 0L : totalUsersN.longValue();
    long totalProducts = (totalProductsN == null) ? 0L : totalProductsN.longValue();
    long totalOrders   = (totalOrdersN == null) ? 0L : totalOrdersN.longValue();

    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Admin Dashboard - NothingHillBookshop</title>

    <link rel="stylesheet" href="<%= ctx %>/css/style.css">

    <style>
        html, body { height: 100%; }
        body { margin: 0; }

        .page {
            min-height: 100vh;
            display: flex;
            flex-direction: row;
            background:#f1f4f8;
        }

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

        .dash-card{
            background:#fff;
            border-radius:10px;
            box-shadow:0 8px 18px rgba(0,0,0,0.06);
            border: 1px solid rgba(47,63,79,0.10);
            padding: 22px;
            margin-bottom: 18px;
        }

        .dash-title{
            font-size: 28px;
            font-weight: 900;
            color:#2f3f4f;
            display:flex;
            align-items:center;
            gap:10px;
            margin: 0 0 4px 0;
        }
        .dash-sub{
            color:#92a2ab;
            font-weight:700;
            margin:0;
        }

        .kpi-row{
            display:flex;
            gap:18px;
            margin-top: 14px;
            flex-wrap: wrap;
        }
        .kpi{
            flex:1;
            min-width: 260px;
            padding: 22px;
            border-radius:10px;
            color:#fff;
            font-weight:900;
            display:flex;
            justify-content:space-between;
            align-items:center;
        }
        .kpi .label{ font-size:13px; opacity:0.9; font-weight:900; }
        .kpi .val{ font-size:42px; margin-top:6px; }
        .kpi .icon{ font-size:36px; opacity:0.25; }

        .kpi.blue{ background:#1e73ff; }
        .kpi.green{ background:#1fa06a; }
        .kpi.yellow{ background:#ffc107; color:#2b2b2b; }
        .kpi.yellow .icon{ opacity:0.22; }

        .mg-grid{
            display:grid;
            grid-template-columns: repeat(3, 1fr);
            gap:18px;
            margin-top:14px;
        }
        .mg-card{
            background:#fff;
            border-radius:10px;
            box-shadow:0 8px 18px rgba(0,0,0,0.05);
            border: 1px solid rgba(47,63,79,0.10);
            padding: 20px;
            min-height: 190px;
            display:flex;
            flex-direction:column;
            justify-content:space-between;
        }
        .mg-card h3{
            margin:0 0 6px 0;
            color:#2f3f4f;
            font-weight:900;
        }
        .mg-card p{
            margin:0;
            color:#2f3f4f;
            opacity:0.75;
            font-weight:700;
            font-size:13px;
            line-height:1.45;
        }

        .mg-actions{
            margin-top:14px;
            display:flex;
            gap:10px;
            flex-wrap: wrap;
        }

        .btn-dark{
            background:#2f3f4f;
            color:#fff;
            border:none;
            padding: 12px 18px;
            border-radius: 6px;
            font-weight: 900;
            cursor:pointer;
            min-width: 160px;
        }
        .btn-dark:hover{ filter:brightness(0.95); }

        .btn-green{
            background:#1fa06a;
            color:#fff;
            border:none;
            padding: 12px 18px;
            border-radius: 6px;
            font-weight: 900;
            cursor:pointer;
            min-width: 160px;
        }
        .btn-green:hover{ filter:brightness(0.95); }

        .admin-footer {
            background:#263646;
            color:#ffffff;
            text-align:center;
            padding:10px 0;
            font-weight:800;
            font-size:13px;
        }

        @media (max-width: 1100px){
            .mg-grid{ grid-template-columns: 1fr; }
        }
    </style>
</head>

<body>

<div class="page">

    <!-- LEFT SIDEBAR -->
    <div class="sidebar">
        <div class="logo-box">
            <img src="<%=ctx%>/images/logo.jpg" alt="The Nothing Hill Bookshop">
        </div>

        <div class="menu">
            <a class="active" href="<%=ctx%>/AdminDashboardServlet"><span>⚙️</span> Admin Dashboard</a>
            <a href="<%=ctx%>/LogoutServlet"><span>🚪</span> Log out</a>
        </div>
    </div>

    <!-- RIGHT: ADMIN MAIN CONTENT -->
    <div class="admin-main">
        <div class="admin-main-inner">

            <div class="dash-card">
                <div class="dash-title">⚙️ Admin Dashboard</div>
                <div class="dash-sub">Overview &amp; management tools</div>
            </div>

            <div class="dash-card">
                <div style="font-size:20px;font-weight:900;color:#2f3f4f;">Key Statistics</div>

                <div class="kpi-row">
                    <div class="kpi blue">
                        <div>
                            <div class="label">Total Users</div>
                            <div class="val"><%= totalUsers %></div>
                        </div>
                        <div class="icon">👥</div>
                    </div>

                    <div class="kpi green">
                        <div>
                            <div class="label">Total Products</div>
                            <div class="val"><%= totalProducts %></div>
                        </div>
                        <div class="icon">📦</div>
                    </div>

                    <div class="kpi yellow">
                        <div>
                            <div class="label">Total Orders</div>
                            <div class="val"><%= totalOrders %></div>
                        </div>
                        <div class="icon">🛒</div>
                    </div>
                </div>
            </div>

            <div class="dash-card">
                <div style="font-size:20px;font-weight:900;color:#2f3f4f;">Management Sections</div>

                <div class="mg-grid">

                    <div class="mg-card">
                        <div>
                            <h3>Product Management</h3>
                            <p>Add/update products, manage stock and categories.</p>
                        </div>
                        <div class="mg-actions">
                            <form action="<%=ctx%>/Admin/ManageProducts" method="get" style="margin:0;">
                                <button class="btn-dark" type="submit">Manage Products</button>
                            </form>
                            <form action="<%=ctx%>/AddProductServlet" method="get" style="margin:0;">
                                <button class="btn-green" type="submit">Add Product</button>
                            </form>
                        </div>
                    </div>

                    <div class="mg-card">
                        <div>
                            <h3>User Management</h3>
                            <p>View user list, edit details, activate/deactivate accounts.</p>
                        </div>
                        <div class="mg-actions">
                            <!-- IMPORTANT: link to ManageUsers -->
                            <form action="<%=ctx%>/Admin/ManageUsers" method="get" style="margin:0%;">
                                <button class="btn-dark" type="submit">Manage Users</button>
                            </form>
                        </div>
                    </div>

                    <div class="mg-card">
                        <div>
                            <h3>Order Management</h3>
                            <p>View &amp; update orders, change statuses and track shipments.</p>
                        </div>
                        <div class="mg-actions">
                            <form action="<%=ctx%>/Admin/ManageOrders" method="get" style="margin:0%;">
                                <button class="btn-dark" type="submit">Manage Orders</button>
                            </form>
                        </div>
                    </div>

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
