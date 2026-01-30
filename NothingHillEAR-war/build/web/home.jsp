<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // visitor can be guest (null) or logged in
    String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>NothingHillBookshop - Home</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">

        <style>
            /* Main wrapper card like screenshot */
            .home-card{
                background:#e9eef3;
                border-radius:16px;
                padding:42px 34px;
                box-shadow:0 8px 18px rgba(0,0,0,0.08);
                width: 980px;
                max-width:100%;
                margin: 0 auto;
            }

            .home-logo{
                display:flex;
                justify-content:center;
                margin-bottom: 16px;
            }
            .home-logo img{
                width: 420px;
                max-width: 95%;
            }

            .home-title{
                text-align:center;
                font-size: 58px;
                margin: 6px 0 10px 0;
                color:#2f3f4f;
                font-weight: 700;
                letter-spacing: 1px;
            }

            .home-sub{
                text-align:center;
                margin: 0 0 12px 0;
                color:#2f3f4f;
                font-size: 18px;
                opacity: 0.95;
            }

            .line{
                height:1px;
                background: rgba(47,63,79,0.22);
                margin: 22px 0;
            }

            .home-mid{
                text-align:center;
                color:#2f3f4f;
                opacity:0.95;
                margin: 0 0 18px 0;
                font-size: 15px;
            }

            .btn-yellow{
                display:inline-flex;
                align-items:center;
                gap:10px;
                background:#f6b10a;
                color:#1e2a35;
                border:none;
                padding: 14px 22px;
                border-radius:4px;
                font-weight: 900;
                cursor:pointer;
                text-decoration:none;
                min-width: 200px;
                justify-content:center;
                box-shadow: 0 6px 14px rgba(0,0,0,0.12);
            }
            .btn-yellow:hover{
                filter: brightness(0.97);
            }

            /* Explore section */
            .section-wrap{
                background:#fff;
                border-radius:14px;
                padding: 28px 28px 34px 28px;
                width: 980px;
                max-width:100%;
                margin: 26px auto 0 auto;
                box-shadow:0 8px 18px rgba(0,0,0,0.08);
            }

            .section-title{
                font-size: 30px;
                color:#2f3f4f;
                font-weight: 900;
                margin: 0 0 12px 0;
            }

            .section-line{
                height:1px;
                background: rgba(47,63,79,0.14);
                margin: 12px 0 22px 0;
            }

            .grid3{
                display:grid;
                grid-template-columns: 1fr 1fr 1fr;
                gap: 18px;
            }

            .box{
                border-radius: 12px;
                padding: 26px 24px;
                min-height: 200px;
                position: relative;
                overflow:hidden;
            }

            .box h3{
                margin:0;
                font-size: 30px;
                font-weight: 900;
                color:#fff;
            }

            .box p{
                margin: 12px 0 20px 0;
                color:#fff;
                line-height: 1.6;
                opacity:0.95;
                font-size: 15px;
            }

            .box .smallbtn{
                display:inline-block;
                padding: 10px 16px;
                border-radius: 4px;
                border: 1px solid rgba(255,255,255,0.35);
                background: rgba(255,255,255,0.08);
                color:#fff;
                font-weight: 900;
                text-decoration:none;
            }

            .icon{
                position:absolute;
                right: 18px;
                top: 18px;
                font-size: 22px;
                opacity: 0.7;
            }

            .box1{
                background:#2f3f4f;
            }
            .box2{
                background:#4d6a84;
            }
            .box3{
                background:#f6b10a;
            }

            .box3 h3, .box3 p{
                color:#1e2a35;
            }
            .box3 .smallbtn{
                border: 1px solid rgba(30,42,53,0.30);
                background: rgba(255,255,255,0.22);
                color:#1e2a35;
            }

            .footerbar{
                margin-top: 28px;
                background:#2f3f4f;
                color:#fff;
                text-align:center;
                padding: 14px 10px;
                border-radius: 0 0 10px 10px;
            }

            /* responsive */
            @media (max-width: 900px){
                .grid3{
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>

        <div class="page">

            <!-- SIDEBAR -->
            <div class="sidebar">
                <div class="logo-box">
                    <img src="<%=request.getContextPath()%>/images/logo.jpg" alt="The Nothing Hill Bookshop">
                </div>

                <div class="menu">
                    <a class="active" href="<%=request.getContextPath()%>/home.jsp"><span>🏠</span> Home</a>
                    <a href="<%=request.getContextPath()%>/BooksServlet"><span>📖</span> Books</a>
                    <a href="<%=request.getContextPath()%>/about.jsp"><span>ℹ️</span> About</a>
                    <a href="<%=request.getContextPath()%>/CartServlet"><span>🛒</span> Cart</a>

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

            <!-- MAIN -->
            <div class="main">
                <div class="center-col">

                    <!-- TOP HOME CARD -->
                    <div class="home-card">
                        <div class="home-logo">
                            <img src="<%=request.getContextPath()%>/images/logo.jpg" alt="The Nothing Hill Bookshop">
                        </div>

                        <!-- TITLE ALL CAPS -->
                        <div class="home-title">WELCOME TO NOTHINGHILLBOOKSHOP</div>
                        <div class="home-sub">A cosy new home for readers and beautiful books.</div>

                        <div class="line"></div>

                        <div class="home-mid">
                            Discover our curated collection of fiction, non-fiction and children's favourites.
                        </div>

                        <div style="text-align:center;">
                            <a class="btn-yellow" href="<%=request.getContextPath()%>/BooksServlet">📖 Browse Books</a>
                        </div>
                    </div>

                    <!-- EXPLORE SECTION -->
                    <div class="section-wrap">
                        <div class="section-title">Explore Our Collection</div>
                        <div class="section-line"></div>

                        <div class="grid3">

                            <div class="box box1">
                                <div class="icon">✨</div>
                                <h3>Latest Books</h3>
                                <p>Fresh arrivals straight to our shelves – new releases and recent favourites.</p>
                                <a class="smallbtn" href="<%=request.getContextPath()%>/BooksServlet">View Latest</a>
                            </div>

                            <div class="box box2">
                                <div class="icon">📖</div>
                                <h3>Top Sellers</h3>
                                <p>Books our readers can’t stop talking about – best-selling titles across genres.</p>
                                <a class="smallbtn" href="<%=request.getContextPath()%>/BooksServlet">View Top Sellers</a>
                            </div>

                            <div class="box box3">
                                <div class="icon">🏷️</div>
                                <h3>Special Offers</h3>
                                <p>Handpicked bargains, gift ideas and limited-time discounts on selected books.</p>
                                <a class="smallbtn" href="<%=request.getContextPath()%>/BooksServlet">View Offers</a>
                            </div>

                        </div>
                    </div>

                    <div class="footerbar">
                        © 2026 - NothingHillBookshop. Your favorite online bookshop
                    </div>

                </div>
            </div>

        </div>

    </body>
</html>
