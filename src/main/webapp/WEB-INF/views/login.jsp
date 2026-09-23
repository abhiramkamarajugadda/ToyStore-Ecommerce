<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Sign In / Register | Codegnan E-Commerce" scope="request"/>
<jsp:include page="header.jsp" />

<div class="auth-wrapper">
    <!-- Ambient Background Lighting Blobs -->
    <div class="auth-bg-blob-1"></div>
    <div class="auth-bg-blob-2"></div>

    <div class="auth-card">
        <!-- Logo & Title -->
        <div class="text-center mb-4">
            <div class="brand-icon-badge mx-auto mb-2" style="width: 48px; height: 48px; font-size: 1.4rem;">
                <i class="bi bi-shield-lock-fill"></i>
            </div>
            <h3 class="fw-bold mb-1">Welcome to ToyStore</h3>
            <p class="text-muted small">Sign in to access your orders, cart, and exclusive deals</p>
        </div>

        <!-- Tab Switcher -->
        <div class="auth-nav-tabs">
            <button type="button" class="auth-nav-tab ${param.tab == 'register' ? '' : 'active'}" id="loginTabBtn" onclick="switchAuthTab('login')">
                <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
            </button>
            <button type="button" class="auth-nav-tab ${param.tab == 'register' ? 'active' : ''}" id="registerTabBtn" onclick="switchAuthTab('register')">
                <i class="bi bi-person-plus me-1"></i> Create Account
            </button>
        </div>

        <!-- Sign In Form -->
        <div id="loginFormContainer" style="display: ${param.tab == 'register' ? 'none' : 'block'};">
            <form action="/login" method="post">
                <div class="form-floating-custom">
                    <i class="bi bi-person input-icon-left"></i>
                    <input type="text" id="loginUsername" name="username" placeholder="Username" required autofocus>
                </div>

                <div class="form-floating-custom">
                    <i class="bi bi-lock input-icon-left"></i>
                    <input type="password" id="loginPassword" name="password" placeholder="Password" required>
                    <i class="bi bi-eye input-icon-right" id="toggleLoginPass" onclick="togglePass('loginPassword', this)"></i>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="rememberMe" checked>
                        <label class="form-check-label small text-muted" for="rememberMe">Remember me</label>
                    </div>
                    <a href="javascript:void(0)" class="small text-muted" onclick="showToast('Password Reset', 'Please contact admin to reset password.', 'info')">Forgot Password?</a>
                </div>

                <button type="submit" class="btn btn-modern-primary w-100 py-3 fs-6 mb-3">
                    <i class="bi bi-arrow-right-circle-fill"></i> Sign In
                </button>
            </form>

            <!-- Demo Credentials Quick Helper -->
            <div class="p-3 border rounded-3 bg-body-tertiary mb-2">
                <div class="small fw-bold text-muted mb-2"><i class="bi bi-lightning-charge-fill text-warning"></i> Quick Demo Login:</div>
                <div class="d-flex gap-2">
                    <button type="button" class="demo-login-pill flex-grow-1" onclick="fillCredentials('admin', 'admin123')">
                        👑 Admin: <strong>admin</strong>
                    </button>
                    <button type="button" class="demo-login-pill flex-grow-1" onclick="fillCredentials('user', 'user123')">
                        🛍️ Customer: <strong>user</strong>
                    </button>
                </div>
            </div>
        </div>

        <!-- Registration Form (8 Fields) -->
        <div id="registerFormContainer" style="display: ${param.tab == 'register' ? 'block' : 'none'};">
            <form action="/register" method="post" id="registrationForm" onsubmit="return validateRegisterForm();">
                <div class="row g-2">
                    <!-- 1. Full Name -->
                    <div class="col-md-6">
                        <div class="form-floating-custom mb-2">
                            <i class="bi bi-person-fill input-icon-left"></i>
                            <input type="text" id="regFullName" name="fullName" placeholder="Full Name" required>
                        </div>
                    </div>

                    <!-- 2. Username -->
                    <div class="col-md-6">
                        <div class="form-floating-custom mb-2">
                            <i class="bi bi-person-badge input-icon-left"></i>
                            <input type="text" id="regUsername" name="username" placeholder="Username" required>
                        </div>
                    </div>

                    <!-- 3. Email -->
                    <div class="col-md-6">
                        <div class="form-floating-custom mb-2">
                            <i class="bi bi-envelope input-icon-left"></i>
                            <input type="email" id="regEmail" name="email" placeholder="Email Address" required>
                        </div>
                    </div>

                    <!-- 4. Phone Number -->
                    <div class="col-md-6">
                        <div class="form-floating-custom mb-2">
                            <i class="bi bi-telephone input-icon-left"></i>
                            <input type="tel" id="regPhone" name="phoneNumber" placeholder="Phone Number (10 digits)" pattern="[0-9]{10}" title="Please enter a valid 10-digit mobile number" required>
                        </div>
                    </div>

                    <!-- 5. Shipping Address -->
                    <div class="col-12">
                        <div class="form-floating-custom mb-2">
                            <i class="bi bi-geo-alt input-icon-left"></i>
                            <input type="text" id="regAddress" name="address" placeholder="Delivery / Street Address" required>
                        </div>
                    </div>

                    <!-- 6. City -->
                    <div class="col-md-6">
                        <div class="form-floating-custom mb-2">
                            <i class="bi bi-buildings input-icon-left"></i>
                            <input type="text" id="regCity" name="city" placeholder="City / Town" required>
                        </div>
                    </div>

                    <!-- 7. Pincode -->
                    <div class="col-md-6">
                        <div class="form-floating-custom mb-2">
                            <i class="bi bi-geo input-icon-left"></i>
                            <input type="text" id="regPincode" name="pincode" placeholder="Pincode (6 digits)" pattern="[0-9]{6}" title="Please enter a 6-digit postal code" required>
                        </div>
                    </div>

                    <!-- 8. Password -->
                    <div class="col-md-6">
                        <div class="form-floating-custom mb-2">
                            <i class="bi bi-lock-fill input-icon-left"></i>
                            <input type="password" id="regPassword" name="password" placeholder="Password" minlength="4" required>
                            <i class="bi bi-eye input-icon-right" id="toggleRegPass" onclick="togglePass('regPassword', this)"></i>
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="col-md-6">
                        <div class="form-floating-custom mb-2">
                            <i class="bi bi-shield-lock-fill input-icon-left"></i>
                            <input type="password" id="regConfirmPassword" name="confirmPassword" placeholder="Confirm Password" minlength="4" required>
                            <i class="bi bi-eye input-icon-right" id="toggleRegConfirmPass" onclick="togglePass('regConfirmPassword', this)"></i>
                        </div>
                    </div>
                </div>

                <div id="passMismatchAlert" class="alert alert-danger py-1 px-2 small mb-2 d-none">
                    <i class="bi bi-exclamation-triangle-fill me-1"></i> Passwords do not match!
                </div>

                <div class="form-check mb-3 mt-2">
                    <input class="form-check-input" type="checkbox" id="termsCheck" required checked>
                    <label class="form-check-label small text-muted" for="termsCheck">
                        I agree to the <a href="javascript:void(0)">Terms of Service</a> & <a href="javascript:void(0)">Privacy Policy</a>
                    </label>
                </div>

                <button type="submit" class="btn btn-modern-primary w-100 py-3 fs-6">
                    <i class="bi bi-check-circle-fill"></i> Create My Account
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    function switchAuthTab(tab) {
        const loginContainer = document.getElementById('loginFormContainer');
        const regContainer = document.getElementById('registerFormContainer');
        const loginTabBtn = document.getElementById('loginTabBtn');
        const regTabBtn = document.getElementById('registerTabBtn');
        const authCard = document.querySelector('.auth-card');

        if (tab === 'login') {
            loginContainer.style.display = 'block';
            regContainer.style.display = 'none';
            loginTabBtn.classList.add('active');
            regTabBtn.classList.remove('active');
            if (authCard) authCard.style.maxWidth = '480px';
        } else {
            loginContainer.style.display = 'none';
            regContainer.style.display = 'block';
            loginTabBtn.classList.remove('active');
            regTabBtn.classList.add('active');
            if (authCard) authCard.style.maxWidth = '620px';
        }
    }

    function togglePass(inputId, icon) {
        const input = document.getElementById(inputId);
        if (input.type === 'password') {
            input.type = 'text';
            icon.className = 'bi bi-eye-slash input-icon-right';
        } else {
            input.type = 'password';
            icon.className = 'bi bi-eye input-icon-right';
        }
    }

    function fillCredentials(user, pass) {
        document.getElementById('loginUsername').value = user;
        document.getElementById('loginPassword').value = pass;
        showToast('Credentials Loaded', `Loaded: ${user}`, 'info');
    }

    function validateRegisterForm() {
        const pass = document.getElementById('regPassword').value;
        const confirmPass = document.getElementById('regConfirmPassword').value;
        const alertBox = document.getElementById('passMismatchAlert');

        if (pass !== confirmPass) {
            alertBox.classList.remove('d-none');
            return false;
        }
        alertBox.classList.add('d-none');
        return true;
    }

    // Adjust card width if directly loaded on register tab
    document.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('tab') === 'register') {
            switchAuthTab('register');
        }
    });
</script>

<jsp:include page="footer.jsp" />
