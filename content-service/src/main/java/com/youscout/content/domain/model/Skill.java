package com.youscout.content.domain.model;

// Value object — skill from the taxonomy (Conformist integration pattern)
public record Skill(String code, String displayName) {
    public static Skill of(String code, String displayName) {
        return new Skill(code.toUpperCase(), displayName);
    }
}
