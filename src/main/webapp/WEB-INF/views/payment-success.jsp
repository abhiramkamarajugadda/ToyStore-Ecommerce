<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:choose>
    <c:when test="${not empty order}">
        <jsp:include page="checkout-success.jsp" />
    </c:when>
    <c:otherwise>
        <c:set var="pageTitle" value="Payment Successful | Codegnan E-Commerce" scope="request"/>
        <jsp:include page="header.jsp" />

        <div class="container py-5 text-center" style="max-width: 600px;" data-trigger-confetti="true">
            <div class="brand-icon-badge mx-auto mb-3" style="width: 70px; height: 70px; font-size: 2.2rem; background: var(--success-gradient);">
                <i class="bi bi-check2-circle"></i>
            </div>
            <h2 class="display-6 fw-bold mb-2">Payment Confirmed!</h2>
            <p class="text-muted mb-4">${message != null ? message : 'Your payment has been successfully processed.'}</p>
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
    </c:otherwise>
</c:choose>
