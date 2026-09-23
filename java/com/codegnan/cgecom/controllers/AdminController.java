package com.codegnan.cgecom.controllers;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import jakarta.servlet.http.HttpSession;
@Controller
@RequestMapping("/admin")
public class AdminController {
    @GetMapping("/dashboard")
    public String adminDashboard(HttpSession session) {
        // Check if the logged-in user is an admin
        String role = (String) session.getAttribute("role");
        if ("ADMIN".equals(role)) {
            return "admin-dashboard"; // Render the admin dashboard page
        } else {
            return "redirect:/login"; // Redirect non-admins to the login page
        }
    }
}