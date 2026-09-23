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
import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.service.iface.UserService;
import com.codegnan.cgecom.service.impl.EmailService;
@Controller
@RequestMapping("/users")
public class UserController {
	
	 @Autowired
	    private EmailService emailService;

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    // Display list of users
    @GetMapping
    public String listUsers(Model model) {
        List<User> users = userService.getAllUsers();
        model.addAttribute("users", users);
        return "user-list"; // JSP page to list users
    }

    // Show user creation form
    @GetMapping("/create")
    public String showCreateUserForm(Model model) {
        model.addAttribute("user", new User()); // For binding form input
        return "user-create"; // JSP page to create a new user
    }

    
    /*
    // Handle user creation form submission
    @PostMapping("/create")
    public String createUser(@ModelAttribute User user) {
    	 try {
             String subject = "Welcome to CgEcom!";
             String body = "<h1>Thank you for registering, " + user.getUsername() + "!</h1><p>We are glad to have you on board.</p>";
             emailService.sendEmail(user.getEmail(), subject, body);
             return "redirect:/login"; // Redirect to the login page
         } catch (Exception e) {
        	   model.addAttribute("error", "Failed to create user: " + e.getMessage());
               return "create-user"; // Return to the user creation page with an error message
         }

        userService.createUser(user.getUsername(), user.getPassword(), user.getRole(),user.getPhone_number(),user.getEmail());
        return "redirect:/users"; // After creating, redirect to user list
    }
    */
    
    
    
 // Handle user creation form submission
    @PostMapping("/create")
    public String createUser(@ModelAttribute User user, Model model) {
        try {
            // Save the user to the database
            userService.createUser(user.getUsername(), user.getPassword(), user.getRole(), user.getPhone_number(), user.getEmail());
            
            // Send a welcome email
            String subject = "Welcome to CgEcom!";
            String body = "<h1>Thank you for registering, " + user.getUsername() + "!</h1>"
                        + "<p>We are glad to have you on board.</p>";
            emailService.sendEmail(user.getEmail(), subject, body);

            // Redirect to the login page after successful registration
            return "redirect:/login";
        } catch (Exception e) {
            // Add an error message to the model and return to the registration page
            model.addAttribute("error", "Failed to create user: " + e.getMessage());
            return "create-user"; // Return to the user creation page with an error message
        }
    }

    
    
    

    // Show user edit form
    @GetMapping("/edit/{id}")
    public String showEditUserForm(@PathVariable("id") int id, Model model) {
        User user = userService.getUserById(id);
        model.addAttribute("user", user); // Populate form with existing user data
        return "user-edit"; // JSP page to edit the user
    }

    // Handle user update form submission
    @PostMapping("/update/{id}")
    public String updateUser(@PathVariable("id") int id, @ModelAttribute User user) {
        userService.updateUser(id, user.getUsername(), user.getPassword(), user.getRole(),user.getPhone_number(),user.getEmail());
        return "redirect:/users"; // After updating, redirect to user list
    }

    // Handle user deletion
    @GetMapping("/delete/{id}")
    public String deleteUser(@PathVariable("id") int id) {
        userService.deleteUser(id);
        return "redirect:/users"; // After deleting, redirect to user list
    }
    
    
}
