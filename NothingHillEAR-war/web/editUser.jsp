<%-- 
    Document   : editUser
    Created on : 18 Jan 2026, 7:11:59 pm
    Author     : Damia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.UserDTO"%>

<%
    String roleSession = (String) session.getAttribute("userRole");
    if (roleSession == null || !"ADMIN".equalsIgnoreCase(roleSession)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String ctx = request.getContextPath();
    UserDTO u = (UserDTO) request.getAttribute("user");
    if (u == null) {
        response.sendRedirect(ctx + "/Admin/ManageUsers");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit User</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
    <style>
        body{ background:#f4f6f9; }
        .wrap{ max-width:900px; margin:18px auto; padding:0 16px; }
        .card{
            background:#fff; border-radius:16px;
            box-shadow:0 14px 30px rgba(16,24,40,.10);
            padding:18px;
        }
        h2{ margin:0 0 12px 0; font-size:28px; font-weight:900; color:#233040; }
        label{ display:block; margin:10px 0 6px 0; font-weight:900; color:#233040; }
        input, select{
            width:100%; padding:12px; border:1px solid #e6edf0;
            border-radius:10px; box-sizing:border-box;
        }
        .row{ display:flex; gap:12px; }
        .col{ flex:1; }
        .btn{
            padding:12px 18px; border:0; border-radius:12px;
            font-weight:900; cursor:pointer;
        }
        .btn-save{ background:#1e6bd6; color:#fff; }
        .btn-back{ background:#eef2f6; color:#233040; text-decoration:none; display:inline-flex; align-items:center; }
        .actions{ display:flex; gap:10px; margin-top:14px; align-items:center; }
        .small{ color:#6b7a8a; font-size:12px; margin-top:4px; }
    </style>
</head>
<body>

<div class="wrap">
    <div class="card">
        <h2>✏ Edit User</h2>

        <form action="<%= ctx %>/Admin/EditUser" method="post">
            <input type="hidden" name="id" value="<%= u.getId() %>">

            <label>Name</label>
            <input type="text" name="name" required value="<%= u.getName()==null?"":u.getName() %>">

            <label>Email</label>
            <input type="text" name="email" required value="<%= u.getEmail()==null?"":u.getEmail() %>">

            <label>Password (optional)</label>
            <input type="text" name="password" placeholder="Leave blank to keep current password">
            <div class="small">If you leave blank, the password will not change.</div>

            <div class="row">
                <div class="col">
                    <label>Role</label>
                    <select name="role">
                        <option value="CUSTOMER" <%= "CUSTOMER".equalsIgnoreCase(u.getRole())?"selected":"" %>>CUSTOMER</option>
                        <option value="ADMIN" <%= "ADMIN".equalsIgnoreCase(u.getRole())?"selected":"" %>>ADMIN</option>
                    </select>
                </div>
                <!-- Status / Active controls removed -->
            </div>

            <div class="actions">
                <button class="btn btn-save" type="submit">Save Changes</button>
                <a class="btn btn-back" href="<%= ctx %>/Admin/ManageUsers">← Back</a>
            </div>
        </form>
    </div>
</div>

</body>
</html>
