package com.youscout.identity.domain.service;

import com.youscout.identity.domain.model.Email;
import com.youscout.identity.domain.model.PasswordHash;
import com.youscout.identity.domain.model.User;
import com.youscout.identity.domain.port.in.RegisterUserUseCase;
import com.youscout.identity.domain.port.out.PasswordHasher;
import com.youscout.identity.domain.port.out.TokenIssuer;
import com.youscout.identity.domain.port.out.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

// Domain service — implements inbound port, depends only on outbound port interfaces (DIP)
// No JPA, no HTTP, no Kafka — only pure domain logic
@Service
@RequiredArgsConstructor
public class RegisterUserService implements RegisterUserUseCase {

    private final UserRepository userRepository;   // outbound port — DIP
    private final PasswordHasher passwordHasher;   // outbound port — Strategy pattern
    private final TokenIssuer tokenIssuer;         // outbound port — DIP

    @Transactional
    @Override
    public RegisterResult register(RegisterCommand command) {
        var email = new Email(command.email());
        if (userRepository.existsByEmail(email)) {
            throw new IllegalStateException("Email already registered: " + command.email());
        }
        var hash = new PasswordHash(passwordHasher.hash(command.password()));
        var user = User.register(email, hash, command.displayName()); // Factory Method pattern
        userRepository.save(user);
        var token = tokenIssuer.issue(user.getId().value().toString(), user.getEmail().value());
        return new RegisterResult(
                user.getId().value().toString(), user.getEmail().value(), user.getDisplayName(), token);
    }
}
