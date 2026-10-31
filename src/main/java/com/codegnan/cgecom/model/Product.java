package com.codegnan.cgecom.model;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

import org.springframework.web.multipart.MultipartFile;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

@Entity
@Table(name = "product")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @NotBlank(message = "Product name is required.")
    @Size(max = 255, message = "Product name must be at most 255 characters.")
    private String name;
    
    @Column(length = 1000)
    @Size(max = 1000, message = "Description must be at most 1000 characters.")
    private String description;
    
    @Positive(message = "Price must be greater than zero.")
    private double price;
    
    @Column(name = "image_path")
    private String imagePath;
    
    @Column(name = "category")
    private String category = "Electronics";

    @Transient
    private MultipartFile imageFile;

    public Product() {
    }

    public Product(int id, String name, String description, double price, String imagePath, String category) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.imagePath = imagePath;
        this.category = category != null ? category : "Electronics";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getCategory() {
        return (category == null || category.trim().isEmpty()) ? "Electronics" : category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public MultipartFile getImageFile() {
        return imageFile;
    }

    public void setImageFile(MultipartFile imageFile) {
        this.imageFile = imageFile;
    }

    /**
     * Returns a browser-friendly URL for the product image,
     * ensuring proper slashes and falling back to a clean placeholder.
     */
    public String getDisplayImagePath() {
        if (imagePath == null || imagePath.trim().isEmpty()) {
            return "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=60";
        }
        String normalized = imagePath.replace("\\", "/");
        if (normalized.startsWith("http://") || normalized.startsWith("https://")) {
            return normalized;
        }
        if (!normalized.startsWith("/")) {
            normalized = "/" + normalized;
        }
        return normalized;
    }
}
