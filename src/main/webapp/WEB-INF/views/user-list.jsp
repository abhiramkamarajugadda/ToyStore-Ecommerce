<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Manage Users | Admin Panel" scope="request"/>
<jsp:include page="header.jsp" />

<div class="container py-4">
    <!-- Header -->
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4">
        <div>
            <h2 class="h3 fw-bold mb-1">User Management</h2>
            <p class="text-muted small mb-0">Manage registered customers, administrators, and system access</p>
        </div>
        <div class="d-flex gap-2">
            <a href="/users/create" class="btn btn-modern-primary py-2 px-3">
                <i class="bi bi-person-plus-fill"></i> Create New User
            </a>
            <a href="/admin/dashboard" class="btn btn-modern-outline py-2 px-3">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
        </div>
    </div>

    <!-- Users Datatable Card -->
    <div class="modern-table-card">
        <div class="p-3 border-bottom d-flex justify-content-between align-items-center bg-body-tertiary">
            <span class="fw-bold">${users != null ? users.size() : 0} Registered Users</span>
        </div>

        <div class="table-responsive">
            <table class="table-modern">
                <thead>
                    <tr>
                        <th>User & Name</th>
                        <th>Role</th>
                        <th>Contact</th>
                        <th>Location</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td>
                                <div class="d-flex align-items-center gap-3">
                                    <div class="user-avatar-badge" style="width: 40px; height: 40px; font-size: 1.05rem;">
                                        ${u.username.substring(0, 1).toUpperCase()}
                                    </div>
                                    <div>
                                        <div class="fw-bold">${u.fullName != null && !u.fullName.isEmpty() ? u.fullName : u.username}</div>
                                        <div class="small text-muted">@${u.username} &bull; #USR-${u.id}</div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="badge ${u.role == 'ADMIN' ? 'bg-danger' : 'bg-primary'} rounded-pill px-3 py-1">
                                    ${u.role}
                                </span>
                            </td>
                            <td>
                                <div class="small"><i class="bi bi-envelope text-muted me-1"></i>${u.email != null ? u.email : 'N/A'}</div>
                                <div class="small text-muted"><i class="bi bi-telephone text-muted me-1"></i>${u.phone_number != null ? u.phone_number : 'N/A'}</div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty u.city}">
                                        <div class="small"><i class="bi bi-geo-alt text-danger me-1"></i>${u.city}<c:if test="${not empty u.pincode}"> - ${u.pincode}</c:if></div>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="small text-muted">N/A</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <a href="/users/edit/${u.id}" class="btn btn-modern-warning py-1 px-2" title="Edit User">
                                    <i class="bi bi-pencil-square"></i>
                                </a>
                                <a href="/users/delete/${u.id}" 
                                   class="btn btn-modern-danger py-1 px-2 btn-confirm-delete"
                                   data-item-name="user ${u.username}" 
                                   title="Delete User">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
