<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle != null ? pageTitle : 'Codegnan E-Commerce | Extraordinary Shopping'}" /></title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5.3.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons & FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

    <!-- Custom CSS Design System -->
    <link rel="stylesheet" href="/styles.css">

    <!-- Razorpay Checkout Script -->
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>

    <!-- Canvas Confetti -->
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.9.2/dist/confetti.browser.min.js"></script>

    <!-- Chart.js (for Admin Dashboard) -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
</head>
<body>

    <!-- Top Announcement Bar -->
    <div class="announcement-bar text-center">
        <span>🧸 <strong>TOY CARNIVAL:</strong> Use code <strong>FESTIVE20</strong> for 20% OFF | Free Express Delivery on Toys over ₹499! 🚀</span>
    </div>

    <!-- Main Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-custom">
        <div class="container">
            <!-- Brand Logo -->
            <a class="brand-logo" href="/products">
                <div class="brand-icon-badge">
                    <i class="bi bi-rocket-takeoff-fill"></i>
                </div>
                <span>Toy<span class="brand-gradient-text">Store</span></span>
            </a>

            <!-- Mobile Toggle -->
            <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
                <i class="bi bi-list fs-2"></i>
            </button>

            <!-- Navbar Links & Actions -->
            <div class="collapse navbar-collapse" id="navbarMain">
                <!-- Live Search Bar -->
                <div class="mx-auto my-2 my-lg-0 search-form">
                    <i class="bi bi-search search-icon"></i>
                    <input type="text" id="liveProductSearch" class="form-control search-input" placeholder="Search LEGO, action figures, plushies, RC cars, board games..." value="${currentSearch}">
                </div>

                <ul class="navbar-nav align-items-lg-center gap-2 ms-auto">
                    <!-- Explore Catalog -->
                    <li class="nav-item">
                        <a class="nav-link fw-semibold px-3" href="/products">
                            <i class="bi bi-grid-fill me-1 text-primary"></i> Catalog
                        </a>
                    </li>

                    <c:if test="${loggedInUser != null}">
                        <!-- My Orders -->
                        <li class="nav-item">
                            <a class="nav-link fw-semibold px-3" href="/orders">
                                <i class="bi bi-box-seam-fill me-1 text-primary"></i> My Orders
                            </a>
                        </li>
                    </c:if>

                    <!-- Cart Button with Live Counter -->
                    <li class="nav-item">
                        <a href="/cart" class="nav-pill-btn">
                            <i class="bi bi-cart3 fs-5"></i>
                            <span>Cart</span>
                            <span class="cart-btn-badge cart-counter-badge ${sessionScope.cartItems == null || sessionScope.cartItems.size() == 0 ? 'd-none' : ''}">
                                ${sessionScope.cartItems != null ? sessionScope.cartItems.size() : 0}
                            </span>
                        </a>
                    </li>

                    <!-- Dark / Light Mode Toggle -->
                    <li class="nav-item ms-lg-1">
                        <button class="theme-toggle-btn" title="Toggle Light/Dark Theme">
                            <i class="bi bi-moon-stars-fill theme-toggle-icon"></i>
                        </button>
                    </li>

                    <!-- User Profile / Auth State -->
                    <c:choose>
                        <c:when test="${loggedInUser != null}">
                            <li class="nav-item dropdown ms-lg-2">
                                <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" role="button" data-bs-toggle="dropdown">
                                    <div class="user-avatar-badge">
                                        ${loggedInUser.username.substring(0, 1).toUpperCase()}
                                    </div>
                                    <div class="text-start d-none d-md-block">
                                        <span class="fw-bold small d-block">${loggedInUser.username}</span>
                                        <span class="badge ${loggedInUser.role == 'ADMIN' ? 'bg-danger' : 'bg-primary'} py-0 px-2" style="font-size: 0.65rem;">
                                            ${loggedInUser.role}
                                        </span>
                                    </div>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-4 mt-2">
                                    <li class="px-3 py-2 border-bottom">
                                        <div class="fw-bold">${loggedInUser.username}</div>
                                        <div class="text-muted small">${loggedInUser.email != null ? loggedInUser.email : 'Customer'}</div>
                                    </li>
                                    <c:if test="${loggedInUser.role == 'ADMIN'}">
                                        <li>
                                            <a class="dropdown-item py-2 fw-semibold text-primary" href="/admin/dashboard">
                                                <i class="bi bi-speedometer2 me-2"></i> Admin Dashboard
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item py-2" href="/products/add">
                                                <i class="bi bi-plus-circle me-2"></i> Add Product
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item py-2" href="/users">
                                                <i class="bi bi-people me-2"></i> Manage Users
                                            </a>
                                        </li>
                                        <li><hr class="dropdown-divider"></li>
                                    </c:if>
                                    <li>
                                        <a class="dropdown-item py-2" href="/orders">
                                            <i class="bi bi-clock-history me-2"></i> Order History
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item py-2 text-danger fw-semibold" href="/logout">
                                            <i class="bi bi-box-arrow-right me-2"></i> Sign Out
                                        </a>
                                    </li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item ms-lg-2 d-flex gap-2">
                                <a href="/login" class="btn-modern-outline py-2 px-3">
                                    <i class="bi bi-box-arrow-in-right"></i> Sign In
                                </a>
                                <a href="/login?tab=register" class="btn-modern-primary py-2 px-3">
                                    <i class="bi bi-person-plus"></i> Join
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Global Toast / Flash Notifications -->
    <div class="container mt-3">
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show rounded-4 shadow-sm border-0 d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                <div><strong>Success!</strong> ${success}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-4 shadow-sm border-0 d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                <div><strong>Notice:</strong> ${error}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty info}">
            <div class="alert alert-info alert-dismissible fade show rounded-4 shadow-sm border-0 d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-info-circle-fill fs-5 text-info"></i>
                <div>${info}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
    </div>

    <!-- Main Page Content Wrapper Starts -->
    <main class="main-content">
