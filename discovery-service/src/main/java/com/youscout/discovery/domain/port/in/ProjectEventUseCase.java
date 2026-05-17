package com.youscout.discovery.domain.port.in;

import com.youscout.discovery.domain.model.FeedItem;

import java.util.List;

// Inbound port for the CQRS projection logic — called by Kafka consumer adapters
public interface ProjectEventUseCase {
    void onVideoPublished(FeedItem item, List<String> followerIds);
    void onVideoDeleted(String videoId, List<String> affectedUserIds);
    void onUserFollowed(String followerId, String followeeId);
}
