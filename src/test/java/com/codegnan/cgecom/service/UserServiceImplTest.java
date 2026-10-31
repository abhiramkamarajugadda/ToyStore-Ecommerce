package com.codegnan.cgecom.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.repositories.UserRepository;
import com.codegnan.cgecom.service.impl.UserServiceImpl;

@ExtendWith(MockitoExtension.class)
class UserServiceImplTest {

    @Mock
    private UserRepository userRepository;

    private final PasswordEncoder encoder = new BCryptPasswordEncoder(4);
    private UserServiceImpl userService;

    @BeforeEach
    void setUp() {
        userService = new UserServiceImpl(userRepository, encoder);
    }

    private User user(String username, String password) {
        User u = new User();
        u.setId(7);
        u.setUsername(username);
        u.setPassword(password);
        u.setRole("USER");
        return u;
    }

    @Test
    void createUserStoresBcryptHashNotPlainText() {
        when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

        User saved = userService.createUser("Asha", "asha", "secret123", "USER",
                "9876543210", "asha@example.com", "Street 1", "Vijayawada", "520001");

        assertThat(saved.getPassword()).isNotEqualTo("secret123").startsWith("$2");
        assertThat(encoder.matches("secret123", saved.getPassword())).isTrue();
    }

    @Test
    void authenticateAcceptsCorrectPasswordAgainstHash() {
        when(userRepository.findByUsername("asha")).thenReturn(user("asha", encoder.encode("secret123")));

        assertThat(userService.authenticate("asha", "secret123")).isNotNull();
        assertThat(userService.authenticate("asha", "wrong-pass")).isNull();
        verify(userRepository, never()).save(any());
    }

    @Test
    void authenticateReturnsNullForUnknownUser() {
        when(userRepository.findByUsername("ghost")).thenReturn(null);
        assertThat(userService.authenticate("ghost", "anything")).isNull();
    }

    @Test
    void authenticateUpgradesLegacyPlainTextPassword() {
        User legacy = user("old", "plain123");
        when(userRepository.findByUsername("old")).thenReturn(legacy);

        assertThat(userService.authenticate("old", "plain123")).isNotNull();

        ArgumentCaptor<User> captor = ArgumentCaptor.forClass(User.class);
        verify(userRepository).save(captor.capture());
        assertThat(captor.getValue().getPassword()).startsWith("$2");
        assertThat(encoder.matches("plain123", captor.getValue().getPassword())).isTrue();
    }

    @Test
    void updateUserKeepsExistingHashWhenPasswordBlank() {
        String hash = encoder.encode("keepme");
        User existing = user("asha", hash);
        when(userRepository.findById(7)).thenReturn(Optional.of(existing));

        userService.updateUser(7, "Asha", "asha", "", "USER", "9876543210", "a@example.com", null, null, null);

        assertThat(existing.getPassword()).isEqualTo(hash);
    }

    @Test
    void updateUserHashesNewPassword() {
        User existing = user("asha", encoder.encode("old-pass"));
        when(userRepository.findById(7)).thenReturn(Optional.of(existing));

        userService.updateUser(7, "Asha", "asha", "new-pass", "USER", "9876543210", "a@example.com", null, null, null);

        assertThat(encoder.matches("new-pass", existing.getPassword())).isTrue();
    }
}
