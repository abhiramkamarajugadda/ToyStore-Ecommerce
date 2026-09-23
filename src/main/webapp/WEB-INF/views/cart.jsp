<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Shopping Cart | Codegnan E-Commerce" scope="request"/>
<jsp:include page="header.jsp" />

<div class="container py-4">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h2 class="h3 fw-bold mb-1">Your Shopping Cart</h2>
            <p class="text-muted small mb-0">Review items before proceeding to secure payment</p>
        </div>
        <a href="/products" class="btn-modern-outline py-2 px-3">
            <i class="bi bi-arrow-left"></i> Continue Shopping
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty cartItems}">
            <div class="row g-4">
                <!-- Cart Items List (Left Column) -->
                <div class="col-lg-8">
                    <div class="modern-card p-4">
                        <div class="d-flex justify-content-between align-items-center pb-3 border-bottom mb-3">
                            <span class="fw-bold text-muted small text-uppercase">Items (${cartItems.size()})</span>
                            <a href="/cart/clear" class="text-danger small fw-semibold text-decoration-none" onclick="return confirm('Are you sure you want to clear your entire cart?');">
                                <i class="bi bi-trash3"></i> Clear Cart
                            </a>
                        </div>

                        <!-- Items List -->
                        <div class="cart-items-container">
                            <c:forEach var="item" items="${cartItems}">
                                <div class="cart-item-row">
                                    <img src="${item.product.displayImagePath}" 
                                         class="cart-item-thumb" 
                                         alt="${item.product.name}"
                                         onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=60'">

                                    <div class="flex-grow-1">
                                        <span class="product-category-tag" style="font-size: 0.72rem;">
                                            ${item.product.category != null ? item.product.category : 'General'}
                                        </span>
                                        <h6 class="fw-bold mb-1">${item.product.name}</h6>
                                        <div class="text-muted small mb-2">
                                            Unit Price: <strong>₹<fmt:formatNumber value="${item.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></strong>
                                        </div>

                                        <!-- Quantity Update Form -->
                                        <form action="/cart/update" method="post" class="d-flex align-items-center gap-2">
                                            <input type="hidden" name="productId" value="${item.product.id}">
                                            
                                            <div class="qty-stepper" style="background: var(--bg-surface); border-color: var(--border-subtle);">
                                                <a href="/cart/update?productId=${item.product.id}&action=decrease" class="qty-btn text-decoration-none text-center" title="Decrease">-</a>
                                                <input type="number" name="quantity" value="${item.quantity}" min="1" max="99" class="qty-input" onchange="this.form.submit()">
                                                <a href="/cart/update?productId=${item.product.id}&action=increase" class="qty-btn text-decoration-none text-center" title="Increase">+</a>
                                            </div>

                                            <a href="/cart/remove/${item.product.id}" class="btn text-danger p-1 ms-2" title="Remove item">
                                                <i class="bi bi-trash3 fs-5"></i>
                                            </a>
                                        </form>
                                    </div>

                                    <!-- Item Subtotal -->
                                    <div class="text-end ps-3">
                                        <div class="small text-muted">Subtotal</div>
                                        <span class="fs-5 fw-bold text-main">
                                            ₹<fmt:formatNumber value="${item.price * item.quantity}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                        </span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Order Summary & Checkout (Right Column) -->
                <div class="col-lg-4">
                    <div class="order-summary-card">
                        <h5 class="fw-bold mb-3">Order Summary</h5>

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Cart Subtotal</span>
                            <span class="fw-semibold" id="subtotalValueElem" data-subtotal="${totalPrice}">
                                ₹<fmt:formatNumber value="${totalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                            </span>
                        </div>

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Shipping</span>
                            <span class="text-success fw-semibold">FREE (Express)</span>
                        </div>

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Estimated GST (18%)</span>
                            <span class="text-muted">Included</span>
                        </div>

                        <!-- Dynamic Discount Row -->
                        <div id="discountSummaryRow" class="d-flex justify-content-between mb-2 text-success fw-bold d-none">
                            <span>Promo Discount</span>
                            <span id="discountAmountElem">- ₹0.00</span>
                        </div>

                        <hr class="my-3">

                        <!-- Coupon Code Box -->
                        <div class="mb-3">
                            <label class="small fw-bold text-muted mb-1">Have a Promo Code?</label>
                            <div class="coupon-input-group">
                                <input type="text" id="couponCodeInput" class="form-control rounded-pill border-subtle" placeholder="e.g. FESTIVE20 or SAVE10">
                                <button type="button" id="applyCouponBtn" class="btn btn-modern-outline rounded-pill px-3">
                                    Apply
                                </button>
                            </div>
                            <div class="small text-muted" style="font-size: 0.78rem;">
                                💡 Tip: Try <strong>FESTIVE20</strong> for 20% off or <strong>SAVE10</strong> for 10% off!
                            </div>
                        </div>

                        <hr class="my-3">

                        <!-- Final Total -->
                        <div class="d-flex justify-content-between align-items-baseline mb-4">
                            <span class="fs-5 fw-bold">Grand Total</span>
                            <span class="fs-3 fw-bold brand-gradient-text" id="finalTotalElem">
                                ₹<fmt:formatNumber value="${totalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                            </span>
                        </div>

                        <!-- Checkout Actions -->
                        <div class="d-grid gap-2">
                            <!-- Razorpay Payment Button -->
                            <button id="razorpayCheckoutBtn" class="btn btn-modern-primary py-3 fs-6">
                                <i class="bi bi-shield-lock-fill"></i> Pay via Razorpay
                            </button>

                            <!-- Direct Instant Checkout Form -->
                            <form action="/cart/checkout" method="post" class="d-grid">
                                <button type="submit" class="btn btn-modern-success py-2 fs-6">
                                    <i class="bi bi-bag-check-fill"></i> Direct 1-Click Order
                                </button>
                            </form>
                        </div>

                        <!-- Trust Seal -->
                        <div class="text-center mt-4 pt-3 border-top small text-muted">
                            <i class="bi bi-lock-fill text-success me-1"></i> 256-bit SSL Secure Checkout
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <%-- Empty Cart State --%>
            <div class="modern-card text-center py-5">
                <div class="mb-3 text-muted">
                    <i class="bi bi-cart-x fs-1"></i>
                </div>
                <h3 class="fw-bold mb-2">Your Cart is Empty</h3>
                <p class="text-muted mb-4">Looks like you haven't added any products to your shopping bag yet.</p>
                <a href="/products" class="btn btn-modern-primary py-2 px-4 fs-6">
                    <i class="bi bi-bag-plus-fill"></i> Start Exploring Catalog
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Razorpay Integration Script -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const rzpBtn = document.getElementById("razorpayCheckoutBtn");
        if (rzpBtn) {
            rzpBtn.addEventListener('click', function (e) {
                e.preventDefault();
                rzpBtn.disabled = true;
                rzpBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Preparing Payment...';

                fetch('/cart/razorpayOrder', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' }
                })
                .then(response => response.json())
                .then(data => {
                    rzpBtn.disabled = false;
                    rzpBtn.innerHTML = '<i class="bi bi-shield-lock-fill"></i> Pay via Razorpay';

                    if (data && data.id) {
                        const options = {
                            key: "***REMOVED***",
                            amount: data.amount,
                            currency: data.currency || "INR",
                            name: "Codegnan E-Commerce",
                            description: "Order Checkout Payment",
                            order_id: data.id,
                            handler: function (response) {
                                window.location.href = "/cart/payment-success";
                            },
                            prefill: {
                                name: "${loggedInUser != null ? loggedInUser.username : 'Customer'}",
                                email: "${loggedInUser != null ? loggedInUser.email : 'customer@example.com'}",
                                contact: "${loggedInUser != null ? loggedInUser.phone_number : '9876543210'}"
                            },
                            theme: { color: "#4f46e5" }
                        };
                        const razorpay = new Razorpay(options);
                        razorpay.open();
                    } else {
                        showToast('Checkout Notice', data.error || 'Razorpay Gateway is in test mode. You can also use Direct 1-Click Order.', 'info');
                    }
                })
                .catch(error => {
                    rzpBtn.disabled = false;
                    rzpBtn.innerHTML = '<i class="bi bi-shield-lock-fill"></i> Pay via Razorpay';
                    showToast('Gateway Notice', 'Test gateway initialized. Please use Direct 1-Click Order for instant simulation.', 'info');
                });
            });
        }
    });
</script>

<jsp:include page="footer.jsp" />
