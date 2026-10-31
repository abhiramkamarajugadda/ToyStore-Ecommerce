package com.codegnan.cgecom.controllers;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.codegnan.cgecom.dto.RegistrationForm;

import jakarta.validation.Valid;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.service.iface.UserService;

@Controller
public class LoginController {

	private final UserService userService;
	private final com.codegnan.cgecom.service.impl.EmailService emailService;

	public LoginController(UserService userService, com.codegnan.cgecom.service.impl.EmailService emailService) {
		this.userService = userService;
		this.emailService = emailService;
	}

	// Root mapping
	@GetMapping("/")
	public String index(HttpSession session) {
		User loggedInUser = (User) session.getAttribute("loggedInUser");
		if (loggedInUser != null) {
			if ("ADMIN".equals(loggedInUser.getRole())) {
				return "redirect:/admin/dashboard";
			}
			return "redirect:/products";
		}
		return "redirect:/products";
	}

	// Display login page
	@GetMapping("/login")
	public String showLoginPage(HttpSession session) {
		User loggedInUser = (User) session.getAttribute("loggedInUser");
		if (loggedInUser != null) {
			if ("ADMIN".equals(loggedInUser.getRole())) {
				return "redirect:/admin/dashboard";
			}
			return "redirect:/products";
		}
		return "login";
	}

	// Handle login form submission
	@PostMapping("/login")
	public String login(@RequestParam String username, @RequestParam String password, HttpSession session,
			Model model) {
		User user = userService.authenticate(username, password);
		if (user != null) {
			session.setAttribute("loggedInUser", user);
			session.setAttribute("role", user.getRole());

			if ("ADMIN".equals(user.getRole())) {
				return "redirect:/admin/dashboard";
			} else {
				return "redirect:/products";
			}
		} else {
			model.addAttribute("error", "Invalid username or password. Please try again.");
			return "login";
		}
	}

	// Display register page
	@GetMapping("/register")
	public String showRegisterPage() {
		return "login"; // Will switch to register tab or show register card
	}

	// Handle full 8-field registration
	@PostMapping("/register")
	public String registerUser(@Valid @ModelAttribute RegistrationForm form, BindingResult bindingResult,
			RedirectAttributes redirectAttributes) {
		if (bindingResult.hasErrors()) {
			redirectAttributes.addFlashAttribute("error", bindingResult.getAllErrors().get(0).getDefaultMessage());
			return "redirect:/login?tab=register";
		}
		String fullName = form.getFullName(), username = form.getUsername().trim(), email = form.getEmail().trim();
		String password = form.getPassword(), confirmPassword = form.getConfirmPassword();
		if (confirmPassword != null && !confirmPassword.trim().isEmpty() && !confirmPassword.equals(password)) {
			redirectAttributes.addFlashAttribute("error", "Passwords do not match! Please check and try again.");
			return "redirect:/login?tab=register";
		}

		if (userService.isUsernameTaken(username)) {
			redirectAttributes.addFlashAttribute("error",
					"Username \"" + username + "\" is already taken! Please choose another.");
			return "redirect:/login?tab=register";
		}

		userService.createUser(fullName, username, password, "USER", form.getPhoneNumber(), email, form.getAddress(),
				form.getCity(), form.getPincode());

		// Send Welcome Email to registered email address asynchronously
		if (emailService != null && email != null && !email.trim().isEmpty()) {
			try {
				emailService.sendWelcomeEmail(email.trim(), fullName, username);
			} catch (Exception mailEx) {
				System.err.println("Notice: Welcome email could not be queued: " + mailEx.getMessage());
			}
		}

		redirectAttributes.addFlashAttribute("success",
				"Welcome, " + (fullName != null && !fullName.isEmpty() ? fullName : username)
						+ "! Your account was created successfully. A welcome confirmation has been sent to " + email
						+ ". Please sign in.");
		return "redirect:/login";
	}

	// Handle logout and invalidate session
	@GetMapping("/logout")
	public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
		session.invalidate();
		redirectAttributes.addFlashAttribute("info", "You have been logged out successfully.");
		return "redirect:/login";
	}
}
