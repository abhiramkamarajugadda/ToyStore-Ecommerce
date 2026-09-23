<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <title>Product List - Codegnan Ecom</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <div class="container">
        <h1 class="text-center">Product List</h1>
        
        <!-- Display a welcome message with username -->
        <c:if test="${loggedInUser != null}">
            <p class="text-right">Welcome, ${loggedInUser.username}! <a href="/logout" class="btn btn-danger btn-sm">Logout</a></p>
        </c:if>
        
        <!-- Table to display products -->
        <table class="table table-striped table-bordered">
            <thead class="thead-dark">
                <tr>
                    <th>Product ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Price</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="product" items="${products}">
                    <tr>
                        <td>${product.id}</td>
                        <td>${product.name}</td>
                        <td>${product.description}</td>
                        <td>${product.price}</td>
                        <td>
                            <!-- Add to Cart Form -->
                            <form action="/cart/add" method="post" class="d-inline">
                                <input type="hidden" name="productId" value="${product.id}">
                                <input type="number" name="quantity" value="1" min="1" class="form-control-sm d-inline" style="width: 60px;">
                                <button type="submit" class="btn btn-primary btn-sm">Add to Cart</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <!-- Link to Add Product (Admin Only) -->
        <c:if test="${loggedInUser.role == 'ADMIN'}">
            <a href="/products/add" class="btn btn-success mt-3">Add New Product</a>
        </c:if>
        
        <!-- Link to View Cart -->
        <a href="/cart" class="btn btn-secondary mt-3 float-right">View Cart</a>
    </div>
</body>
</html>
