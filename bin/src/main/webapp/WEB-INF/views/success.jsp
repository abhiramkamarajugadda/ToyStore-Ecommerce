<!-- success.jsp -->
<!DOCTYPE html>
<html>
<head>
    <title>Payment Success</title>
</head>
<body>
    <h1>Payment Successful!</h1>
    <p>Your payment ID is: <%= request.getAttribute("paymentId") %></p>
    <a href="/cart">Return to Cart</a>
</body>
</html>
