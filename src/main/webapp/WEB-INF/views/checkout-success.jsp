<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Order Confirmed! | Codegnan E-Commerce" scope="request"/>
<jsp:include page="header.jsp" />

<div class="container py-5" style="max-width: 820px;" data-trigger-confetti="true">

    <!-- Celebration Header -->
    <div class="text-center mb-4">
        <div class="brand-icon-badge mx-auto mb-3" style="width: 64px; height: 64px; font-size: 2rem; background: var(--success-gradient);">
            <i class="bi bi-check2-all"></i>
        </div>
        <h2 class="display-6 fw-bold mb-2">Thank You for Your Order!</h2>
        <p class="text-muted">Your order has been placed successfully and is now being prepared for express delivery.</p>
    </div>

    <!-- Order Invoice Card -->
    <div class="invoice-card mb-4">
        <!-- Stamp -->
        <div class="invoice-badge-stamp">
            <i class="bi bi-shield-check me-1"></i> ${order.orderStatus}
        </div>

        <!-- Receipt Header Details -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom">
            <div>
                <span class="text-muted small text-uppercase fw-bold">Order Identifier</span>
                <h4 class="fw-bold mb-0 text-primary">#ORD-${order.id}</h4>
            </div>
            <div class="text-md-end mt-2 mt-md-0">
                <span class="text-muted small text-uppercase fw-bold">Order Date</span>
                <div class="fw-semibold">${order.formattedOrderDate}</div>
            </div>
        </div>

        <!-- Order Fulfillment Timeline Tracker -->
        <div class="timeline-tracker">
            <div class="timeline-step active">
                <div class="timeline-icon-bubble">
                    <i class="bi bi-cart-check"></i>
                </div>
                <div class="small fw-bold">Confirmed</div>
                <div class="small text-muted" style="font-size: 0.72rem;">Order Received</div>
            </div>
            <div class="timeline-step ${order.orderStatus == 'PROCESSING' || order.orderStatus == 'SHIPPED' || order.orderStatus == 'DELIVERED' || order.orderStatus == 'COMPLETED' || order.orderStatus == 'PAID' ? 'active' : ''}">
                <div class="timeline-icon-bubble">
                    <i class="bi bi-gear-wide-connected"></i>
                </div>
                <div class="small fw-bold">Processing</div>
                <div class="small text-muted" style="font-size: 0.72rem;">Packed with care</div>
            </div>
            <div class="timeline-step ${order.orderStatus == 'SHIPPED' || order.orderStatus == 'DELIVERED' ? 'active' : ''}">
                <div class="timeline-icon-bubble">
                    <i class="bi bi-truck"></i>
                </div>
                <div class="small fw-bold">Shipped</div>
                <div class="small text-muted" style="font-size: 0.72rem;">On the way</div>
            </div>
            <div class="timeline-step ${order.orderStatus == 'DELIVERED' ? 'active' : ''}">
                <div class="timeline-icon-bubble">
                    <i class="bi bi-house-check"></i>
                </div>
                <div class="small fw-bold">Delivered</div>
                <div class="small text-muted" style="font-size: 0.72rem;">Delivered to doorstep</div>
            </div>
        </div>

        <!-- Customer Details Box -->
        <div class="row g-3 p-3 rounded-4 bg-body-tertiary mb-4">
            <div class="col-sm-6">
                <span class="small text-muted text-uppercase fw-bold d-block mb-1">Customer Details</span>
                <div class="fw-bold">${order.user.username}</div>
                <div class="small text-muted">${order.user.email != null ? order.user.email : 'customer@example.com'}</div>
            </div>
            <div class="col-sm-6 text-sm-end">
                <span class="small text-muted text-uppercase fw-bold d-block mb-1">Delivery Address</span>
                <div class="fw-semibold">Registered Shipping Address</div>
                <div class="small text-muted">${order.user.phone_number != null ? order.user.phone_number : '+91 9876543210'}</div>
            </div>
        </div>

        <!-- Purchased Order Items Table -->
        <h6 class="fw-bold mb-3 text-uppercase text-muted small">Items Ordered (${order.orderItems != null ? order.orderItems.size() : 0})</h6>
        <div class="table-responsive mb-4">
            <table class="table table-borderless align-middle mb-0">
                <thead class="border-bottom">
                    <tr class="text-muted small text-uppercase">
                        <th>Product</th>
                        <th class="text-center">Quantity</th>
                        <th class="text-end">Unit Price</th>
                        <th class="text-end">Total</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${order.orderItems}">
                        <tr class="border-bottom">
                            <td>
                                <div class="d-flex align-items-center gap-3 py-2">
                                    <img src="${item.product.displayImagePath}" 
                                         alt="${item.product.name}" 
                                         style="width: 46px; height: 46px; object-fit: cover; border-radius: 8px; background: var(--bg-alt);"
                                         onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=60'">
                                    <div>
                                        <div class="fw-bold">${item.product.name}</div>
                                        <span class="product-category-tag" style="font-size: 0.72rem;">${item.product.category != null ? item.product.category : 'General'}</span>
                                    </div>
                                </div>
                            </td>
                            <td class="text-center fw-bold">x${item.quantity}</td>
                            <td class="text-end text-muted">₹<fmt:formatNumber value="${item.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <td class="text-end fw-bold">₹<fmt:formatNumber value="${item.price * item.quantity}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Grand Total Row -->
        <div class="d-flex justify-content-between align-items-baseline pt-3 border-top">
            <div>
                <span class="text-muted small">Payment Method:</span>
                <div class="fw-bold text-success"><i class="bi bi-shield-check"></i> Verified Instant Payment</div>
            </div>
            <div class="text-end">
                <span class="small text-muted">Total Amount Paid</span>
                <h3 class="fw-bold brand-gradient-text mb-0">
                    ₹<fmt:formatNumber value="${order.totalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                </h3>
            </div>
        </div>
    </div>

    <!-- Action Buttons (Print / Continue Shopping / Orders) -->
    <div class="d-flex flex-wrap gap-3 justify-content-center btn-print-hide">
        <button type="button" onclick="window.print()" class="btn btn-modern-outline py-2 px-4">
            <i class="bi bi-printer-fill"></i> Print Receipt
        </button>
        <a href="/orders" class="btn btn-modern-outline py-2 px-4">
            <i class="bi bi-box-seam-fill"></i> View My Orders
        </a>
        <a href="/products" class="btn btn-modern-primary py-2 px-4">
            <i class="bi bi-bag-fill"></i> Continue Shopping
        </a>
    </div>

</div>

<jsp:include page="footer.jsp" />
