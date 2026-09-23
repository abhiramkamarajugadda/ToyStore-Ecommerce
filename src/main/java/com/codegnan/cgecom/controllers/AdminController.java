package com.codegnan.cgecom.controllers;

import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.codegnan.cgecom.model.Order;
import com.codegnan.cgecom.model.Product;
import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.service.iface.OrderService;
import com.codegnan.cgecom.service.iface.ProductService;
import com.codegnan.cgecom.service.iface.UserService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final OrderService orderService;
    private final ProductService productService;
    private final UserService userService;

    public AdminController(OrderService orderService, ProductService productService, UserService userService) {
        this.orderService = orderService;
        this.productService = productService;
        this.userService = userService;
    }

    @GetMapping("/dashboard")
    public String adminDashboard(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Admin access required.");
            return "redirect:/login";
        }

        double totalRevenue = orderService.getTotalRevenue();
        long totalOrders = orderService.getTotalOrdersCount();
        long totalProducts = productService.getTotalProductsCount();
        long totalUsers = userService.getTotalUsersCount();

        List<Order> allOrders = orderService.getAllOrders();
        List<Product> products = productService.getAllProducts();
        List<User> users = userService.getAllUsers();

        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("totalOrders", totalOrders);
        model.addAttribute("totalProducts", totalProducts);
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("orders", allOrders);
        model.addAttribute("products", products);
        model.addAttribute("users", users);

        return "admin-dashboard";
    }

    @PostMapping("/orders/status/{id}")
    public String updateOrderStatus(@PathVariable int id, 
                                    @RequestParam String status, 
                                    HttpSession session, 
                                    RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
            return "redirect:/login";
        }

        orderService.updateOrderStatus(id, status);
        redirectAttributes.addFlashAttribute("success", "Order #" + id + " status updated to " + status);
        return "redirect:/admin/dashboard";
    }
}