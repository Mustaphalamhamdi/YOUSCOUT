package com.youscout.identity.adapter.out.persistence;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.UUID;

// PATTERN: Adapter (out/persistence) — JPA entity separate from domain model (SRP).
// Domain model User has zero JPA annotations; this class is purely infrastructure.
@Entity
@Table(name = "users")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserJpaEntity {

    @Id
    @Column(columnDefinition = "uuid")
    private UUID id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @Column(name = "display_name")
    private String displayName;

    private String bio;
    private String position;
    private String foot;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;
}
