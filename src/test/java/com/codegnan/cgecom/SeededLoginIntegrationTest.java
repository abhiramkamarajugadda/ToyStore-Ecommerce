package com.codegnan.cgecom;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.repositories.UserRepository;
import com.codegnan.cgecom.service.iface.UserService;

/** Boots the full app on H2 and checks the seeded demo accounts still sign in with BCrypt. */
@SpringBootTest
@ActiveProfiles("test")
class SeededLoginIntegrationTest {

    @Autowired private UserService userService;
    @Autowired private UserRepository userRepository;

    @Test
    void seededDemoUsersAreHashedAndCanSignIn() {
        User admin = userRepository.findByUsername("admin");
        assertThat(admin).isNotNull();
        assertThat(admin.getPassword()).startsWith("$2").isNotEqualTo("admin123");

        assertThat(userService.authenticate("admin", "admin123")).isNotNull();
        assertThat(userService.authenticate("user", "user123")).isNotNull();
        assertThat(userService.authenticate("admin", "wrong")).isNull();
    }
}
