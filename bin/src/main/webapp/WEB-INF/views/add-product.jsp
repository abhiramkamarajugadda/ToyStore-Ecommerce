<!DOCTYPE html>
<html>
<head>
    <title>Add New Product</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/styles.css">
</head>
<body>
    <div class="container">
        <h1>Add New Product</h1>
        <form action="/products/add" method="post"  enctype="multipart/form-data" class="mt-3">
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
            
              <div class="form-group">
                     <label for="imageFile">Product Image</label>
              <input type="file" name="imageFile" id="imageFile" class="form-control-file">
             </div>
            
            
            <button type="submit" class="btn btn-primary">Add Product</button>
        </form>
        <a href="/products" class="btn btn-secondary mt-3">Back to Product List</a>
    </div>
</body>
</html>
