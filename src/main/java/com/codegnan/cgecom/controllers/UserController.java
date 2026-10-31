package com.codegnan.cgecom.controllers;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.service.iface.UserService;
import com.codegnan.cgecom.service.impl.EmailService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/users")
public class UserController {

    @Autowired(required = false)
    private EmailService emailService;

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    // Display list of users (Admin only)
    @GetMapping
    public String listUsers(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Admin access required.");
            return "redirect:/login";
        }

        List<User> users = userService.getAllUsers();
        model.addAttribute("users", users);
        return "user-list";
    }

    // Show user creation form
    @GetMapping("/create")
    public String showCreateUserForm(Model model) {
        model.addAttribute("user", new User());
        return "user-create";
    }

    // Handle user creation form submission
    @PostMapping("/create")
    public String createUser(@ModelAttribute User user, 
                             HttpSession session,
                             RedirectAttributes redirectAttributes, 
                             Model model) {
        try {
            if (userService.isUsernameTaken(user.getUsername())) {
                model.addAttribute("error", "Username \"" + user.getUsername() + "\" is already taken.");
                return "user-create";
            }

            // Only an admin may choose a role; everyone else is created as a normal USER
            User creator = (User) session.getAttribute("loggedInUser");
            boolean creatorIsAdmin = creator != null && "ADMIN".equals(creator.getRole());
            String role = creatorIsAdmin && user.getRole() != null ? user.getRole() : "USER";

            // Save the user to the database with all fields
            userService.createUser(
                user.getFullName(),
                user.getUsername(), 
                user.getPassword(), 
                role, 
                user.getPhone_number(), 
                user.getEmail(),
                user.getAddress(),
                user.getCity(),
                user.getPincode()
            );

            // Send a welcome email safely
            if (emailService != null && user.getEmail() != null && !user.getEmail().trim().isEmpty()) {
                try {
                    emailService.sendWelcomeEmail(user.getEmail().trim(), user.getFullName(), user.getUsername());
                } catch (Exception mailEx) {
                    System.err.println("Note: Welcome email could not be sent (SMTP off/mock): " + mailEx.getMessage());
                }
            }

            User loggedInUser = (User) session.getAttribute("loggedInUser");
            if (loggedInUser != null && "ADMIN".equals(loggedInUser.getRole())) {
                redirectAttributes.addFlashAttribute("success", "User \"" + user.getUsername() + "\" created successfully.");
                return "redirect:/users";
            } else {
                redirectAttributes.addFlashAttribute("success", "Registration successful! You can now log in.");
                return "redirect:/login";
            }
        } catch (Exception e) {
            model.addAttribute("error", "Failed to create user: " + e.getMessage());
            return "user-create";
        }
    }

    // Show user edit form
    @GetMapping("/edit/{id}")
    public String showEditUserForm(@PathVariable("id") int id, 
                                   HttpSession session, 
                                   RedirectAttributes redirectAttributes, 
                                   Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || (!"ADMIN".equals(loggedInUser.getRole()) && loggedInUser.getId() != id)) {
            redirectAttributes.addFlashAttribute("error", "Unauthorized to edit user.");
            return "redirect:/login";
        }

        User user = userService.getUserById(id);
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "User not found.");
            return "redirect:/users";
        }
        model.addAttribute("user", user);
        return "user-edit";
    }

    // Handle user update form submission
    @PostMapping("/update/{id}")
    public String updateUser(@PathVariable("id") int id, 
                             @ModelAttribute User user,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || (!"ADMIN".equals(loggedInUser.getRole()) && loggedInUser.getId() != id)) {
            redirectAttributes.addFlashAttribute("error", "Unauthorized action.");
            return "redirect:/login";
        }

        userService.updateUser(
            id, 
            user.getFullName(), 
            user.getUsername(), 
            user.getPassword(), 
            "ADMIN".equals(loggedInUser.getRole()) ? user.getRole() : null, // users cannot change their own role
            user.getPhone_number(), 
            user.getEmail(), 
            user.getAddress(), 
            user.getCity(), 
            user.getPincode()
        );
        redirectAttributes.addFlashAttribute("success", "User \"" + user.getUsername() + "\" updated successfully.");

        if (loggedInUser != null && "ADMIN".equals(loggedInUser.getRole())) {
            return "redirect:/users";
        }
        return "redirect:/products";
    }

    // Handle user deletion (Admin only)
    @GetMapping("/delete/{id}")
    public String deleteUser(@PathVariable int id, 
                             HttpSession session, 
                             RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Admin access required.");
            return "redirect:/login";
        }

        userService.deleteUser(id);
        redirectAttributes.addFlashAttribute("success", "User deleted successfully.");
        return "redirect:/users";
    }
}
