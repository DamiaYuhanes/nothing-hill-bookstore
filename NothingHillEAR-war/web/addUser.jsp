<%-- 
    Document   : addUser
    Created on : 18 Jan 2026, 7:11:09 pm
    Author     : Damia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add User</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
    <style>
        .wrap{ max-width:900px; margin: 26px auto; padding: 0 16px; }
        .card{ background:#fff; border-radius:12px; box-shadow:0 10px 22px rgba(0,0,0,0.08); padding:20px; }
        label{ display:block; margin:10px 0 6px; font-weight:900; }
        input, select{ width:100%; padding:10px; border:1px solid #e6edf0; border-radius:8px; }
        .row{ display:flex; gap:12px; }
        .col{ flex:1; }
        .btn{ padding:10px 16px; border:none; border-radius:8px; font-weight:900; cursor:pointer; }
        .btn-green{ background:#1fa06a; color:#fff; }
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">
        <h2>Add New User</h2>

        <form method="post" action="<%= ctx %>/Admin/AddUser">
            <label>Name</label>
            <input type="text" name="name" required>

            <label>Email</label>
            <input type="text" name="email" required>

            <label>Password</label>
            <input type="text" name="password" required>

            <div class="row">
                <div class="col">
                    <label>Role</label>
                    <select name="role">
                        <option value="CUSTOMER">CUSTOMER</option>
                        <option value="ADMIN">ADMIN</option>
                    </select>
                </div>
                <div class="col" style="display:flex; align-items:center; gap:10px; margin-top:34px;">
                    <input type="checkbox" name="active" checked style="width:auto;">
                    <span>Active</span>
                </div>
            </div>

            <div style="margin-top:14px; display:flex; gap:12px;">
                <button class="btn btn-green" type="submit">Create User</button>
                <a href="<%= ctx %>/Admin/ManageUsers">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
