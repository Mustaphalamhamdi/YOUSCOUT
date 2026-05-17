package com.youscout.identity.domain.model;

public record Email(String value) {
    public Email {
        if (value == null || !value.contains("@"))
            throw new IllegalArgumentException("Invalid email: " + value);
    }
}
