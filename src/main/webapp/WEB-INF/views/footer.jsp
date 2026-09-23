<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

    </main> <!-- Main Page Content Wrapper Ends -->

    <!-- Modern E-Commerce Multi-Column Footer -->
    <footer class="footer-custom">
        <div class="container">
            <!-- Trust Badges Row -->
            <div class="row g-3 mb-5">
                <div class="col-md-3 col-sm-6">
                    <div class="footer-trust-badge">
                        <i class="bi bi-shield-check footer-trust-icon"></i>
                        <div>
                            <h6 class="mb-0 fw-bold">100% Genuine</h6>
                            <small class="text-muted">Quality certified products</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="footer-trust-badge">
                        <i class="bi bi-truck footer-trust-icon"></i>
                        <div>
                            <h6 class="mb-0 fw-bold">Express Shipping</h6>
                            <small class="text-muted">Fast 24-48h delivery</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="footer-trust-badge">
                        <i class="bi bi-credit-card-2-front footer-trust-icon"></i>
                        <div>
                            <h6 class="mb-0 fw-bold">Secure Payments</h6>
                            <small class="text-muted">Powered by Razorpay</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="footer-trust-badge">
                        <i class="bi bi-headset footer-trust-icon"></i>
                        <div>
                            <h6 class="mb-0 fw-bold">24/7 Support</h6>
                            <small class="text-muted">Dedicated assistance</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer Columns -->
            <div class="row g-4 pb-4 border-bottom">
                <div class="col-lg-4 col-md-6">
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <div class="brand-icon-badge" style="width: 36px; height: 36px; font-size: 1.1rem;">
                            <i class="bi bi-rocket-takeoff-fill"></i>
                        </div>
                        <span class="fs-4 fw-bold brand-font">Toy<span class="brand-gradient-text">Store</span></span>
                    </div>
                    <p class="text-muted small pe-lg-4">
                        Your magical destination for premium toys, LEGO sets, STEM robotics, plushies, RC vehicles, and family board games. Built with love for endless childhood joy and creativity.
                    </p>
                    <div class="d-flex mt-3">
                        <a href="javascript:void(0)" class="social-icon-btn"><i class="bi bi-facebook"></i></a>
                        <a href="javascript:void(0)" class="social-icon-btn"><i class="bi bi-twitter-x"></i></a>
                        <a href="javascript:void(0)" class="social-icon-btn"><i class="bi bi-instagram"></i></a>
                        <a href="javascript:void(0)" class="social-icon-btn"><i class="bi bi-linkedin"></i></a>
                        <a href="javascript:void(0)" class="social-icon-btn"><i class="bi bi-github"></i></a>
                    </div>
                </div>

                <div class="col-lg-2 col-md-6 col-6">
                    <h6 class="footer-title">Toy Categories</h6>
                    <ul class="footer-link-list">
                        <li><a href="/products">All Toys</a></li>
                        <li><a href="/products?category=Action%20%26%20Vehicles">Action & RC Cars</a></li>
                        <li><a href="/products?category=Building%20%26%20Construction">Building & LEGO</a></li>
                        <li><a href="/products?category=Plush%20%26%20Dolls">Plush & Dolls</a></li>
                        <li><a href="/products?category=Educational%20%26%20STEM">STEM & Learning</a></li>
                    </ul>
                </div>

                <div class="col-lg-2 col-md-6 col-6">
                    <h6 class="footer-title">Customer Care</h6>
                    <ul class="footer-link-list">
                        <li><a href="javascript:void(0)">Track Order</a></li>
                        <li><a href="javascript:void(0)">Returns & Refunds</a></li>
                        <li><a href="javascript:void(0)">Terms & Conditions</a></li>
                        <li><a href="javascript:void(0)">Privacy Policy</a></li>
                        <li><a href="javascript:void(0)">Help & FAQ</a></li>
                    </ul>
                </div>

                <div class="col-lg-4 col-md-6">
                    <h6 class="footer-title">Newsletter</h6>
                    <p class="small text-muted">Subscribe to get special discounts, free giveaways, and once-in-a-lifetime deals.</p>
                    <div class="input-group mb-3">
                        <input type="email" id="newsletterEmailInput" class="form-control rounded-start-pill border-subtle" placeholder="Enter your email...">
                        <button class="btn btn-modern-primary rounded-end-pill px-4" type="button" onclick="handleNewsletter()">
                            <i class="bi bi-send-fill"></i>
                        </button>
                    </div>
                    <div class="small text-muted d-flex align-items-center gap-2">
                        <i class="bi bi-lock-fill text-success"></i> We respect your privacy. No spam ever.
                    </div>
                </div>
            </div>

            <!-- Bottom Copyright & Payment Methods -->
            <div class="d-flex flex-column flex-md-row align-items-center justify-content-between pt-4 gap-3">
                <div class="small text-muted">
                    &copy; 2026 <strong>Codegnan E-Commerce</strong>. Crafted for performance & elegance. All rights reserved.
                </div>
                <div class="d-flex align-items-center gap-3 fs-4 text-muted">
                    <i class="fa-brands fa-cc-visa text-primary" title="Visa"></i>
                    <i class="fa-brands fa-cc-mastercard text-danger" title="Mastercard"></i>
                    <i class="fa-brands fa-cc-apple-pay" title="Apple Pay"></i>
                    <i class="fa-solid fa-building-columns text-info" title="Net Banking"></i>
                    <i class="fa-solid fa-qrcode text-success" title="UPI Payments"></i>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5.3.3 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- SweetAlert2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>

    <!-- Custom Frontend App JS -->
    <script src="/app.js"></script>

    <script>
        function handleNewsletter() {
            const input = document.getElementById('newsletterEmailInput');
            if (input && input.value.trim() && input.value.includes('@')) {
                showToast('Subscribed!', 'Thank you for subscribing to our newsletter.', 'success');
                input.value = '';
            } else {
                showToast('Email Required', 'Please enter a valid email address.', 'warning');
            }
        }
    </script>
</body>
</html>
