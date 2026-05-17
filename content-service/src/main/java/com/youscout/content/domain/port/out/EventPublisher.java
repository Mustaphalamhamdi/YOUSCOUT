package com.youscout.content.domain.port.out;

// PATTERN: Domain Event publisher port — domain fires events without knowing Kafka exists
public interface EventPublisher {
    void publishVideoPublished(String videoId, String userId, String uploaderName,
                               String description, java.util.List<String> skills,
                               java.util.List<String> hashtags);
    void publishVideoDeleted(String videoId, String userId);
}
