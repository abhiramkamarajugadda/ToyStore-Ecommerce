<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User</title>
 <link rel="stylesheet" href="/styles.css"> <!-- Link to the shared styles.css -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1>Edit User</h1>
        <form action="/users/update/${user.id}" method="post">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" class="form-control" value="${user.username}" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" class="form-control" value="${user.password}" required>
            </div>
            <div class="form-group">
                <label for="role">Role:</label>
                <select id="role" name="role" class="form-control" required>
                    <option value="USER" ${user.role == 'USER' ? 'selected' : ''}>User</option>
                    <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="phone_number">Phone Number:</label>
                <input type="text" id="phone_number" name="phone_number" class="form-control" value="${user.phone_number}" required>
            </div>
            
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="text" id="email" name="email" class="form-control" value="${user.email}" required>
            </div>
            
            
            
            <button type="submit" class="btn btn-primary">Update User</button>
        </form>
        <a href="/users" class="btn btn-secondary mt-3">Back to User List</a>
    </div>
</body>
</html>
