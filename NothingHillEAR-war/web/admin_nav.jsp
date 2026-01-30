<%-- admin_nav.jsp : shared admin sidebar --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    boolean isAdmin = false;
    if (session != null) {
        Object r = session.getAttribute("userRole");
        if (r != null && "ADMIN".equalsIgnoreCase(r.toString())) {
            isAdmin = true;
        }
    }
%>

<% if (isAdmin) { %>
<style>
/* Admin sidebar: slim white panel, fixed to left, similar to your second screenshot */
.admin-sidebar {
  width: 240px;
  min-height: 100vh;
  box-sizing: border-box;
  background: #ffffff;
  border-right: 1px solid #d4dde5;
  padding: 20px 18px;
  display: flex;
  flex-direction: column;
}

.admin-sidebar .logo-box {
  text-align: center;
  margin-bottom: 20px;
}
.admin-sidebar .logo-box img {
  max-width: 170px;
  display: block;
  margin: 0 auto;
}

.admin-top {
  display:flex;
  justify-content:space-between;
  align-items:center;
  gap:10px;
  margin-bottom: 16px;
}
.admin-top-left {
  font-weight: 900;
  color: #2f3f4f;
}
.admin-top-right {
  font-size: 12px;
  color: #9aa7b0;
  font-weight: 700;
}

.admin-menu {
  flex: 1;
}

.admin-menu a {
  display:block;
  padding: 10px 12px;
  color:#2f3f4f;
  font-weight:800;
  text-decoration:none;
  margin-bottom:8px;
  border-radius:999px;
  transition: background 0.15s ease, color 0.15s ease;
  font-size: 14px;
}
.admin-menu a span {
  margin-right:8px;
}
.admin-menu a.active,
.admin-menu a:hover {
  background:#2f3f4f;
  color:#ffffff;
}

.admin-sidebar-footer {
  margin-top: 10px;
  font-size: 11px;
  color:#9aa7b0;
  text-align:center;
}
</style>

<div class="admin-sidebar">
  <div>
    <div class="logo-box">
      <img src="<%= request.getContextPath() %>/images/logo.jpg" alt="NothingHillBookshop">
    </div>

    <div class="admin-top">
      <div class="admin-top-left">Admin</div>
      <div class="admin-top-right">Signed in</div>
    </div>

    <div class="admin-menu">
      <a class="active" href="<%= request.getContextPath() %>/AdminDashboardServlet">
        <span>⚙️</span> Admin Dashboard
      </a>
      <a href="<%= request.getContextPath() %>/BooksServlet">
        <span>📖</span> Books
      </a>
      <a href="<%= request.getContextPath() %>/LogoutServlet">
        <span>🚪</span> Log out
      </a>
    </div>
  </div>

  <div class="admin-sidebar-footer">
    NothingHillBookshop Admin
  </div>
</div>
<% } %>
