package com.youscout.identity.domain.model;

import java.time.Instant;
import java.util.UUID;

// Pure Java domain model — zero Spring/JPA/framework imports (ADR Hexagonal rule)
// PATTERN: Factory Method (static register(...))
public class User {

    private final UserId id;
    private final Email email;
    private PasswordHash passwordHash;
    private String displayName;
    private String bio;
    private String position;
    private String foot;
    private final Instant createdAt;

    private User(UserId id, Email email, PasswordHash passwordHash,
                 String displayName, String bio, String position, String foot, Instant createdAt) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.displayName = displayName;
        this.bio = bio;
        this.position = position;
        this.foot = foot;
        this.createdAt = createdAt;
    }

    // PATTERN: Factory Method — enforces invariants at creation time
    public static User register(Email email, PasswordHash passwordHash, String displayName) {
        return new User(new UserId(UUID.randomUUID()), email, passwordHash,
                displayName, "", null, null, Instant.now());
    }

    public static User reconstitute(UUID id, String email, String passwordHash,
                                    String displayName, String bio, String position, String foot, Instant createdAt) {
        return new User(new UserId(id), new Email(email), new PasswordHash(passwordHash),
                displayName, bio, position, foot, createdAt);
    }

    public void updateProfile(String displayName, String bio, String position, String foot) {
        if (displayName != null && !displayName.isBlank()) this.displayName = displayName;
        if (bio != null) this.bio = bio;
        this.position = position;
        this.foot = foot;
    }

    public UserId getId() { return id; }
    public Email getEmail() { return email; }
    public PasswordHash getPasswordHash() { return passwordHash; }
    public String getDisplayName() { return displayName; }
    public String getBio() { return bio; }
    public String getPosition() { return position; }
    public String getFoot() { return foot; }
    public Instant getCreatedAt() { return createdAt; }
}
