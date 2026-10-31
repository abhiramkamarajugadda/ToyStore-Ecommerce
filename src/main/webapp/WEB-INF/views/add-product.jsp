<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Add New Product | Admin Panel" scope="request"/>
<jsp:include page="header.jsp" />

<div class="container py-4" style="max-width: 720px;">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h2 class="h3 fw-bold mb-1">Add New Product</h2>
            <p class="text-muted small mb-0">Create and publish a new item to the store catalog</p>
        </div>
        <a href="/products" class="btn-modern-outline py-2 px-3">
            <i class="bi bi-arrow-left"></i> Back to Catalog
        </a>
    </div>

    <div class="modern-card">
        <form action="/products/add" method="post" enctype="multipart/form-data">
            <!-- Product Title -->
            <div class="mb-3">
                <label class="form-label fw-bold small text-muted text-uppercase" for="name">Product Name *</label>
                <div class="form-floating-custom">
                    <i class="bi bi-tag input-icon-left"></i>
                    <input type="text" id="name" name="name" placeholder="e.g. Wireless Noise Cancelling Headphones" required autofocus>
                </div>
            </div>

            <!-- Category & Price in 2 Columns -->
            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-muted text-uppercase" for="category">Category *</label>
                    <div class="form-floating-custom">
                        <i class="bi bi-grid input-icon-left"></i>
                        <select id="category" name="category" required>
                            <option value="Action & Vehicles">Action & Vehicles</option>
                            <option value="Building & Construction">Building & LEGO</option>
                            <option value="Plush & Dolls">Plush & Dolls</option>
                            <option value="Educational & STEM">Educational & STEM</option>
                            <option value="Board Games & Puzzles">Board Games & Puzzles</option>
                            <option value="Outdoor & Sports">Outdoor & Sports</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-muted text-uppercase" for="price">Price (₹ INR) *</label>
                    <div class="form-floating-custom">
                        <i class="bi bi-currency-rupee input-icon-left"></i>
                        <input type="number" id="price" name="price" step="0.01" min="1" placeholder="e.g. 1999.00" required>
                    </div>
                </div>
            </div>

            <!-- Description -->
            <div class="mb-3">
                <label class="form-label fw-bold small text-muted text-uppercase" for="description">Description *</label>
                <textarea id="description" name="description" class="form-control rounded-4 border-subtle p-3" rows="4" placeholder="Provide a detailed description of features, specs, and materials..." required></textarea>
            </div>

            <!-- Image File Upload or URL with Live Preview -->
            <div class="mb-4">
                <label class="form-label fw-bold small text-muted text-uppercase">Product Image (Upload File or Enter URL)</label>
                <div class="p-4 border border-2 border-dashed rounded-4 text-center bg-body-tertiary">
                    <i class="bi bi-cloud-arrow-up fs-1 text-primary mb-2 d-block"></i>
                    <p class="small text-muted mb-2">Upload any image file format (PNG, JPG, WebP, GIF, BMP, AVIF) &bull; Max 5MB</p>
                    <input type="file" id="imageFileInput" name="imageFile" class="form-control form-control-sm mx-auto mb-3" style="max-width: 380px;" accept=".jpg,.jpeg,.png,.webp,.gif,.bmp,.avif">
                    
                    <div class="d-flex align-items-center justify-content-center gap-2 mb-3">
                        <hr class="flex-grow-1 my-0 opacity-25">
                        <span class="small text-muted text-uppercase fw-bold" style="font-size: 0.75rem;">OR ENTER IMAGE URL</span>
                        <hr class="flex-grow-1 my-0 opacity-25">
                    </div>

                    <div class="form-floating-custom mx-auto mb-0" style="max-width: 480px;">
                        <i class="bi bi-link-45deg input-icon-left"></i>
                        <input type="url" id="imageUrlInput" name="imagePath" placeholder="https://example.com/toy-image.jpg" oninput="previewFromUrl(this.value)">
                    </div>

                    <!-- Live Image Preview -->
                    <div id="imagePreviewBox" class="mt-3" style="display: none;">
                        <span class="small fw-bold text-muted d-block mb-1">Image Preview:</span>
                        <img id="imagePreviewImg" src="" alt="Preview" style="max-height: 180px; max-width: 100%; border-radius: 12px; object-fit: contain; box-shadow: var(--shadow-sm); background: var(--bg-surface);">
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="d-flex gap-3">
                <button type="submit" class="btn btn-modern-primary flex-grow-1 py-3 fs-6">
                    <i class="bi bi-cloud-check-fill"></i> Publish Product
                </button>
                <a href="/products" class="btn btn-modern-outline py-3 px-4">
                    Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="footer.jsp" />
