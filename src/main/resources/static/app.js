/**
 * Codegnan E-Commerce - Interactive Frontend Logic & Enhancements
 */

document.addEventListener('DOMContentLoaded', () => {
    initThemeToggle();
    initLiveSearchAndCategoryFilter();
    initQuantitySteppers();
    initCartCounter();
    initCouponCode();
    initConfettiCelebration();
    initSweetAlertTriggers();
    initImageUploadPreview();
});

/* ==========================================================================
   1. DARK / LIGHT THEME TOGGLE
   ========================================================================== */
function initThemeToggle() {
    const savedTheme = localStorage.getItem('ecom_theme') || 'light';
    document.documentElement.setAttribute('data-bs-theme', savedTheme);
    updateThemeIcon(savedTheme);

    const themeBtns = document.querySelectorAll('.theme-toggle-btn');
    themeBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const currentTheme = document.documentElement.getAttribute('data-bs-theme') || 'light';
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            document.documentElement.setAttribute('data-bs-theme', newTheme);
            localStorage.setItem('ecom_theme', newTheme);
            updateThemeIcon(newTheme);
            showToast('Theme Changed', `Switched to ${newTheme} mode`, 'info');
        });
    });
}

function updateThemeIcon(theme) {
    const icons = document.querySelectorAll('.theme-toggle-icon');
    icons.forEach(icon => {
        if (theme === 'dark') {
            icon.className = 'bi bi-sun-fill theme-toggle-icon text-warning';
        } else {
            icon.className = 'bi bi-moon-stars-fill theme-toggle-icon';
        }
    });
}

/* ==========================================================================
   2. LIVE PRODUCT SEARCH & CLIENT-SIDE CATEGORY FILTER
   ========================================================================== */
function initLiveSearchAndCategoryFilter() {
    const searchInput = document.getElementById('liveProductSearch');
    const productCards = document.querySelectorAll('.product-item-col');
    const noResultsBox = document.getElementById('noProductsFound');
    const categoryChips = document.querySelectorAll('.category-chip-btn');

    if (!productCards.length) return;

    let activeCategory = 'all';

    function filterProducts() {
        const query = searchInput ? searchInput.value.toLowerCase().trim() : '';
        let visibleCount = 0;

        productCards.forEach(col => {
            const name = col.getAttribute('data-name')?.toLowerCase() || '';
            const desc = col.getAttribute('data-desc')?.toLowerCase() || '';
            const cat = col.getAttribute('data-category')?.toLowerCase() || '';

            const matchesQuery = !query || name.includes(query) || desc.includes(query);
            const matchesCategory = activeCategory === 'all' || cat === activeCategory;

            if (matchesQuery && matchesCategory) {
                col.style.display = '';
                col.classList.add('animate-fade-in');
                visibleCount++;
            } else {
                col.style.display = 'none';
            }
        });

        if (noResultsBox) {
            noResultsBox.style.display = visibleCount === 0 ? 'block' : 'none';
        }
    }

    if (searchInput) {
        searchInput.addEventListener('input', debounce(filterProducts, 150));
    }

    categoryChips.forEach(chip => {
        chip.addEventListener('click', (e) => {
            e.preventDefault();
            categoryChips.forEach(c => c.classList.remove('active'));
            chip.classList.add('active');
            activeCategory = chip.getAttribute('data-category')?.toLowerCase() || 'all';
            filterProducts();
        });
    });
}

/* ==========================================================================
   3. QUANTITY STEPPERS
   ========================================================================== */
function initQuantitySteppers() {
    document.querySelectorAll('.qty-stepper').forEach(stepper => {
        const minusBtn = stepper.querySelector('.qty-btn-minus');
        const plusBtn = stepper.querySelector('.qty-btn-plus');
        const input = stepper.querySelector('.qty-input');

        if (!input) return;

        if (minusBtn) {
            minusBtn.addEventListener('click', (e) => {
                e.preventDefault();
                let val = parseInt(input.value) || 1;
                if (val > 1) {
                    input.value = val - 1;
                    triggerChangeEvent(input);
                }
            });
        }

        if (plusBtn) {
            plusBtn.addEventListener('click', (e) => {
                e.preventDefault();
                let val = parseInt(input.value) || 1;
                input.value = val + 1;
                triggerChangeEvent(input);
            });
        }
    });
}

function triggerChangeEvent(element) {
    const event = new Event('change', { bubbles: true });
    element.dispatchEvent(event);
}

/* ==========================================================================
   4. CART COUNTER
   ========================================================================== */
function initCartCounter() {
    fetch('/cart/count')
        .then(res => res.json())
        .then(data => {
            const badges = document.querySelectorAll('.cart-counter-badge');
            badges.forEach(badge => {
                badge.textContent = data.count || 0;
                if (data.count > 0) {
                    badge.classList.remove('d-none');
                } else {
                    badge.classList.add('d-none');
                }
            });
        })
        .catch(() => {});
}

/* ==========================================================================
   5. COUPON CODE VALIDATION
   ========================================================================== */
