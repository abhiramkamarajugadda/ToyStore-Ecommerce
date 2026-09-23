<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Checkout Successful - Codegnan Ecom</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <div class="container">
        <h1 class="text-center mt-5">Thank you for your purchase!</h1>
        <p class="text-center">Your order has been successfully placed. Here are your order details:</p>

        <div class="row justify-content-center mt-3">
            <div class="col-md-8">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Product Name</th>
                            <th>Quantity</th>
                            <th>Price</th>
                            <th>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${order.orderItems}">
                            <tr>
                                <td>${item.product.name}</td>
                                <td>${item.quantity}</td>
                                <td>${item.price}</td>
                                <td>${item.price * item.quantity}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="mt-3">
                    <h4>Total Price: Rs. <c:out value="${order.totalPrice}"/></h4>
                    <p>We will process your order and notify you on email shortly.</p>
                </div>

                <div class="mt-4 text-center">
                    <a href="/products" class="btn btn-primary">Continue Shopping</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
