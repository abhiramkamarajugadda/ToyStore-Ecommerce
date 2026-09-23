package com.codegnan.cgecom.service.impl;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.codegnan.cgecom.model.Product;
import com.codegnan.cgecom.repositories.ProductRepository;
import com.codegnan.cgecom.service.iface.ProductService;

@Service
public class ProductServiceImpl implements ProductService {

    @Value("${file.upload-dir:uploads/images/}")
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
        return null;
    }

    @Override
    public void saveProduct(Product product) {
        productRepository.save(product);
    }

    @Override
    public void deleteProduct(int id) {
        productRepository.deleteById(id);
    }

    @Override
    public String saveProductImage(MultipartFile imageFile) throws IOException {
        if (imageFile == null || imageFile.isEmpty()) {
            return null;
        }

        // Get original filename and extension
        String originalFilename = imageFile.getOriginalFilename();
        String extension = "";
        String baseName = "toy_product";

        if (originalFilename != null && !originalFilename.trim().isEmpty()) {
            int dotIndex = originalFilename.lastIndexOf(".");
            if (dotIndex != -1) {
                extension = originalFilename.substring(dotIndex);
                baseName = originalFilename.substring(0, dotIndex);
            } else {
                baseName = originalFilename;
                extension = ".jpg"; // fallback extension
            }
        } else {
            extension = ".jpg";
        }

        // Clean base name to avoid path traversal / illegal characters
        String cleanBaseName = baseName.replaceAll("[^a-zA-Z0-9_-]", "_");
        if (cleanBaseName.isEmpty()) {
            cleanBaseName = "toy_img";
        }

        // Create a unique, collision-proof filename
        String uniqueFileName = UUID.randomUUID().toString().substring(0, 8) + "_" + System.currentTimeMillis() + "_" + cleanBaseName + extension;

        // Resolve absolute destination path safely
        Path targetDir = Paths.get(uploadDir).toAbsolutePath().normalize();
        if (!Files.exists(targetDir)) {
            Files.createDirectories(targetDir);
        }

        Path destination = targetDir.resolve(uniqueFileName);

        // Copy input stream directly to avoid servlet container transferTo issues on Windows
        try (var inputStream = imageFile.getInputStream()) {
            Files.copy(inputStream, destination, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
        }

        return "/uploads/images/" + uniqueFileName;
    }

    @Override
    public List<Product> searchProducts(String query) {
        if (query == null || query.trim().isEmpty()) {
            return getAllProducts();
        }
        return productRepository.searchProducts(query.trim());
    }

    @Override
    public List<Product> getProductsByCategory(String category) {
        if (category == null || category.trim().equalsIgnoreCase("ALL") || category.trim().isEmpty()) {
            return getAllProducts();
        }
        return productRepository.findByCategoryIgnoreCase(category.trim());
    }

    @Override
    public long getTotalProductsCount() {
        return productRepository.count();
    }
}
