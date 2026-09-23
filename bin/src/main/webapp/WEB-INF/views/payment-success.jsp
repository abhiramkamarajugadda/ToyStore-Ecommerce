<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Payment Success</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1 class="text-center">Payment Successful!</h1>
        <p class="text-center">Thank you for your purchase! Your order has been successfully placed.</p>

        <!-- Display success message -->
        <p class="text-center">${message}</p>

        <div class="text-center">
            <a href="/products" class="btn btn-secondary">Continue Shopping</a>
        </div>
    </div>
</body>
</html>
