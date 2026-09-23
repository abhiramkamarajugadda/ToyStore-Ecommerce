<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Explore Products | Codegnan E-Commerce" scope="request"/>
<jsp:include page="header.jsp" />

<div class="container py-4">

    <!-- Hero Promotional Banner Carousel -->
    <div id="heroCarousel" class="carousel slide hero-banner" data-bs-ride="carousel">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
        </div>
        <div class="carousel-inner">
            <!-- Slide 1 -->
            <div class="carousel-item active">
                <div class="hero-slide-bg" style="background-image: url('https://images.unsplash.com/photo-1585366119957-e9730b6d0f60?w=1200&auto=format&fit=crop&q=80');">
                    <div class="hero-content">
                        <span class="hero-tag"><i class="bi bi-stars text-warning me-1"></i> Ultimate Toy Festival</span>
                        <h1 class="display-5 fw-bold text-white mb-2">LEGO, RC Cars & Action Sets</h1>
                        <p class="text-white-50 fs-6 mb-4">Discover the magic of play with top-tier building sets, remote control monster trucks, and high-speed stunt racers up to 40% OFF!</p>
                        <a href="#catalogSection" class="btn btn-modern-primary py-2 px-4 fs-6">
                            <i class="bi bi-rocket-takeoff-fill"></i> Explore Toys
                        </a>
                    </div>
                </div>
            </div>
            <!-- Slide 2 -->
            <div class="carousel-item">
                <div class="hero-slide-bg" style="background-image: url('https://images.unsplash.com/photo-1535378620166-273708d44e4c?w=1200&auto=format&fit=crop&q=80');">
                    <div class="hero-content">
                        <span class="hero-tag"><i class="bi bi-lightbulb-fill text-info me-1"></i> STEM & Smart Learning</span>
                        <h1 class="display-5 fw-bold text-white mb-2">Robotics, Puzzles & Science</h1>
                        <p class="text-white-50 fs-6 mb-4">Spark creativity and problem-solving skills with hands-on robotic kits, solar racers, and Montessori wooden toys.</p>
                        <a href="#catalogSection" class="btn btn-modern-primary py-2 px-4 fs-6">
                            <i class="bi bi-cpu-fill"></i> Shop STEM Toys
                        </a>
                    </div>
                </div>
            </div>
            <!-- Slide 3 -->
            <div class="carousel-item">
                <div class="hero-slide-bg" style="background-image: url('https://images.unsplash.com/photo-1559454403-b8fb88521f11?w=1200&auto=format&fit=crop&q=80');">
                    <div class="hero-content">
                        <span class="hero-tag"><i class="bi bi-heart-fill text-danger me-1"></i> Cuddle & Collectibles</span>
                        <h1 class="display-5 fw-bold text-white mb-2">Fluffy Plushies & Dollhouses</h1>
                        <p class="text-white-50 fs-6 mb-4">Super-soft giant teddy bears, fairytale dollhouses, and family board games crafted for endless joy.</p>
                        <a href="#catalogSection" class="btn btn-modern-primary py-2 px-4 fs-6">
                            <i class="bi bi-gift-fill"></i> Claim Offers
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>

    <!-- Header / Admin Action Bar -->
    <div id="catalogSection" class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4 pt-2">
        <div>
            <h2 class="h3 fw-bold mb-1">Explore Toy Wonderland</h2>
            <p class="text-muted small mb-0">Premium quality toys, games, and learning kits loved by kids and parents</p>
        </div>

        <c:if test="${loggedInUser != null && loggedInUser.role == 'ADMIN'}">
            <div class="d-flex gap-2">
                <a href="/products/add" class="btn-modern-primary py-2 px-3">
                    <i class="bi bi-plus-circle-fill"></i> Add New Toy
                </a>
                <a href="/admin/dashboard" class="btn-modern-outline py-2 px-3">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
            </div>
        </c:if>
    </div>

    <!-- Category Filter Chips -->
    <div class="category-filter-scroll mb-4">
        <button class="category-chip category-chip-btn ${currentCategory == 'ALL' || currentCategory == null ? 'active' : ''}" data-category="all">
            <i class="bi bi-grid-fill"></i> All Toys
        </button>
        <button class="category-chip category-chip-btn ${currentCategory == 'Action & Vehicles' ? 'active' : ''}" data-category="action & vehicles">
            <i class="bi bi-car-front-fill"></i> Action & Vehicles
        </button>
        <button class="category-chip category-chip-btn ${currentCategory == 'Building & Construction' ? 'active' : ''}" data-category="building & construction">
            <i class="bi bi-bricks"></i> Building & LEGO
        </button>
        <button class="category-chip category-chip-btn ${currentCategory == 'Plush & Dolls' ? 'active' : ''}" data-category="plush & dolls">
            <i class="bi bi-balloon-heart-fill"></i> Plush & Dolls
        </button>
        <button class="category-chip category-chip-btn ${currentCategory == 'Educational & STEM' ? 'active' : ''}" data-category="educational & stem">
            <i class="bi bi-lightbulb-fill"></i> Educational & STEM
        </button>
        <button class="category-chip category-chip-btn ${currentCategory == 'Board Games & Puzzles' ? 'active' : ''}" data-category="board games & puzzles">
            <i class="bi bi-dice-5-fill"></i> Board Games & Puzzles
        </button>
        <button class="category-chip category-chip-btn ${currentCategory == 'Outdoor & Sports' ? 'active' : ''}" data-category="outdoor & sports">
            <i class="bi bi-dribbble"></i> Outdoor & Sports
        </button>
    </div>

    <!-- Products Grid -->
    <div class="row g-4" id="productsGridContainer">
        <c:forEach var="product" items="${products}">
            <div class="col-xl-3 col-lg-4 col-md-6 product-item-col" 
                 data-name="${product.name}" 
                 data-desc="${product.description}" 
                 data-category="${product.category != null ? product.category.toLowerCase() : 'electronics'}"
                 data-price="${product.price}">
                <div class="product-card">
                    <!-- Product Image & Badge -->
                    <div class="product-image-wrapper">
                        <span class="product-badge-float bg-danger text-white shadow-sm">
                            <i class="bi bi-lightning-fill"></i> Sale
                        </span>
                        <img src="${product.displayImagePath}" 
                             class="product-img" 
                             alt="${product.name}"
                             onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=60'">
                    </div>

                    <!-- Product Body -->
                    <div class="p-3 d-flex flex-column flex-grow-1">
                        <div class="d-flex align-items-center justify-content-between mb-1">
                            <span class="product-category-tag">${product.category != null ? product.category : 'Electronics'}</span>
                            <div class="rating-stars">
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-half"></i>
                                <span class="small text-muted ms-1">4.8</span>
                            </div>
                        </div>

                        <h5 class="product-title" title="${product.name}">${product.name}</h5>
                        <p class="product-desc flex-grow-1">${product.description}</p>

                        <!-- Price Breakdown -->
                        <div class="product-price-box mb-3">
                            <span class="product-current-price">₹<fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                            <span class="product-strike-price">₹<fmt:formatNumber value="${product.price * 1.25}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                            <span class="product-discount-tag">20% OFF</span>
                        </div>

                        <!-- Card Action Buttons -->
                        <div class="pt-2 border-top">
                            <c:choose>
                                <c:when test="${loggedInUser != null && loggedInUser.role == 'ADMIN'}">
                                    <div class="d-flex gap-2">
                                        <a href="/products/edit/${product.id}" class="btn btn-modern-warning flex-grow-1 justify-content-center">
                                            <i class="bi bi-pencil-square"></i> Edit
                                        </a>
                                        <a href="/products/delete/${product.id}" 
                                           class="btn btn-modern-danger btn-confirm-delete flex-grow-1 justify-content-center"
                                           data-item-name="${product.name}">
                                            <i class="bi bi-trash"></i> Delete
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <form action="/cart/add" method="post" class="d-flex align-items-center gap-2">
                                        <input type="hidden" name="productId" value="${product.id}">
                                        
                                        <!-- Quantity Stepper -->
                                        <div class="qty-stepper">
                                            <button type="button" class="qty-btn qty-btn-minus">-</button>
                                            <input type="number" name="quantity" value="1" min="1" max="99" class="qty-input">
                                            <button type="button" class="qty-btn qty-btn-plus">+</button>
                                        </div>

                                        <button type="submit" class="btn btn-modern-primary flex-grow-1">
                                            <i class="bi bi-cart-plus-fill"></i> Add to Cart
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Empty State Box (When filter matches 0 items) -->
    <div id="noProductsFound" class="text-center py-5 my-4 modern-card animate-fade-in" style="display: ${empty products ? 'block' : 'none'};">
        <div class="mb-3">
            <i class="bi bi-search fs-1 text-muted"></i>
        </div>
        <h4 class="fw-bold">No Products Found</h4>
        <p class="text-muted">We couldn't find any products matching your current query or category.</p>
        <a href="/products" class="btn btn-modern-primary mt-2">
            <i class="bi bi-arrow-clockwise"></i> View All Products
        </a>
    </div>

</div>

<jsp:include page="footer.jsp" />