<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="header.jsp" %> <!-- Include the header -->

<!DOCTYPE html>
<html>
<head>
    <title>Product List - Codegnan Ecom</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <div class="container">
        <h1 class="text-center my-4">Product List</h1>

        <!-- Welcome Message -->
      <%--   <c:if test="${loggedInUser != null}">
            <p class="text-right">Welcome, ${loggedInUser.username}! 
                <a href="/logout" class="btn btn-danger btn-sm">Logout</a>
            </p>
        </c:if> --%>
        
        <!-- Link to Add Product (Admin Only) -->
        <c:if test="${loggedInUser.role == 'ADMIN'}">
            <a href="/products/add" class="btn btn-success mt-3 mb-3">Add New Product</a>
        </c:if>

        <!-- Products Grid -->
        <div class="row">
            <c:forEach var="product" items="${products}">
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <!-- Product Image -->
                        <img src="${product.imagePath}" class="card-img-top" alt="${product.name}" style="height: 200px; object-fit: cover;">
                        
                        <div class="card-body">
                            <!-- Product Name -->
                            <h5 class="card-title">${product.name}</h5>
                            
                            <!-- Product Description -->
                            <p class="card-text text-truncate">${product.description}</p>
                            
                            <!-- Product Price -->
                            <p class="text-primary font-weight-bold">${product.price}</p>
                        </div>
                        
                        <div class="card-footer bg-transparent border-0">
                            <!-- Add to Cart and View Cart buttons (Only for User) -->
                            <c:if test="${loggedInUser.role != 'ADMIN'}">
                                <!-- Add to Cart Form -->
                                <form action="/cart/add" method="post" class="d-inline">
                                    <input type="hidden" name="productId" value="${product.id}">
                                    <input type="number" name="quantity" value="1" min="1" class="form-control-sm d-inline" style="width: 60px;">
                                    <button type="submit" class="btn btn-primary btn-sm">Add to Cart</button>
                                </form>
                            </c:if>
                            
                            <!-- Admin Actions (Edit & Delete) -->
                            <c:if test="${loggedInUser.role == 'ADMIN'}">
                                <!-- Edit Button -->
                                <a href="/products/edit/${product.id}" class="btn btn-warning btn-sm mt-2">Edit</a>
                                
                                <!-- Delete Button -->
                                <a href="/products/delete/${product.id}" class="btn btn-danger btn-sm mt-2">Delete</a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Link to View Cart (Only for User) -->
        <c:if test="${loggedInUser.role != 'ADMIN'}">
            <a href="/cart" class="btn btn-secondary mt-3 float-right">View Cart</a>
        </c:if>
    </div>
    
       <%@ include file="footer.jsp" %> <!-- Include the footer -->
</body>
</html>
