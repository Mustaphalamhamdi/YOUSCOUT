package com.youscout.identity.domain.port.out;

// PATTERN: Strategy — domain declares the contract; BCrypt adapter implements it.
// Swap BCrypt for Argon2 by replacing only the adapter (OCP).
public interface PasswordHasher {
    String hash(String rawPassword);
    boolean verify(String rawPassword, String hashedPassword);
}
