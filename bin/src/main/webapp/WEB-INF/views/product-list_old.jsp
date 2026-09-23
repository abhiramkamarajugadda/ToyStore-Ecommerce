<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <title>Product List</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <div class="container">
        <h1>Product List</h1>
        <table class="table table-striped table-bordered">
            <thead class="thead-dark">
                <tr>
                    <th>Product ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Price</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="product" items="${products}">
                    <tr>
                        <td>${product.id}</td>
                        <td>${product.name}</td>
                        <td>${product.description}</td>
                        <td>${product.price}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <a href="/products/add" class="btn btn-primary mt-3">Add New Product</a>
        <a href="/cart" class="btn btn-secondary mt-3">View Cart</a>
        <a href="/logout" class="btn btn-danger mt-3">Logout</a>
    </div>
</body>
</html>