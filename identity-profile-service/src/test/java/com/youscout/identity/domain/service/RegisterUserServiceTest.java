package com.youscout.identity.domain.service;

import com.youscout.identity.domain.model.Email;
import com.youscout.identity.domain.model.User;
import com.youscout.identity.domain.port.in.RegisterUserUseCase;
import com.youscout.identity.domain.port.out.PasswordHasher;
import com.youscout.identity.domain.port.out.TokenIssuer;
import com.youscout.identity.domain.port.out.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

// Proves hexagonal isolation: domain service tested with mocked ports — zero Spring context needed
@ExtendWith(MockitoExtension.class)
class RegisterUserServiceTest {

    @Mock UserRepository userRepository;
    @Mock PasswordHasher passwordHasher;
    @Mock TokenIssuer tokenIssuer;
    @InjectMocks RegisterUserService service;

    @Test
    void register_success() {
        when(userRepository.existsByEmail(any())).thenReturn(false);
        when(passwordHasher.hash("password123")).thenReturn("hashed");
        when(tokenIssuer.issue(any(), any())).thenReturn("jwt-token");

        var result = service.register(new RegisterUserUseCase.RegisterCommand(
                "alice@youscout.dev", "password123", "Alice"));

        assertThat(result.email()).isEqualTo("alice@youscout.dev");
        assertThat(result.token()).isEqualTo("jwt-token");
        verify(userRepository).save(any(User.class));
    }

    @Test
    void register_duplicateEmail_throws() {
        when(userRepository.existsByEmail(new Email("alice@youscout.dev"))).thenReturn(true);

        assertThatThrownBy(() -> service.register(
                new RegisterUserUseCase.RegisterCommand("alice@youscout.dev", "pass", "Alice")))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("already registered");
    }
}
