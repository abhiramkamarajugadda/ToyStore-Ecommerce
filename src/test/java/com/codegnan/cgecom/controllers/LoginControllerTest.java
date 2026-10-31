package com.codegnan.cgecom.controllers;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.flash;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.service.iface.UserService;
import com.codegnan.cgecom.service.impl.EmailService;

@WebMvcTest(LoginController.class)
class LoginControllerTest {

    @Autowired private MockMvc mockMvc;
    @MockBean private UserService userService;
    @MockBean private EmailService emailService;

    @Test
    void adminLoginRedirectsToDashboard() throws Exception {
        User admin = new User();
        admin.setUsername("admin");
        admin.setRole("ADMIN");
        when(userService.authenticate("admin", "admin123")).thenReturn(admin);

        mockMvc.perform(post("/login").param("username", "admin").param("password", "admin123"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/dashboard"))
                .andExpect(request().sessionAttribute("role", "ADMIN"));
    }

    @Test
    void wrongPasswordShowsLoginPageAgain() throws Exception {
        when(userService.authenticate("admin", "nope")).thenReturn(null);

        mockMvc.perform(post("/login").param("username", "admin").param("password", "nope"))
                .andExpect(status().isOk())
                .andExpect(view().name("login"));
    }

    @Test
    void registrationWithInvalidEmailIsRejectedByValidation() throws Exception {
        mockMvc.perform(post("/register")
                        .param("username", "newuser")
                        .param("email", "not-an-email")
                        .param("phoneNumber", "9876543210")
                        .param("password", "secret123"))
                .andExpect(redirectedUrl("/login?tab=register"))
                .andExpect(flash().attribute("error", "Please enter a valid email address."));

        verify(userService, never()).createUser(any(), any(), any(), any(), any(), any(), any(), any(), any());
    }

    @Test
    void registrationWithShortPasswordIsRejected() throws Exception {
        mockMvc.perform(post("/register")
                        .param("username", "newuser")
                        .param("email", "new@example.com")
                        .param("phoneNumber", "9876543210")
                        .param("password", "123"))
                .andExpect(redirectedUrl("/login?tab=register"))
                .andExpect(flash().attribute("error", "Password must be 6 to 72 characters."));
    }

    @Test
    void validRegistrationCreatesUser() throws Exception {
        when(userService.isUsernameTaken("newuser")).thenReturn(false);

        mockMvc.perform(post("/register")
                        .param("fullName", "New User")
                        .param("username", "newuser")
                        .param("email", "new@example.com")
                        .param("phoneNumber", "9876543210")
                        .param("pincode", "520001")
                        .param("password", "secret123")
                        .param("confirmPassword", "secret123"))
                .andExpect(redirectedUrl("/login"));

        verify(userService).createUser(eq("New User"), eq("newuser"), eq("secret123"), eq("USER"),
                eq("9876543210"), eq("new@example.com"), any(), any(), eq("520001"));
        verify(emailService).sendWelcomeEmail(anyString(), anyString(), anyString());
    }
}
