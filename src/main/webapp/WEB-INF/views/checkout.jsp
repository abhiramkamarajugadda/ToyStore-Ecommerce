<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout</title>
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
</head>
<body>
    <h1>Payment Checkout</h1>
    <button id="rzp-button">Pay Now</button>

    <form id="verifyForm" method="POST" action="/payment/verify">
        <input type="hidden" name="razorpayPaymentId" id="razorpayPaymentId">
        <input type="hidden" name="razorpayOrderId" id="razorpayOrderId">
        <input type="hidden" name="razorpaySignature" id="razorpaySignature">
    </form>

    <script>
        var options = {
            "key": "${razorpayKey}",
            "amount": "${amount}",
            "currency": "INR",
            "name": "My E-Commerce",
            "description": "Test Transaction",
            "order_id": "${razorpayOrderId}",
            "handler": function (response) {
                // The server verifies the Razorpay signature before treating the payment as successful.
                document.getElementById('razorpayPaymentId').value = response.razorpay_payment_id;
                document.getElementById('razorpayOrderId').value = response.razorpay_order_id;
                document.getElementById('razorpaySignature').value = response.razorpay_signature;
                document.getElementById('verifyForm').submit();
            },
            "theme": {
                "color": "#3399cc"
            }
        };
        var rzp = new Razorpay(options);
        document.getElementById('rzp-button').onclick = function (e) {
            rzp.open();
            e.preventDefault();
        }
    </script>
</body>
</html>
