package com.codegnan.cgecom.controllers;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.codegnan.cgecom.model.Product;
import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.service.iface.ProductService;
import jakarta.servlet.http.HttpSession;

@Controller
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    // Display product catalog with optional search & category filter
    @GetMapping("/products")
    public String showProductList(@RequestParam(required = false) String search,
                                  @RequestParam(required = false) String category,
                                  HttpSession session, 
                                  Model model) {
        List<Product> products;
        if (search != null && !search.trim().isEmpty()) {
            products = productService.searchProducts(search.trim());
            model.addAttribute("currentSearch", search.trim());
        } else if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
            products = productService.getProductsByCategory(category.trim());
            model.addAttribute("currentCategory", category.trim());
        } else {
            products = productService.getAllProducts();
            model.addAttribute("currentCategory", "ALL");
        }

        List<String> categories = Arrays.asList("All", "Action & Vehicles", "Building & Construction", "Plush & Dolls", "Educational & STEM", "Board Games & Puzzles", "Outdoor & Sports");
        model.addAttribute("categories", categories);
        model.addAttribute("products", products);
        return "product-list";
    }

    // Show add product page (Admin Only)
    @GetMapping("/products/add")
    public String showAddProductPage(HttpSession session, RedirectAttributes redirectAttributes, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Admin access required.");
            return "redirect:/login";
        }
        model.addAttribute("product", new Product());
        return "add-product";
    }

    // Handle add product submission
    @PostMapping("/products/add")
    public String addNewProduct(@ModelAttribute Product product,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
            return "redirect:/login";
        }

        try {
            if (product.getImageFile() != null && !product.getImageFile().isEmpty()) {
                String imagePath = productService.saveProductImage(product.getImageFile());
                product.setImagePath(imagePath);
            }
            productService.saveProduct(product);
            redirectAttributes.addFlashAttribute("success", "Product \"" + product.getName() + "\" added successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Notice: Failed to upload product image: " + e.getMessage());
            return "redirect:/products/add";
        }

        return "redirect:/products";
    }

    // Show edit product page (Admin Only)
    @GetMapping("/products/edit/{id}")
    public String showEditProductPage(@PathVariable int id, 
                                      HttpSession session, 
                                      RedirectAttributes redirectAttributes, 
                                      Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Admin access required.");
            return "redirect:/login";
        }

        Product product = productService.getProductById(id);
        if (product == null) {
            redirectAttributes.addFlashAttribute("error", "Product not found.");
            return "redirect:/products";
        }

        model.addAttribute("product", product);
        return "edit-product";
    }

    // Handle update product submission
    @PostMapping("/products/edit/{id}")
    public String updateProduct(@PathVariable int id, 
                                @ModelAttribute Product product,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
            return "redirect:/login";
        }

        try {
            Product existingProduct = productService.getProductById(id);
            if (existingProduct == null) {
                redirectAttributes.addFlashAttribute("error", "Product not found.");
                return "redirect:/products";
            }

            if (product.getImageFile() != null && !product.getImageFile().isEmpty()) {
                String imagePath = productService.saveProductImage(product.getImageFile());
                product.setImagePath(imagePath);
            } else if (product.getImagePath() != null && !product.getImagePath().trim().isEmpty()) {
                product.setImagePath(product.getImagePath().trim());
            } else {
                product.setImagePath(existingProduct.getImagePath());
            }

            product.setId(id);
            productService.saveProduct(product);
            redirectAttributes.addFlashAttribute("success", "Product updated successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Notice: Failed to upload updated product image: " + e.getMessage());
            return "redirect:/products/edit/" + id;
        }

        return "redirect:/products";
    }

    // Delete product (Admin Only)
    @GetMapping("/products/delete/{id}")
    public String deleteProduct(@PathVariable int id, 
                                HttpSession session, 
                                RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Admin access required.");
            return "redirect:/login";
        }

        productService.deleteProduct(id);
        redirectAttributes.addFlashAttribute("success", "Product deleted successfully.");
        return "redirect:/products";
    }
}
