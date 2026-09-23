package com.codegnan.cgecom.controllers;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.service.iface.UserService;

@Controller
public class LoginController {

    private final UserService userService;

    public LoginController(UserService userService) {
        this.userService = userService;
    }

    
  

    // Display login page
    @GetMapping("/login")
    public String showLoginPage() {
        return "login"; // Login JSP
    }

    // Handle login form submission
    @PostMapping("/login")
    public String login(@RequestParam String username, @RequestParam String password, HttpSession session, Model model) {
        // Authenticate the user using the UserService
        User user = userService.authenticate(username, password);
        if (user != null) {
            // Store user object in session upon successful login
            session.setAttribute("loggedInUser", user);
            session.setAttribute("role", user.getRole());
            
            if ("ADMIN".equals(user.getRole())) {
                return "redirect:/admin/dashboard"; // Redirect admin to dashboard
            } else {
            	 return "redirect:/products"; // Redirect to product list
            }
            
            
           
        } else {
            // Show an error message on invalid login
            model.addAttribute("error", "Invalid credentials");
            return "login"; // Return to login page with error message
        }
    }

    // Handle logout and invalidate session
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // Clear session
        return "redirect:/login"; // Redirect to login page
    }
}
