package com.youscout.discovery.domain.model;

import java.util.List;

// Aggregate: the ordered feed for one user — a CQRS read model projection
public record FeedTimeline(UserId userId, List<FeedItem> items) {
    public static FeedTimeline empty(UserId userId) {
        return new FeedTimeline(userId, List.of());
    }
}
