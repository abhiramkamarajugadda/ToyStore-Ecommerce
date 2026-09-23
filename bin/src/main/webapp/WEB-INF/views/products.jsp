<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
   
      <title>Products</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="/styles.css">
   
   
   
</head>
<body>
    <div class="container">
        <!-- Product List Section -->
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

        <!-- Add Product Form Section -->
        <h2 class="mt-5">Add New Product</h2>
        <form action="/products/add" method="post" class="mt-3">
            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="description">Description:</label>
                <textarea id="description" name="description" class="form-control" rows="3" required></textarea>
            </div>
            <div class="form-group">
                <label for="price">Price:</label>
                <input type="number" id="price" name="price" class="form-control" step="0.01" required>
            </div>
            
         
             
            <button type="submit" class="btn btn-primary">Add Product</button>
        </form>

        <!-- Navigation Links -->
        <div class="mt-4">
            <a href="/cart" class="btn btn-secondary nav-link">View Cart</a>
            <a href="/logout" class="btn btn-danger nav-link">Logout</a>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.4.4/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>