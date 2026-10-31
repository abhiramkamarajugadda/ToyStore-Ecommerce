<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Cart - Codegnan Ecom</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
</head>
<body>
    <div class="container">
        <h1 class="text-center">Your Cart</h1>
        <c:if test="${not empty cartItems}">
            <table class="table table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Subtotal</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${cartItems}">
                        <tr>
                            <td>${item.product.name}</td>
                            <td>${item.price}</td>
                            <td>
                                <form action="/cart/update" method="post">
                                    <input type="hidden" name="productId" value="${item.product.id}">
                                    <input type="number" name="quantity" value="${item.quantity}" min="0" class="form-control d-inline" style="width: 70px;">
                                    <button type="submit" class="btn btn-primary btn-sm">Update</button>
                                </form>
                            </td>
                            <td>${item.price * item.quantity}</td>
                            <td>
                                <form action="/cart/update" method="post">
                                    <input type="hidden" name="productId" value="${item.product.id}">
                                    <input type="hidden" name="quantity" value="0">
                                    <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <h4 class="text-right">Total: ${totalPrice}</h4>
            <button id="checkoutButton" class="btn btn-success">Checkout</button>
        </c:if>
        <c:if test="${empty cartItems}">
            <p class="text-center">Your cart is empty. <a href="/products">Continue Shopping</a></p>
        </c:if>

        <div class="mt-4">
            <a href="/products" class="btn btn-primary btn-block">Continue Shopping</a>
        </div>
    </div>

    <!-- Razorpay JavaScript Integration -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            document.getElementById("checkoutButton").onclick = function (e) {
                e.preventDefault();

                // Make an AJAX call to your backend to create the Razorpay order
                fetch('/cart/razorpayOrder', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data && data.id) {
                        // Initialize Razorpay payment
                        const options = {
                            key: data.key, // Razorpay key ID from RAZORPAY_KEY_ID
                            amount: data.amount, // Amount in paise
                            currency: data.currency,
                            name: "CGEcom",
                            description: "Order Payment",
                            order_id: data.id, // Razorpay order ID
                            handler: function (response) {
                                alert("Payment Successful! Payment ID: " + response.razorpay_payment_id);
                                window.location.href = "/cart/payment-success";
                            },
                            prefill: {
                                name: "Customer Name",
                                email: "customer@example.com",
                                contact: "1234567890"
                            },
                            theme: {
                                color: "#3399cc"
                            }
                        };

                        const razorpay = new Razorpay(options);
                        razorpay.open();
                    } else {
                        alert("Failed to create Razorpay order.");
                    }
                })
                .catch(error => {
                    console.error("Error creating Razorpay order:", error);
                    alert("An error occurred while processing your payment.");
                });
            };
        });
    </script>
</body>
</html>
