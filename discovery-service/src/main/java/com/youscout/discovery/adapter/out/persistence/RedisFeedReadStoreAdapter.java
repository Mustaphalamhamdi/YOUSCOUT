package com.youscout.discovery.adapter.out.persistence;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.youscout.discovery.domain.model.FeedItem;
import com.youscout.discovery.domain.port.out.FeedReadStore;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Set;

// PATTERN: Adapter (out/persistence) — implements FeedReadStore port using Redis.
// Redis data model:
//   feed:{userId}         → List<String> (JSON-serialized FeedItems, newest first, LPUSH)
//   followers:{userId}    → Set<String> (set of follower user IDs)
@Slf4j
@Component
@RequiredArgsConstructor
public class RedisFeedReadStoreAdapter implements FeedReadStore {

    private final StringRedisTemplate redis;
    private final ObjectMapper objectMapper;

    @Override
    public void addToFeed(String userId, FeedItem item) {
        try {
            var json = objectMapper.writeValueAsString(item);
            redis.opsForList().leftPush(feedKey(userId), json);
            // Cap feed at 200 items per user to bound memory
            redis.opsForList().trim(feedKey(userId), 0, 199);
        } catch (JsonProcessingException e) {
            log.error("Failed to serialize FeedItem for user {}", userId, e);
        }
    }

    @Override
    public void removeFromFeed(String userId, String videoId) {
        var items = redis.opsForList().range(feedKey(userId), 0, -1);
        if (items == null) return;
        items.stream()
                .filter(json -> json.contains("\"videoId\":\"" + videoId + "\""))
                .forEach(json -> redis.opsForList().remove(feedKey(userId), 1, json));
    }

    @Override
    public List<FeedItem> getFeed(String userId, int limit) {
        var jsons = redis.opsForList().range(feedKey(userId), 0, limit - 1);
        if (jsons == null) return List.of();
        return jsons.stream().map(this::deserialize).toList();
    }

    @Override
    public void recordFollow(String followerId, String followeeId) {
        redis.opsForSet().add(followersKey(followeeId), followerId);
    }

    @Override
    public List<String> getFollowers(String userId) {
        Set<String> members = redis.opsForSet().members(followersKey(userId));
        return members == null ? List.of() : List.copyOf(members);
    }

    private FeedItem deserialize(String json) {
        try {
            return objectMapper.readValue(json, new TypeReference<>() {});
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Failed to deserialize FeedItem", e);
        }
    }

    private String feedKey(String userId) { return "feed:" + userId; }
    private String followersKey(String userId) { return "followers:" + userId; }
}
