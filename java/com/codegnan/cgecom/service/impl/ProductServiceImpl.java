package com.codegnan.cgecom.service.impl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.codegnan.cgecom.model.Product;
import com.codegnan.cgecom.repositories.ProductRepository;
import com.codegnan.cgecom.service.iface.ProductService;

@Service
public class ProductServiceImpl implements ProductService {
	
	
	// Injecting the upload directory from application.properties
    @Value("${file.upload-dir}")
    private String uploadDir;

    private final ProductRepository productRepository;

    public ProductServiceImpl(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Override
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    @Override
    public Product getProductById(int id) {
        Optional<Product> product = productRepository.findById(id);
        if (product.isPresent()) {
            return product.get();
        }
        throw new RuntimeException("Product not found with ID: " + id);
    }

    @Override
    public void saveProduct(Product product) {
        productRepository.save(product);
    }

    @Override
    public void deleteProduct(int id) {
        productRepository.deleteById(id);
    }

	/*
	 * @Override public void updateProductStock(int productId, int quantity) {
	 * Product product = getProductById(productId); // int updatedStock =
	 * product.getStock() - quantity; if (updatedStock < 0) { throw new
	 * RuntimeException("Insufficient stock for product ID: " + productId); } //
	 * product.setStock(updatedStock); productRepository.save(product); }
	 */
    
    
    // Method to save product image
    public String saveProductImage(MultipartFile imageFile) throws IOException {
        // Create a path using the directory from properties
        Path path = Paths.get(uploadDir, imageFile.getOriginalFilename());

        // Create the directory if it doesn't exist
        Files.createDirectories(path.getParent());

        // Transfer the file to the specified path
        imageFile.transferTo(path);

        // Return the relative path to the saved image
        return path.toString();
    }
    
   

   
    
    
    
}
