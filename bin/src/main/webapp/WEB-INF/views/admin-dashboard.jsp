<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <div class="container">
        <!-- Header -->
        <jsp:include page="header.jsp" />

        <h1 class="text-center my-4">Admin Dashboard</h1>

        <!-- Admin Options -->
        <div class="row">
            <div class="col-md-6">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Manage Users</h5>
                        <p class="card-text">Add, edit, or delete users from the system.</p>
                        <a href="/users" class="btn btn-primary">Go to Manage Users</a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Manage Products</h5>
                        <p class="card-text">Add, edit, or delete products in the store.</p>
                        <a href="/products" class="btn btn-primary">Go to Manage Products</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="footer.jsp" />
    </div>
</body>
</html>
