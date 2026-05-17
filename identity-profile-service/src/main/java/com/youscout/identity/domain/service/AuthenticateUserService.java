package com.youscout.identity.domain.service;

import com.youscout.identity.domain.model.Email;
import com.youscout.identity.domain.port.in.AuthenticateUserUseCase;
import com.youscout.identity.domain.port.out.PasswordHasher;
import com.youscout.identity.domain.port.out.TokenIssuer;
import com.youscout.identity.domain.port.out.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthenticateUserService implements AuthenticateUserUseCase {

    private final UserRepository userRepository;
    private final PasswordHasher passwordHasher;
    private final TokenIssuer tokenIssuer;

    @Override
    public AuthResult authenticate(AuthCommand command) {
        var user = userRepository.findByEmail(new Email(command.email()))
                .orElseThrow(() -> new IllegalArgumentException("Invalid credentials"));
        if (!passwordHasher.verify(command.password(), user.getPasswordHash().value())) {
            throw new IllegalArgumentException("Invalid credentials");
        }
        var token = tokenIssuer.issue(user.getId().value().toString(), user.getEmail().value());
        return new AuthResult(
                user.getId().value().toString(), user.getEmail().value(), user.getDisplayName(), token);
    }
}
