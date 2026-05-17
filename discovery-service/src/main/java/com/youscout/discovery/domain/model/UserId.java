package com.youscout.discovery.domain.model;

public record UserId(String value) {
    public static UserId of(String value) { return new UserId(value); }
}
