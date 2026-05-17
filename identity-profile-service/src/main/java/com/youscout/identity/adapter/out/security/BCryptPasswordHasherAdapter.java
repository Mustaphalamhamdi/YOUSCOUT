package com.youscout.identity.adapter.out.security;

import com.youscout.identity.domain.port.out.PasswordHasher;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

// PATTERN: Strategy + Adapter — plugs BCrypt into the PasswordHasher port
@Component
public class BCryptPasswordHasherAdapter implements PasswordHasher {

    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    @Override
    public String hash(String rawPassword) {
        return encoder.encode(rawPassword);
    }

    @Override
    public boolean verify(String rawPassword, String hashedPassword) {
        return encoder.matches(rawPassword, hashedPassword);
    }
}
