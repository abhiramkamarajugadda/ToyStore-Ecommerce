package com.codegnan.cgecom.controllers;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.verify;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;

import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.service.iface.UserService;
import com.codegnan.cgecom.service.impl.EmailService;

/** Visitors and normal users must never be able to grant themselves the ADMIN role. */
@WebMvcTest(UserController.class)
class UserControllerTest {

    @Autowired private MockMvc mockMvc;
    @MockBean private UserService userService;
    @MockBean private EmailService emailService;

    @Test
    void anonymousSignupCannotChooseAdminRole() throws Exception {
        mockMvc.perform(post("/users/create")
                        .param("username", "mallory")
                        .param("password", "secret123")
                        .param("role", "ADMIN"))
                .andExpect(status().is3xxRedirection());

        verify(userService).createUser(any(), eq("mallory"), eq("secret123"), eq("USER"),
                any(), any(), any(), any(), any());
    }

    @Test
    void userEditingOwnProfileCannotChangeRole() throws Exception {
        User self = new User();
        self.setId(7);
        self.setUsername("user");
        self.setRole("USER");
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loggedInUser", self);

        mockMvc.perform(post("/users/update/7").session(session)
                        .param("username", "user")
                        .param("role", "ADMIN"))
                .andExpect(status().is3xxRedirection());

        verify(userService).updateUser(anyInt(), any(), eq("user"), any(), isNull(),
                any(), any(), any(), any(), any());
    }
}
