<%-- 
    Document   : webpages
    Created on : 16 Jan 2026, 9:26:28 am
    Author     : Damia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%-- REMOVE THIS BLOCK if you want About page to be PUBLIC --%>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>NothingHillBookshop - About</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">

    <style>
        .content-card{
            background:#fff;
            border-radius:10px;
            box-shadow:0 8px 18px rgba(0,0,0,0.08);
            padding:34px 40px;
            width: 980px;
            max-width:100%;
            margin: 0 auto;
        }

        .about-logo{
            display:flex;
            justify-content:center;
            margin-bottom: 16px;
        }

        .about-logo img{
            width: 420px;
            max-width: 95%;
        }

        .title{
            text-align:center;
            font-size:38px;
            letter-spacing:1px;
            margin: 10px 0 14px 0;
            color:#2f3f4f;
            font-weight:800;
        }

        .line{
            height:1px;
            background: rgba(47,63,79,0.18);
            margin: 22px 0;
        }

        .para{
            color:#2f3f4f;
            font-size:16px;
            line-height:1.7;
            max-width: 760px;
            margin: 0 auto;
            text-align: center;
        }

        .section{
            max-width: 760px;
            margin: 28px auto 0 auto;
        }

        .section h3{
            color:#2f3f4f;
            margin: 0 0 10px 0;
            font-size: 22px;
        }

        .section p{
            margin: 0;
            color:#2f3f4f;
            line-height: 1.8;
            font-size: 15px;
        }

        .grid{
            max-width: 920px;
            margin: 26px auto 0 auto;
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .box{
            border:1px solid rgba(47,63,79,0.15);
            border-radius:6px;
            padding:18px 18px;
            background:#fff;
        }

        .box h4{
            margin:0 0 8px 0;
            color:#2f3f4f;
            font-size: 18px;
        }

        .box p{
            margin:0;
            color:#2f3f4f;
            line-height: 1.7;
            font-size: 14px;
        }

        .cta{
            text-align:center;
            margin-top: 30px;
            color:#2f3f4f;
        }

        .btn-row{
            display:flex;
            justify-content:center;
            gap: 18px;
            margin-top: 14px;
        }

        .btn-dark{
            background:#2f3f4f;
            color:#fff;
            border:none;
            padding: 12px 18px;
            border-radius: 4px;
            font-weight: 800;
            cursor:pointer;
            min-width: 160px;
        }

        .btn-light{
            background: transparent;
            color:#2f3f4f;
            border:1px solid rgba(47,63,79,0.55);
            padding: 12px 18px;
            border-radius: 4px;
            font-weight: 800;
            cursor:pointer;
            min-width: 200px;
        }

        .footerbar{
            margin-top: 34px;
            background:#2f3f4f;
            color:#fff;
            text-align:center;
            padding: 14px 10px;
            border-radius: 0 0 10px 10px;
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
            <a href="home.jsp"><span>🏠</span> Home</a>
            <a href="#"><span>📖</span> Books</a>
            <a class="active" href="about.jsp"><span>ℹ️</span> About</a>
            <a href="#"><span>🛒</span> Cart</a>
            <a href="register.jsp"><span>📝</span> Register</a>
            <a href="LogoutServlet"><span>🚪</span> Logout</a>
        </div>
    </div>

    <!-- MAIN -->
    <div class="main">
        <div class="center-col">

            <div class="content-card">

                <div class="about-logo">
                    <img src="<%=request.getContextPath()%>/images/logo.jpg" alt="The Nothing Hill Bookshop">
                </div>

                <div class="title">ABOUT THE NOTHING HILL BOOKSHOP</div>

                <div class="line"></div>

                <div class="para">
                    NothingHillBookshop is a newly opened independent bookstore created for readers who love
                    quiet corners, beautiful shelves, and good conversation. We combine the warmth of a
                    neighbourhood shop with the convenience of an online catalogue.
                </div>

                <div class="section">
                    <h3>Our Story</h3>
                    <p>
                        The bookshop began with a simple idea: build a place where every visit feels like discovering
                        a new favourite book. Our team handpicks each title, focusing on stories that stay with you,
                        thoughtful non-fiction, and books that make perfect gifts.
                    </p>
                </div>

                <div class="section">
                    <h3>Our Vision</h3>
                    <p>
                        We want NothingHillBookshop to be the first place you think of when you want a new story,
                        a thoughtful gift, or a quiet moment with a book. Our vision is to grow a community of readers,
                        host small events and recommendations, and make it simple to support a local bookstore even
                        when you are shopping online.
                    </p>
                </div>

                <div class="section">
                    <h3>Our Team</h3>
                    <p>
                        Our team is small but passionate: booksellers, students and lifelong readers who enjoy matching
                        people with the right book. We test our recommendations, share what we are reading, and are always
                        happy to talk about your next favourite author.
                    </p>
                </div>

                <div class="section" style="margin-top:34px;">
                    <h3 style="text-align:center;">What Sets Us Apart</h3>
                </div>

                <div class="grid">
                    <div class="box">
                        <h4>Curated Selection</h4>
                        <p>Every shelf is selected by our booksellers, not an algorithm. We keep our range focused so it is easier to find something genuinely worth reading.</p>
                    </div>
                    <div class="box">
                        <h4>Secure Shopping</h4>
                        <p>Whether you buy in-store or online, your details are protected with modern handling of customer information.</p>
                    </div>
                    <div class="box">
                        <h4>Competitive Pricing</h4>
                        <p>We keep our prices fair and run regular promotions so building your personal library stays affordable for students and families.</p>
                    </div>
                    <div class="box">
                        <h4>Expert Support</h4>
                        <p>Need a recommendation or a special order? Our team is ready to help you choose the right book, from quick reads to long-form classics.</p>
                    </div>
                </div>

                <div class="cta">
                    <div style="font-size:18px; margin-top:30px;">
                        Ready to explore? Browse our catalogue or visit the shop and become part of the NothingHillBookshop story.
                    </div>

                    <div class="btn-row">
                        <form action="#" method="get">
                            <button class="btn-dark" type="submit">Browse Books</button>
                        </form>

                        <form action="#" method="get">
                            <button class="btn-light" type="submit">Join Our Community</button>
                        </form>
                    </div>
                </div>

                <div class="footerbar">
                    © 2026 - NothingHillBookshop. Your favorite online bookshop
                </div>

            </div>

        </div>
    </div>

</div>

</body>
</html>
