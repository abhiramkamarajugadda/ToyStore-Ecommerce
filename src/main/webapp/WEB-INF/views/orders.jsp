<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="My Orders | Codegnan E-Commerce" scope="request"/>
<jsp:include page="header.jsp" />

<div class="container py-4" style="max-width: 900px;">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h2 class="h3 fw-bold mb-1">My Orders</h2>
            <p class="text-muted small mb-0">Track shipments, review past orders, and download receipts</p>
        </div>
        <a href="/products" class="btn-modern-outline py-2 px-3">
            <i class="bi bi-shop"></i> Explore Catalog
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="d-flex flex-column gap-3">
                <c:forEach var="order" items="${orders}">
                    <div class="modern-card p-0 overflow-hidden">
                        <!-- Order Card Header -->
                        <div class="p-3 bg-body-tertiary border-bottom d-flex flex-wrap justify-content-between align-items-center gap-3">
                            <div class="d-flex align-items-center gap-3">
                                <div>
                                    <span class="small text-muted text-uppercase fw-bold d-block">Order Placed</span>
                                    <span class="fw-semibold">${order.formattedOrderDate}</span>
                                </div>
                                <div class="border-start ps-3">
                                    <span class="small text-muted text-uppercase fw-bold d-block">Total</span>
                                    <span class="fw-bold">₹<fmt:formatNumber value="${order.totalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                                </div>
                                <div class="border-start ps-3 d-none d-sm-block">
                                    <span class="small text-muted text-uppercase fw-bold d-block">Order #</span>
                                    <span class="fw-bold text-primary">#ORD-${order.id}</span>
                                </div>
                            </div>

                            <div class="d-flex align-items-center gap-2">
                                <c:set var="st" value="${order.orderStatus.toUpperCase()}"/>
                                <span class="status-pill ${st == 'COMPLETED' || st == 'PAID' || st == 'DELIVERED' ? 'status-completed' : (st == 'PENDING' ? 'status-pending' : (st == 'PROCESSING' || st == 'SHIPPED' ? 'status-processing' : 'status-cancelled'))}">
                                    <i class="bi bi-circle-fill" style="font-size: 0.5rem;"></i> ${order.orderStatus}
                                </span>
                                <a href="/orders/${order.id}" class="btn btn-modern-outline py-1 px-3 fs-6">
                                    <i class="bi bi-receipt"></i> View Receipt
                                </a>
                            </div>
                        </div>

                        <!-- Order Items Preview -->
                        <div class="p-3">
                            <c:forEach var="item" items="${order.orderItems}">
                                <div class="d-flex align-items-center gap-3 py-2 border-bottom">
                                    <img src="${item.product.displayImagePath}" 
                                         alt="${item.product.name}" 
                                         style="width: 50px; height: 50px; object-fit: cover; border-radius: 8px; background: var(--bg-alt);"
                                         onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=60'">
                                    
                                    <div class="flex-grow-1">
                                        <h6 class="fw-bold mb-0">${item.product.name}</h6>
                                        <span class="text-muted small">Qty: ${item.quantity} &times; ₹<fmt:formatNumber value="${item.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                                    </div>

                                    <div class="fw-bold">
                                        ₹<fmt:formatNumber value="${item.price * item.quantity}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>

        <c:otherwise>
            <div class="modern-card text-center py-5">
                <div class="mb-3 text-muted">
                    <i class="bi bi-bag-x fs-1"></i>
                </div>
                <h4 class="fw-bold mb-2">No Past Orders Found</h4>
                <p class="text-muted mb-4">You haven't made any purchases yet. Start exploring our premium collection!</p>
                <a href="/products" class="btn btn-modern-primary py-2 px-4">
                    <i class="bi bi-bag-plus-fill"></i> Start Shopping
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="footer.jsp" />
