<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="dto.AdminOrderRowDTO" %>

<%
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    List<AdminOrderRowDTO> orders =
            (List<AdminOrderRowDTO>) request.getAttribute("orders");
    if (orders == null) orders = Collections.emptyList();

    String statusFilter = (String) request.getAttribute("statusFilter");
    if (statusFilter == null) statusFilter = "ALL";

    String success = (String) request.getAttribute("success");
    String error   = (String) request.getAttribute("error");

    String ctx = request.getContextPath();
    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Orders - Admin</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">

    <style>
        html, body { height:100%; margin:0; }
        .page{
            min-height:100vh;
            display:flex;
            flex-direction:row;
            background:#f1f4f8;
        }

        /* sidebar & menu look come from style.css (same as dashboard) */

        .main{
            flex:1;
            display:flex;
            justify-content:flex-start !important;
        }
        .center-col{
            width:100% !important;
            max-width:1400px !important;
            padding:24px 32px 40px 32px;
            box-sizing:border-box;
        }
        .card{
            width:100% !important;
            max-width:1400px !important;
            padding:22px 22px !important;
            border-radius:10px;
            background:#ffffff;
            box-shadow:0 8px 18px rgba(0,0,0,0.06);
            border:1px solid rgba(47,63,79,0.10);
        }

        .mo-header{
            display:flex;
            justify-content:space-between;
            align-items:center;
            gap:12px;
            margin-bottom:14px;
        }
        .mo-title{
            font-size:34px;
            font-weight:900;
            color:#2f3f4f;
            margin:0;
            display:flex;
            align-items:center;
            gap:10px;
        }
        .mo-title .icon{ font-size:26px; }

        .filter-box{
            display:inline-flex;
            align-items:center;
            gap:8px;
        }
        .filter-select{
            padding:8px 12px;
            border-radius:6px;
            border:1px solid #d0d7e2;
            font-weight:700;
            font-size:13px;
        }

        .alert{ border-radius:8px; padding:10px 12px; margin: 10px 0 14px 0; font-weight:800; }
        .alert-success{ background:#e9fff1; color:#166534; border:1px solid #b7f0c8; }
        .alert-error{ background:#ffe9e9; color:#9b1c1c; border:1px solid #ffc7c7; }

        .table-box{
            background:#fff;
            border-radius:10px;
            border:1px solid #e7eef4;
            overflow:hidden;
            margin-top:10px;
        }
        table{
            width:100% !important;
            border-collapse:collapse;
        }
        thead th{
            text-align:left;
            padding:14px 14px;
            background:#f6f9fc;
            color:#2f3f4f;
            font-weight:900;
            font-size:13px;
            border-bottom:1px solid #e7eef4;
        }
        tbody td{
            padding:12px 14px;
            border-bottom:1px solid #eef3f7;
            vertical-align:middle;
            font-size:14px;
            color:#2f3f4f;
        }
        tbody tr:last-child td{ border-bottom:none; }

        .status-select{
            padding:6px 10px;
            border-radius:6px;
            border:1px solid #d0d7e2;
            font-weight:700;
            font-size:13px;
            min-width:130px;
        }

        .actions{
            display:flex;
            gap:8px;
            justify-content:flex-end;
        }
        .btn-save{
            background:#1fa06a;
            color:#fff;
            border:none;
            padding:8px 14px;
            border-radius:8px;
            font-weight:800;
            cursor:pointer;
            min-width:90px;
        }
        .btn-cancel{
            background:#e63946;
            color:#fff;
            border:none;
            padding:8px 14px;
            border-radius:8px;
            font-weight:800;
            cursor:pointer;
            min-width:90px;
        }
        .btn-save:hover, .btn-cancel:hover{ filter:brightness(0.95); }

        .admin-footer{
            background:#263646;
            color:#ffffff;
            text-align:center;
            padding:10px 0;
            font-weight:800;
            font-size:13px;
        }

        @media (max-width: 900px){
            .mo-header{ flex-direction:column; align-items:flex-start; }
            .actions{ flex-direction:column; align-items:flex-end; }
        }
    </style>
</head>
<body>

<div class="page">

    <!-- SIDEBAR: same pattern as Admin Dashboard -->
    <div class="sidebar">
        <div class="logo-box">
            <img src="<%=ctx%>/images/logo.jpg" alt="The Nothing Hill Bookshop">
        </div>

        <div class="menu">
            <a href="<%=ctx%>/AdminDashboardServlet"><span>⚙️</span> Admin Dashboard</a>
            <a class="active" href="<%=ctx%>/Admin/ManageOrders"><span>📦</span> Manage Orders</a>
            <a href="<%=ctx%>/LogoutServlet"><span>🚪</span> Log out</a>
        </div>
    </div>

    <div class="main">
        <div class="center-col">
            <div class="card">

                <div class="mo-header">
                    <h1 class="mo-title"><span class="icon">📦</span> Manage Orders</h1>

                    <!-- filter dropdown -->
                    <form method="get" action="<%=ctx%>/Admin/ManageOrders" class="filter-box">
                        <label for="statusFilter">Show:</label>
                        <select id="statusFilter" name="status" class="filter-select"
                                onchange="this.form.submit()">
                            <option value="ALL"       <%= "ALL".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>All Orders</option>
                            <option value="PENDING"   <%= "PENDING".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Pending</option>
                            <option value="PROCESSING"<%= "PROCESSING".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Processing</option>
                            <option value="SHIPPING"  <%= "SHIPPING".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Shipping</option>
                            <option value="DELIVERED" <%= "DELIVERED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Delivered</option>
                            <option value="CANCELLED" <%= "CANCELLED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Cancelled</option>
                        </select>
                    </form>
                </div>

                <hr style="border:none;height:1px;background:#eef3f7;margin:8px 0 14px 0;">

                <% if (success != null) { %>
                <div class="alert alert-success"><%= success %></div>
                <% } %>
                <% if (error != null) { %>
                <div class="alert alert-error"><%= error %></div>
                <% } %>

                <div class="table-box">
                    <table>
                        <thead>
                        <tr>
                            <th style="width:60px;">ID</th>
                            <th style="width:170px;">Order #</th>
                            <th>Customer</th>
                            <th style="width:180px;">Date</th>
                            <th style="width:120px;">Total (RM)</th>
                            <th style="width:150px;">Status</th>
                            <th style="width:190px; text-align:right;">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (orders.isEmpty()) { %>
                        <tr>
                            <td colspan="7" style="padding:20px; text-align:center; color:#556;">
                                No orders found.
                            </td>
                        </tr>
                        <% } else {
                               for (AdminOrderRowDTO o : orders) {
                                   String dateStr = (o.getOrderDate() == null) ? "-" : df.format(o.getOrderDate());
                                   String status = (o.getStatus() == null) ? "PENDING" : o.getStatus();
                        %>
                        <tr>
                            <td><%= o.getId() %></td>
                            <td><%= o.getOrderCode() %></td>
                            <td><%= o.getCustomerName() %></td>
                            <td><%= dateStr %></td>
                            <td><%= String.format("%.2f", o.getTotalAmount().doubleValue()) %></td>

                            <td>
                                <form method="post" action="<%=ctx%>/Admin/ManageOrders">
                                    <input type="hidden" name="orderId" value="<%= o.getId() %>">
                                    <input type="hidden" name="currentFilter" value="<%= statusFilter %>">

                                    <select name="statusSelect" class="status-select">
                                        <option value="PENDING"   <%= "PENDING".equalsIgnoreCase(status) ? "selected" : "" %>>Pending</option>
                                        <option value="PROCESSING"<%= "PROCESSING".equalsIgnoreCase(status) ? "selected" : "" %>>Processing</option>
                                        <option value="SHIPPING"  <%= "SHIPPING".equalsIgnoreCase(status) ? "selected" : "" %>>Shipping</option>
                                        <option value="DELIVERED" <%= "DELIVERED".equalsIgnoreCase(status) ? "selected" : "" %>>Delivered</option>
                                        <option value="CANCELLED" <%= "CANCELLED".equalsIgnoreCase(status) ? "selected" : "" %>>Cancelled</option>
                                    </select>
                            </td>

                            <td style="text-align:right;">
                                    <div class="actions">
                                        <button type="submit" name="action" value="save" class="btn-save">Save</button>
                                        <button type="submit" name="action" value="cancel"
                                                class="btn-cancel"
                                                onclick="return confirm('Cancel this order?');">
                                            Cancel
                                        </button>
                                    </div>
                                </form>
                            </td>
                        </tr>
                        <%     } // end for
                           } // end else %>
                        </tbody>
                    </table>
                </div>

                <a href="<%=ctx%>/AdminDashboardServlet"
                   style="display:inline-block;margin-top:14px;font-weight:900;color:#6b2b9f;text-decoration:none;">
                    ← Back to Dashboard
                </a>

            </div>
        </div>
    </div>
</div>

<div class="admin-footer">
    © 2026 - NothingHillBookshop. Your favorite online bookshop
</div>

</body>
</html>
