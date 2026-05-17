package com.youscout.content.domain.model;

import java.util.UUID;

public record VideoId(UUID value) {
    public static VideoId generate() { return new VideoId(UUID.randomUUID()); }
    public static VideoId of(String id) { return new VideoId(UUID.fromString(id)); }
}
