<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add User</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css"> <!-- Link to shared styles -->
</head>
<body>
    <div class="container">
        <h1 class="text-center">Add New User</h1>
        <p class="text-center">Fill in the details below to create a new user.</p>

        <div class="row justify-content-center">
            <div class="col-md-6">
                <form action="/register" method="post" class="mt-4">
                    <div class="form-group">
                        <label for="username">Username:</label>
                        <input type="text" id="username" name="username" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="role">Role:</label>
                        <select id="role" name="role" class="form-control" required>
                            <option value="USER">User</option>
                            <option value="ADMIN">Admin</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Add User</button>
                </form>

                <div class="mt-3 text-center">
                    <a href="/login" class="btn btn-link">Back to Login</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
