<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login - Codegnan Ecom</title> <!-- Add Project Title -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css"> <!-- Link to the shared styles.css -->
</head>
<body>
    <div class="container">
        <h1 class="text-center">Codegnan Ecom</h1> <!-- Welcoming message -->
        <p class="text-center">Please log in to continue</p>
        
        <div class="row justify-content-center">
            <div class="col-md-6">
                <!-- Display error message if login fails -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger text-center">
                        ${error} <!-- Display the error message -->
                    </div>
                </c:if>
                
                <!-- Login Form -->
                <form action="/login" method="post" class="mt-4">
                    <div class="form-group">
                        <label for="username">Username:</label>
                        <input type="text" id="username" name="username" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Login</button>
                </form>
                
                <!-- Additional Links -->
                <div class="mt-3 text-center">
                    <a href="/users/create" class="btn btn-link">Create an account</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
