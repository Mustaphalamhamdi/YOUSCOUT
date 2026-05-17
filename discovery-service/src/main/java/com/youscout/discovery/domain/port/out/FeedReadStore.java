package com.youscout.discovery.domain.port.out;

import com.youscout.discovery.domain.model.FeedItem;

import java.util.List;

// PATTERN: Repository (read-side) — outbound port, implemented by RedisFeedReadStoreAdapter
public interface FeedReadStore {
    void addToFeed(String userId, FeedItem item);
    void removeFromFeed(String userId, String videoId);
    List<FeedItem> getFeed(String userId, int limit);
    void recordFollow(String followerId, String followeeId);
    List<String> getFollowers(String userId);
}