function initCouponCode() {
    const applyBtn = document.getElementById('applyCouponBtn');
    const couponInput = document.getElementById('couponCodeInput');
    const discountRow = document.getElementById('discountSummaryRow');
    const discountAmountElem = document.getElementById('discountAmountElem');
    const finalTotalElem = document.getElementById('finalTotalElem');
    const subtotalElem = document.getElementById('subtotalValueElem');

    if (!applyBtn || !couponInput || !finalTotalElem || !subtotalElem) return;

    applyBtn.addEventListener('click', () => {
        const code = couponInput.value.trim().toUpperCase();
        const subtotal = parseFloat(subtotalElem.getAttribute('data-subtotal')) || 0;

        if (!code) {
            showToast('Coupon Error', 'Please enter a coupon code.', 'warning');
            return;
        }

        let discountPercent = 0;
        let flatDiscount = 0;

        if (code === 'SAVE10') {
            discountPercent = 10;
        } else if (code === 'FESTIVE20') {
            discountPercent = 20;
        } else if (code === 'WELCOME50') {
            flatDiscount = 50;
        } else if (code === 'FREESHIP') {
            showToast('Coupon Applied', 'Free Shipping unlocked on your order!', 'success');
            return;
        } else {
            showToast('Invalid Coupon', 'Code is invalid or expired. Try "SAVE10" or "FESTIVE20"', 'danger');
            return;
        }

        let discountVal = (subtotal * discountPercent / 100) + flatDiscount;
        if (discountVal > subtotal) discountVal = subtotal;

        const grandTotal = Math.max(0, subtotal - discountVal);

        if (discountRow) discountRow.classList.remove('d-none');
        if (discountAmountElem) discountAmountElem.textContent = '- ₹' + discountVal.toFixed(2);
        if (finalTotalElem) finalTotalElem.textContent = '₹' + grandTotal.toFixed(2);

        showToast('Coupon Applied!', `Coupon "${code}" applied successfully! You saved ₹${discountVal.toFixed(2)}`, 'success');
    });
}

/* ==========================================================================
   6. CONFETTI CELEBRATION
   ========================================================================== */
function initConfettiCelebration() {
    const confettiTrigger = document.querySelector('[data-trigger-confetti="true"]');
    if (confettiTrigger && typeof confetti === 'function') {
        const duration = 2.5 * 1000;
        const end = Date.now() + duration;

        (function frame() {
            confetti({
                particleCount: 4,
                angle: 60,
                spread: 55,
                origin: { x: 0, y: 0.7 }
            });
            confetti({
                particleCount: 4,
                angle: 120,
                spread: 55,
                origin: { x: 1, y: 0.7 }
            });

            if (Date.now() < end) {
                requestAnimationFrame(frame);
            }
        }());
    }
}

/* ==========================================================================
   7. SWEETALERT CONFIRMATIONS
   ========================================================================== */
function initSweetAlertTriggers() {
    document.querySelectorAll('.btn-confirm-delete').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            const targetUrl = btn.getAttribute('href');
            const itemName = btn.getAttribute('data-item-name') || 'this item';

            if (typeof Swal !== 'undefined') {
                Swal.fire({
                    title: 'Are you sure?',
                    text: `Do you really want to delete ${itemName}? This action cannot be undone.`,
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#ef4444',
                    cancelButtonColor: '#64748b',
                    confirmButtonText: 'Yes, Delete',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = targetUrl;
                    }
                });
            } else {
                if (confirm(`Are you sure you want to delete ${itemName}?`)) {
                    window.location.href = targetUrl;
                }
            }
        });
    });
}

/* ==========================================================================
   8. IMAGE UPLOAD & URL LIVE PREVIEW
   ========================================================================== */
function initImageUploadPreview() {
    const fileInput = document.getElementById('imageFileInput');
    const urlInput = document.getElementById('imageUrlInput');
    const previewContainer = document.getElementById('imagePreviewBox');
    const previewImg = document.getElementById('imagePreviewImg');

    if (!previewImg) return;

    if (fileInput) {
        fileInput.addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                    if (previewContainer) {
                        previewContainer.style.display = 'block';
                    }
                    if (urlInput) {
                        urlInput.value = ''; // clear URL input to prioritize uploaded file
                    }
                };
                reader.readAsDataURL(file);
            }
        });
    }
}

function previewFromUrl(url) {
    const previewContainer = document.getElementById('imagePreviewBox');
    const previewImg = document.getElementById('imagePreviewImg');
    const fileInput = document.getElementById('imageFileInput');

    if (!previewImg) return;

    if (url && url.trim().length > 5) {
        previewImg.src = url.trim();
        if (previewContainer) {
            previewContainer.style.display = 'block';
        }
        if (fileInput) {
            fileInput.value = ''; // clear file input if URL entered
        }
    } else if (!fileInput || !fileInput.files.length) {
        if (previewContainer) {
            previewContainer.style.display = 'none';
        }
    }
}

/* ==========================================================================
   TOAST HELPER
   ========================================================================== */
function showToast(title, message, type = 'info') {
    if (typeof Swal !== 'undefined') {
        const Toast = Swal.mixin({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3500,
            timerProgressBar: true
        });
        Toast.fire({
            icon: type,
            title: title + (message ? `: ${message}` : '')
        });
    } else {
        console.log(`[Toast ${type}] ${title} - ${message}`);
    }
}

function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}
