<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.UserDTO" %>

<%
    // Guard: only ADMIN can access
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    List<UserDTO> users = (List<UserDTO>) request.getAttribute("users");
    if (users == null) {
        users = new java.util.ArrayList<UserDTO>();
    }

    // flash messages from session
    String success = (String) session.getAttribute("success");
    String error   = (String) session.getAttribute("error");
    if (success != null) session.removeAttribute("success");
    if (error   != null) session.removeAttribute("error");

    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Manage Users - Admin</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
    <style>
        html, body{ height:100%; margin:0; }
        .page{
            min-height:100vh;
            display:flex;
            flex-direction:row;
            background:#f1f4f8;
        }

        .main{
            flex:1;
            display:flex;
            justify-content:flex-start !important;
        }
        .center-col{
            width:100%;
            max-width:1400px;
            padding:24px 32px 40px 32px;
            box-sizing:border-box;
        }
        .card{
            width:100%;
            max-width:1400px;
            padding:22px 22px;
            border-radius:10px;
            background:#ffffff;
            box-shadow:0 8px 18px rgba(0,0,0,0.06);
            border:1px solid rgba(47,63,79,0.10);
        }

        .mu-header{
            display:flex;
            justify-content:space-between;
            align-items:center;
            gap:12px;
            margin-bottom:14px;
        }
        .mu-title{
            font-size:34px;
            font-weight:900;
            color:#2f3f4f;
            margin:0;
            display:flex;
            align-items:center;
            gap:10px;
        }
        .mu-title .icon{ font-size:26px; }

        .btn-add{
            background:#1fa06a; color:#fff; border:none; padding:12px 18px; border-radius:10px;
            font-weight:900; cursor:pointer; box-shadow:0 8px 18px rgba(31,160,106,0.25);
            display:inline-flex; align-items:center; gap:8px; text-decoration:none; white-space:nowrap;
        }
        .btn-add:hover{ filter:brightness(0.95); }

        .alert{ border-radius:8px; padding:12px 14px; margin:12px 0 14px 0; font-weight:800; }
        .alert-error{ background:#ffe9e9; color:#9b1c1c; border:1px solid #ffc7c7; }
        .alert-success{ background:#e9fff1; color:#166534; border:1px solid #b7f0c8; }

        .table-box{
            background:#fff;
            border-radius:10px;
            border:1px solid #e7eef4;
            overflow:hidden;
            margin-top:10px;
        }
        table{
            width:100%;
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
            padding:14px 14px;
            border-bottom:1px solid #eef3f7;
            font-size:14px;
            color:#2f3f4f;
            vertical-align:middle;
        }
        tbody tr:last-child td{ border-bottom:none; }

        .status-active{ color:#1fa06a; font-weight:900; }
        .status-inactive{ color:#e63946; font-weight:900; }

        .actions{
            display:flex;
            gap:8px;
            justify-content:flex-end;
        }
        .btn-small{
            padding:6px 10px;
            border-radius:6px;
            border:none;
            font-weight:800;
            cursor:pointer;
            font-size:13px;
        }
        .btn-edit      { background:#1d66d1; color:#fff; }
        .btn-activate  { background:#1fa06a; color:#fff; }
        .btn-deactivate{ background:#e63946; color:#fff; }
        .btn-delete    { background:#555; color:#fff; }

        .back-link{
            display:inline-block;
            margin-top:14px;
            font-weight:900;
            color:#6b2b9f;
            text-decoration:none;
        }
        .back-link:hover{ text-decoration:underline; }

        .admin-footer{
            background:#263646;
            color:#ffffff;
            text-align:center;
            padding:10px 0;
            font-weight:800;
            font-size:13px;
        }

        @media (max-width:1000px){
            .page{ flex-direction:column; }
            .sidebar{ width:100%; }
            .center-col{ padding:16px; }
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
            <a href="<%=ctx%>/AdminDashboardServlet">⚙️ Admin Dashboard</a>
            <a class="active" href="<%=ctx%>/Admin/ManageUsers"><span>👥</span> Manage Users</a>
            <a href="<%=ctx%>/LogoutServlet">🚪 Log out</a>
        </div>
    </div>

    <!-- MAIN -->
    <div class="main">
        <div class="center-col">
            <div class="card">

                <div class="mu-header">
                    <h1 class="mu-title"><span class="icon">👥</span> Manage Users</h1>
                    <a class="btn-add" href="<%= ctx %>/Admin/AddUser">➕ Add New User</a>
                </div>

                <hr style="border:none;height:1px;background:#eef3f7;margin:10px 0 14px 0;">

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
                            <th style="width:200px;">Name</th>
                            <th style="width:220px;">Email</th>
                            <th style="width:100px;">Role</th>
                            <th style="width:120px;">Status</th>
                            <th style="width:280px; text-align:right;">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (users.isEmpty()) { %>
                            <tr>
                                <td colspan="6" style="padding:30px; text-align:center; color:#556;">
                                    No users found.
                                </td>
                            </tr>
                        <% } else {
                               for (UserDTO u : users) {
                                   String status = u.getStatus();
                                   boolean active = "ACTIVE".equalsIgnoreCase(status);
                        %>
                            <tr>
                                <td><%= u.getId() %></td>
                                <td><%= u.getName() %></td>
                                <td><%= u.getEmail() %></td>
                                <td><%= u.getRole() %></td>
                                <td>
                                    <span class="<%= active ? "status-active" : "status-inactive" %>">
                                        <%= status %>
                                    </span>
                                </td>
                                <td style="text-align:right;">
                                    <div class="actions">
                                        <!-- EDIT user (EditUserServlet.doGet -> editUser.jsp) -->
                                        <form action="<%=ctx%>/Admin/EditUser" method="get" style="display:inline;">
                                            <input type="hidden" name="id" value="<%= u.getId() %>">
                                            <button type="submit" class="btn-small btn-edit">Edit</button>
                                        </form>

                                        <!-- ACTIVATE / DEACTIVATE (ToggleUserStatusServlet expects id + to) -->
                                        <form action="<%=ctx%>/Admin/ToggleUserStatus" method="post"
                                              style="display:inline;"
                                              onsubmit="return confirm('Change status for this user?');">
                                            <input type="hidden" name="id" value="<%= u.getId() %>">
                                            <input type="hidden" name="to" value="<%= active ? "INACTIVE" : "ACTIVE" %>">
                                            <button type="submit"
                                                    class="btn-small <%= active ? "btn-deactivate" : "btn-activate" %>">
                                                <%= active ? "Deactivate" : "Activate" %>
                                            </button>
                                        </form>

                                        <!-- DELETE user (you must implement DeleteUserServlet to delete from users table) -->
                                        <form action="<%=ctx%>/DeleteUserServlet" method="post"
                                              style="display:inline;"
                                              onsubmit="return confirm('Delete this user permanently?');">
                                            <input type="hidden" name="id" value="<%= u.getId() %>">
                                            <button type="submit" class="btn-small btn-delete">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <%     } // end for
                           } // end else %>
                        </tbody>
                    </table>
                </div>

                <a class="back-link" href="<%=ctx%>/AdminDashboardServlet">← Back to Dashboard</a>

            </div>
        </div>
    </div>
</div>

<div class="admin-footer">
    © 2026 - NothingHillBookshop. Your favorite online bookshop
</div>

</body>
</html>
