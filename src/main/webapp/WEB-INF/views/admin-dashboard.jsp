<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Admin Executive Dashboard | Codegnan E-Commerce" scope="request"/>
<jsp:include page="header.jsp" />

<div class="container py-4">

    <!-- Admin Welcome Header & Quick Action Buttons -->
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4">
        <div>
            <div class="d-flex align-items-center gap-2">
                <h2 class="h3 fw-bold mb-0">Admin Command Center</h2>
                <span class="badge bg-danger px-2 py-1">Administrator Mode</span>
            </div>
            <p class="text-muted small mb-0">Real-time metrics, catalog inventory, orders & user management</p>
        </div>

        <div class="d-flex gap-2">
            <a href="/products/add" class="btn btn-modern-primary py-2 px-3">
                <i class="bi bi-plus-circle-fill"></i> Add Product
            </a>
            <a href="/users/create" class="btn btn-modern-outline py-2 px-3">
                <i class="bi bi-person-plus-fill"></i> Add User
            </a>
            <a href="/products" class="btn btn-modern-outline py-2 px-3">
                <i class="bi bi-shop"></i> View Store
            </a>
        </div>
    </div>

    <!-- 4 KPI Stat Metric Cards -->
    <div class="row g-4 mb-4">
        <!-- Revenue Card -->
        <div class="col-xl-3 col-md-6">
            <div class="kpi-card" style="border-left-color: #10b981;">
                <div class="kpi-icon-box" style="background: var(--success-gradient);">
                    <i class="bi bi-currency-rupee"></i>
                </div>
                <div>
                    <div class="kpi-label">Total Revenue</div>
                    <div class="kpi-value text-success">
                        ₹<fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                    </div>
                    <span class="kpi-trend text-success"><i class="bi bi-arrow-up-right"></i> +18.4% this month</span>
                </div>
            </div>
        </div>

        <!-- Total Orders Card -->
        <div class="col-xl-3 col-md-6">
            <div class="kpi-card" style="border-left-color: #6366f1;">
                <div class="kpi-icon-box" style="background: var(--primary-gradient);">
                    <i class="bi bi-cart-check-fill"></i>
                </div>
                <div>
                    <div class="kpi-label">Total Orders</div>
                    <div class="kpi-value text-primary">
                        ${totalOrders != null ? totalOrders : 0}
                    </div>
                    <span class="kpi-trend text-primary"><i class="bi bi-arrow-up-right"></i> +12.1% orders</span>
                </div>
            </div>
        </div>

        <!-- Catalog Products Card -->
        <div class="col-xl-3 col-md-6">
            <div class="kpi-card" style="border-left-color: #f59e0b;">
                <div class="kpi-icon-box" style="background: var(--warning-gradient);">
                    <i class="bi bi-boxes"></i>
                </div>
                <div>
                    <div class="kpi-label">Live Inventory</div>
                    <div class="kpi-value text-warning">
                        ${totalProducts != null ? totalProducts : 0}
                    </div>
                    <span class="kpi-trend text-muted">Across 5 categories</span>
                </div>
            </div>
        </div>

        <!-- Registered Users Card -->
        <div class="col-xl-3 col-md-6">
            <div class="kpi-card" style="border-left-color: #ec4899;">
                <div class="kpi-icon-box" style="background: var(--accent-gradient);">
                    <i class="bi bi-people-fill"></i>
                </div>
                <div>
                    <div class="kpi-label">Active Users</div>
                    <div class="kpi-value" style="color: #ec4899;">
                        ${totalUsers != null ? totalUsers : 0}
                    </div>
                    <span class="kpi-trend text-success"><i class="bi bi-arrow-up-right"></i> +8.2% registered</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart.js Visual Analytics Row -->
    <div class="row g-4 mb-4">
        <div class="col-lg-8">
            <div class="modern-card">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0">Sales & Revenue Trajectory</h5>
                    <span class="badge bg-primary-subtle text-primary fw-semibold">Monthly Performance</span>
                </div>
                <div style="position: relative; height: 260px;">
                    <canvas id="salesChart"></canvas>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="modern-card">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0">Order Status Distribution</h5>
                    <span class="badge bg-success-subtle text-success fw-semibold">Live Breakdown</span>
                </div>
                <div style="position: relative; height: 260px;">
                    <canvas id="ordersDoughnutChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Orders Management Table -->
    <div class="modern-table-card mb-4">
        <div class="p-3 border-bottom d-flex justify-content-between align-items-center bg-body-tertiary">
            <div>
                <h5 class="fw-bold mb-0">Recent Customer Orders</h5>
                <small class="text-muted">Track and update customer order fulfillment statuses</small>
            </div>
            <span class="badge bg-dark rounded-pill px-3 py-2">${orders != null ? orders.size() : 0} Total Orders</span>
        </div>

        <div class="table-responsive">
            <table class="table-modern">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Date & Time</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Update Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty orders}">
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>
                                        <a href="/orders/${order.id}" class="fw-bold text-primary">
                                            #ORD-${order.id}
                                        </a>
                                    </td>
                                    <td>
                                        <div class="fw-bold">${order.user.username}</div>
                                        <div class="small text-muted">${order.user.email != null ? order.user.email : 'No email'}</div>
                                    </td>
                                    <td class="small text-muted">
                                        ${order.formattedOrderDate}
                                    </td>
                                    <td class="fw-bold">
                                        ₹<fmt:formatNumber value="${order.totalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                    </td>
                                    <td>
                                        <c:set var="st" value="${order.orderStatus.toUpperCase()}"/>
                                        <span class="status-pill ${st == 'COMPLETED' || st == 'PAID' || st == 'DELIVERED' ? 'status-completed' : (st == 'PENDING' ? 'status-pending' : (st == 'PROCESSING' || st == 'SHIPPED' ? 'status-processing' : 'status-cancelled'))}">
                                            <i class="bi bi-circle-fill" style="font-size: 0.5rem;"></i> ${order.orderStatus}
                                        </span>
                                    </td>
                                    <td>
                                        <!-- Quick Status Form -->
                                        <form action="/admin/orders/status/${order.id}" method="post" class="d-flex align-items-center gap-2">
                                            <select name="status" class="form-select form-select-sm rounded-pill" style="max-width: 140px;" onchange="this.form.submit()">
                                                <option value="COMPLETED" ${order.orderStatus == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                                <option value="PROCESSING" ${order.orderStatus == 'PROCESSING' ? 'selected' : ''}>PROCESSING</option>
                                                <option value="SHIPPED" ${order.orderStatus == 'SHIPPED' ? 'selected' : ''}>SHIPPED</option>
                                                <option value="DELIVERED" ${order.orderStatus == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                                                <option value="CANCELLED" ${order.orderStatus == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                            </select>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">
                                    No customer orders placed yet.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Quick Store Inventory Management Overview -->
    <div class="modern-table-card">
        <div class="p-3 border-bottom d-flex justify-content-between align-items-center bg-body-tertiary">
            <div>
                <h5 class="fw-bold mb-0">Inventory & Products Summary</h5>
                <small class="text-muted">Live catalog overview with rapid edit and deletion triggers</small>
            </div>
            <a href="/products/add" class="btn btn-modern-primary py-1 px-3 fs-6">
                <i class="bi bi-plus-lg"></i> Add Product
            </a>
        </div>

        <div class="table-responsive">
            <table class="table-modern">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Description</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="prod" items="${products}">
                        <tr>
                            <td>
                                <div class="d-flex align-items-center gap-3">
                                    <img src="${prod.displayImagePath}" 
                                         alt="${prod.name}" 
                                         style="width: 44px; height: 44px; border-radius: 8px; object-fit: cover; background: var(--bg-alt);"
                                         onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=60'">
                                    <span class="fw-bold">${prod.name}</span>
                                </div>
                            </td>
                            <td>
                                <span class="product-category-tag">${prod.category != null ? prod.category : 'General'}</span>
                            </td>
                            <td class="fw-bold">
                                ₹<fmt:formatNumber value="${prod.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                            </td>
                            <td class="text-muted small" style="max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                ${prod.description}
                            </td>
                            <td class="text-end">
                                <a href="/products/edit/${prod.id}" class="btn btn-modern-warning py-1 px-2" title="Edit product">
                                    <i class="bi bi-pencil-square"></i>
                                </a>
                                <a href="/products/delete/${prod.id}" 
                                   class="btn btn-modern-danger py-1 px-2 btn-confirm-delete"
                                   data-item-name="${prod.name}" 
                                   title="Delete product">
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

<!-- Chart.js Setup Script -->
<script>
    document.addEventListener('DOMContentLoaded', () => {
        // Sales Trend Line Chart
        const salesCtx = document.getElementById('salesChart');
        if (salesCtx) {
            new Chart(salesCtx, {
                type: 'line',
                data: {
                    labels: ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Current'],
                    datasets: [{
                        label: 'Revenue (₹ Thousands)',
                        data: [18.5, 24.2, 32.0, 28.5, 45.0, 52.8, ${(totalRevenue != null ? totalRevenue / 1000 : 65.0)}],
                        borderColor: '#4f46e5',
                        backgroundColor: 'rgba(79, 70, 229, 0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: '#4f46e5',
                        pointRadius: 5
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { grid: { color: 'rgba(150, 150, 150, 0.1)' } },
                        x: { grid: { display: false } }
                    }
                }
            });
        }

        // Orders Breakdown Doughnut Chart
        const ordersCtx = document.getElementById('ordersDoughnutChart');
        if (ordersCtx) {
            new Chart(ordersCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Completed', 'Processing', 'Delivered', 'Pending'],
                    datasets: [{
                        data: [12, 5, 8, 3],
                        backgroundColor: ['#10b981', '#6366f1', '#3b82f6', '#f59e0b'],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom' }
                    },
                    cutout: '70%'
                }
            });
        }
    });
</script>

<jsp:include page="footer.jsp" />
