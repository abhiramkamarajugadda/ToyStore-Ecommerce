<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Edit User | Admin Panel" scope="request"/>
<jsp:include page="header.jsp" />

<div class="container py-4" style="max-width: 600px;">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h2 class="h3 fw-bold mb-1">Edit User Profile</h2>
            <p class="text-muted small mb-0">Update account credentials, contact info, and role</p>
        </div>
        <a href="/users" class="btn-modern-outline py-2 px-3">
            <i class="bi bi-arrow-left"></i> Back to Users
        </a>
    </div>

    <div class="modern-card">
        <form action="/users/update/${user.id}" method="post">
            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-muted text-uppercase" for="fullName">Full Name</label>
                    <div class="form-floating-custom">
                        <i class="bi bi-person-fill input-icon-left"></i>
                        <input type="text" id="fullName" name="fullName" value="${user.fullName}" placeholder="Full Name">
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-muted text-uppercase" for="username">Username *</label>
                    <div class="form-floating-custom">
                        <i class="bi bi-person-badge input-icon-left"></i>
                        <input type="text" id="username" name="username" value="${user.username}" required>
                    </div>
                </div>
            </div>

            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-muted text-uppercase" for="password">Password</label>
                    <div class="form-floating-custom">
                        <i class="bi bi-lock input-icon-left"></i>
                        <input type="password" id="password" name="password" value="${user.password}" required>
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-muted text-uppercase" for="role">Role Permission *</label>
                    <div class="form-floating-custom">
                        <i class="bi bi-shield-check input-icon-left"></i>
                        <select id="role" name="role" required>
                            <option value="USER" ${user.role == 'USER' ? 'selected' : ''}>Customer (USER)</option>
                            <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Administrator (ADMIN)</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-muted text-uppercase" for="email">Email Address *</label>
                    <div class="form-floating-custom">
                        <i class="bi bi-envelope input-icon-left"></i>
                        <input type="email" id="email" name="email" value="${user.email}" required>
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-muted text-uppercase" for="phone_number">Phone Number *</label>
                    <div class="form-floating-custom">
                        <i class="bi bi-telephone input-icon-left"></i>
                        <input type="tel" id="phone_number" name="phone_number" value="${user.phone_number}" required>
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold small text-muted text-uppercase" for="address">Shipping Address</label>
                <div class="form-floating-custom">
                    <i class="bi bi-geo-alt input-icon-left"></i>
                    <input type="text" id="address" name="address" value="${user.address}" placeholder="Flat, Street, Area">
                </div>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-muted text-uppercase" for="city">City / Town</label>
                    <div class="form-floating-custom">
                        <i class="bi bi-buildings input-icon-left"></i>
                        <input type="text" id="city" name="city" value="${user.city}" placeholder="City">
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-muted text-uppercase" for="pincode">Pincode</label>
                    <div class="form-floating-custom">
                        <i class="bi bi-geo input-icon-left"></i>
                        <input type="text" id="pincode" name="pincode" value="${user.pincode}" placeholder="6-digit pincode">
                    </div>
                </div>
            </div>

            <div class="d-flex gap-3">
                <button type="submit" class="btn btn-modern-primary flex-grow-1 py-3 fs-6">
                    <i class="bi bi-check2-circle"></i> Update User
                </button>
                <a href="/users" class="btn btn-modern-outline py-3 px-4">
                    Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="footer.jsp" />
