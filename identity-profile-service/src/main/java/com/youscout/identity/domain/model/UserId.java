package com.youscout.identity.domain.model;

import java.util.UUID;

public record UserId(UUID value) {
    public static UserId of(String id) {
        return new UserId(UUID.fromString(id));
    }
}
