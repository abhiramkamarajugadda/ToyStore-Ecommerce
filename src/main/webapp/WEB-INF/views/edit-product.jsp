<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Edit Product | Admin Panel" scope="request"/>
<jsp:include page="header.jsp" />

<div class="container py-4" style="max-width: 720px;">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h2 class="h3 fw-bold mb-1">Edit Product</h2>
            <p class="text-muted small mb-0">Modify product details, category, price, or image</p>
        </div>
        <a href="/products" class="btn-modern-outline py-2 px-3">
            <i class="bi bi-arrow-left"></i> Back to Catalog
        </a>
    </div>

    <div class="modern-card">
        <form action="/products/edit/${product.id}" method="post" enctype="multipart/form-data">
            <!-- Product ID (Hidden) -->
            <input type="hidden" name="id" value="${product.id}">

            <!-- Product Title -->
            <div class="mb-3">
                <label class="form-label fw-bold small text-muted text-uppercase" for="name">Product Name *</label>
                <div class="form-floating-custom">
                    <i class="bi bi-tag input-icon-left"></i>
                    <input type="text" id="name" name="name" value="${product.name}" required>
                </div>
            </div>

            <!-- Category & Price -->
            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-muted text-uppercase" for="category">Category *</label>
                    <div class="form-floating-custom">
                        <i class="bi bi-grid input-icon-left"></i>
                        <select id="category" name="category" required>
                            <option value="Action & Vehicles" ${product.category == 'Action & Vehicles' ? 'selected' : ''}>Action & Vehicles</option>
                            <option value="Building & Construction" ${product.category == 'Building & Construction' ? 'selected' : ''}>Building & LEGO</option>
                            <option value="Plush & Dolls" ${product.category == 'Plush & Dolls' ? 'selected' : ''}>Plush & Dolls</option>
                            <option value="Educational & STEM" ${product.category == 'Educational & STEM' ? 'selected' : ''}>Educational & STEM</option>
                            <option value="Board Games & Puzzles" ${product.category == 'Board Games & Puzzles' ? 'selected' : ''}>Board Games & Puzzles</option>
                            <option value="Outdoor & Sports" ${product.category == 'Outdoor & Sports' ? 'selected' : ''}>Outdoor & Sports</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-muted text-uppercase" for="price">Price (₹ INR) *</label>
                    <div class="form-floating-custom">
                        <i class="bi bi-currency-rupee input-icon-left"></i>
                        <input type="number" id="price" name="price" step="0.01" min="1" value="${product.price}" required>
                    </div>
                </div>
            </div>

            <!-- Description -->
            <div class="mb-3">
                <label class="form-label fw-bold small text-muted text-uppercase" for="description">Description *</label>
                <textarea id="description" name="description" class="form-control rounded-4 border-subtle p-3" rows="4" required>${product.description}</textarea>
            </div>

            <!-- Existing Image & Image Upload -->
            <div class="mb-4">
                <label class="form-label fw-bold small text-muted text-uppercase">Product Image</label>
                <div class="d-flex align-items-center gap-3 p-3 border rounded-4 bg-body-tertiary mb-3">
                    <img src="${product.displayImagePath}" 
                         alt="${product.name}" 
                         style="width: 80px; height: 80px; object-fit: cover; border-radius: 12px; background: var(--bg-alt);"
                         onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=60'">
                    <div>
                        <div class="small fw-bold">Current Image</div>
                        <div class="small text-muted text-truncate" style="max-width: 350px;">${product.imagePath != null ? product.imagePath : 'Default placeholder'}</div>
                    </div>
                </div>

                <div class="p-3 border border-2 border-dashed rounded-4 text-center bg-body-tertiary">
                    <p class="small text-muted mb-2">Upload any image file (PNG, JPG, WebP, GIF, SVG, BMP, AVIF) &bull; Max 50MB</p>
                    <input type="file" id="imageFileInput" name="imageFile" class="form-control form-control-sm mx-auto mb-3" style="max-width: 380px;" accept="image/*, .jpg, .jpeg, .png, .webp, .gif, .svg, .bmp, .jfif, .ico, .tiff, .avif, .heic">
                    
                    <div class="d-flex align-items-center justify-content-center gap-2 mb-3">
                        <hr class="flex-grow-1 my-0 opacity-25">
                        <span class="small text-muted text-uppercase fw-bold" style="font-size: 0.75rem;">OR UPDATE IMAGE URL</span>
                        <hr class="flex-grow-1 my-0 opacity-25">
                    </div>

                    <div class="form-floating-custom mx-auto mb-0" style="max-width: 480px;">
                        <i class="bi bi-link-45deg input-icon-left"></i>
                        <input type="url" id="imageUrlInput" name="imagePath" value="${product.imagePath}" placeholder="https://example.com/toy-image.jpg" oninput="previewFromUrl(this.value)">
                    </div>

                    <div id="imagePreviewBox" class="mt-3" style="display: none;">
                        <span class="small fw-bold text-muted d-block mb-1">New Image Preview:</span>
                        <img id="imagePreviewImg" src="" alt="New Preview" style="max-height: 180px; max-width: 100%; border-radius: 12px; object-fit: contain; box-shadow: var(--shadow-sm); background: var(--bg-surface);">
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="d-flex gap-3">
                <button type="submit" class="btn btn-modern-primary flex-grow-1 py-3 fs-6">
                    <i class="bi bi-check2-circle"></i> Save Changes
                </button>
                <a href="/products" class="btn btn-modern-outline py-3 px-4">
                    Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="footer.jsp" />
