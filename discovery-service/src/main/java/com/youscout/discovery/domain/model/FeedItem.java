package com.youscout.discovery.domain.model;

import java.util.List;

// CQRS Read Model — this is a projection, not a write-side entity.
// Owned entirely by the Discovery service; never queried from Content's DB.
public record FeedItem(
        String videoId,
        String uploaderId,
        String uploaderName,
        String description,
        List<String> skills,
        String publishedAt
) {}
