<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Payment Verified | Codegnan E-Commerce" scope="request"/>
<jsp:include page="header.jsp" />

<div class="container py-5 text-center" style="max-width: 600px;" data-trigger-confetti="true">
    <div class="brand-icon-badge mx-auto mb-3" style="width: 70px; height: 70px; font-size: 2.2rem; background: var(--success-gradient);">
        <i class="bi bi-patch-check-fill"></i>
    </div>
    <h2 class="display-6 fw-bold mb-2">Payment Verified!</h2>
    <p class="text-muted mb-3">Your transaction has been securely confirmed.</p>
    <div class="p-3 bg-body-tertiary rounded-4 mb-4">
        <span class="small text-muted text-uppercase fw-bold d-block">Razorpay Payment ID</span>
        <span class="fw-bold text-primary">${paymentId}</span>
    </div>
    <div class="d-flex justify-content-center gap-3">
        <a href="/orders" class="btn btn-modern-outline py-2 px-4">
            <i class="bi bi-clock-history"></i> My Orders
        </a>
        <a href="/products" class="btn btn-modern-primary py-2 px-4">
            <i class="bi bi-bag-fill"></i> Continue Shopping
        </a>
    </div>
</div>

<jsp:include page="footer.jsp" />
