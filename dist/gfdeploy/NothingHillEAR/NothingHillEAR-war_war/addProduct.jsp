<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String error = (String) session.getAttribute("error");
    String success = (String) session.getAttribute("success");
    session.removeAttribute("error");
    session.removeAttribute("success");

    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Add Product - Admin</title>
  <link rel="stylesheet" href="<%= ctx %>/css/style.css">
  <style>
    .wrap { max-width:1100px; margin: 28px auto; }
    .card { background:#fff;padding:22px;border-radius:10px; box-shadow:0 8px 18px rgba(0,0,0,0.06); }
    h2 { font-size:24px; color:#2f3f4f; font-weight:900; margin:0 0 12px 0; }
    label { display:block; margin-bottom:6px; font-weight:800; color:#2f3f4f; }
    input[type=text], input[type=number], textarea, select { width:100%; padding:12px; border:1px solid #e6edf0; border-radius:6px; box-sizing:border-box; }
    .row { display:flex; gap:12px; margin-bottom:12px; }
    .col { flex:1; }
    .btn { padding:12px 20px; border-radius:8px; border:none; cursor:pointer; font-weight:900; }
    .btn-primary { background:#233540; color:#fff; }
    .btn-success { background:#1fa06a; color:#fff; }
    .msg-error{ background:#ffdede; color:#8b1c1c; padding:12px; border-radius:6px; margin-bottom:12px; }
    .msg-success{ background:#e6f7ea; color:#1b7b3a; padding:12px; border-radius:6px; margin-bottom:12px; }
    .return-link { display:inline-block; margin-top:12px; font-weight:800; color:#6b2b9f; text-decoration:none; }
    @media (max-width:900px) { .row { flex-direction:column; } }
  </style>
</head>
<body>

<div class="wrap">
  <div class="card">
      <div style="display:flex; justify-content:space-between; align-items:center;">
          <h2>Add New Product</h2>
          <div>
              <a href="<%= ctx %>/Admin/ManageProducts">
                  <button type="button" class="btn btn-success">Back to Manage Products</button>
              </a>
          </div>
      </div>

      <hr style="border:none; height:1px; background:#f0f2f4; margin:12px 0 18px 0;">

      <% if (error != null) { %>
          <div class="msg-error"><%= error %></div>
      <% } else if (success != null) { %>
          <div class="msg-success"><%= success %></div>
      <% } %>

      <form action="<%= ctx %>/AddProductServlet" method="post" style="margin-top:6px;">
          <div class="row">
              <div class="col">
                  <label>Product Name</label>
                  <input type="text" name="title" required
                         value="<%= (request.getParameter("title") == null) ? "" : request.getParameter("title") %>">
              </div>
              <div class="col">
                  <label>Author</label>
                  <input type="text" name="author"
                         value="<%= (request.getParameter("author") == null) ? "" : request.getParameter("author") %>">
              </div>
          </div>

          <div style="margin-bottom:12px;">
              <label>Description</label>
              <textarea name="description" rows="5"><%= (request.getParameter("description") == null) ? "" : request.getParameter("description") %></textarea>
          </div>

          <div class="row">
              <div class="col">
                  <label>Price (e.g. 25.00)</label>
                  <input type="text" name="price" required
                         value="<%= (request.getParameter("price") == null) ? "" : request.getParameter("price") %>">
              </div>
              <div class="col">
                  <label>Stock Quantity</label>
                  <input type="number" name="stock" min="0"
                         value="<%= (request.getParameter("stock") == null) ? "0" : request.getParameter("stock") %>">
              </div>
          </div>

          <div style="margin-bottom:12px;">
              <label>Category</label>
              <input type="text" name="category"
                     value="<%= (request.getParameter("category") == null) ? "General" : request.getParameter("category") %>">
              <small style="color:#7b8b92;">Type new category name or keep 'General'</small>
          </div>

          <div style="margin-bottom:12px;">
              <label>Image URL (optional)</label>
              <input type="text" name="image"
                     value="<%= (request.getParameter("image") == null) ? "" : request.getParameter("image") %>">
          </div>

          <div style="display:flex; align-items:center; gap:12px; margin-bottom:22px;">
              <%
                  // default checked true
                  String activeParam = request.getParameter("active");
                  String checked = (activeParam == null) ? "checked" : "checked";
              %>
              <input type="checkbox" id="active" name="active" <%= checked %> >
              <label for="active" style="margin:0;">Product is Active</label>
          </div>

          <div style="display:flex; gap:12px;">
              <button class="btn btn-primary" type="submit">Add Product</button>
              <a class="return-link" href="<%= ctx %>/adminDashboard.jsp">← Back to Dashboard</a>
          </div>
      </form>
  </div>
</div>

</body>
</html>
