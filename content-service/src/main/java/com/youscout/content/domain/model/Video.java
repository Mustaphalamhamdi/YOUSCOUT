package com.youscout.content.domain.model;

import java.time.Instant;
import java.util.List;

// Pure domain model — no JPA, no Spring (ADR Hexagonal rule)
// PATTERN: Factory Method (static upload(...))
public class Video {

    private final VideoId id;
    private final String userId;
    private final String uploaderName;
    private final String description;
    private final String storageKey;
    private final List<String> skillCodes;
    private final List<String> hashtags;
    private VideoStatus status;
    private final Instant publishedAt;

    private Video(VideoId id, String userId, String uploaderName, String description,
                  String storageKey, List<String> skillCodes, List<String> hashtags,
                  VideoStatus status, Instant publishedAt) {
        this.id = id;
        this.userId = userId;
        this.uploaderName = uploaderName;
        this.description = description;
        this.storageKey = storageKey;
        this.skillCodes = skillCodes;
        this.hashtags = hashtags;
        this.status = status;
        this.publishedAt = publishedAt;
    }

    // PATTERN: Factory Method
    public static Video upload(String userId, String uploaderName, String description,
                               String storageKey, List<String> skillCodes, List<String> hashtags) {
        return new Video(VideoId.generate(), userId, uploaderName, description,
                storageKey, skillCodes, hashtags, VideoStatus.PUBLISHED, Instant.now());
    }

    public static Video reconstitute(VideoId id, String userId, String uploaderName,
                                     String description, String storageKey,
                                     List<String> skillCodes, List<String> hashtags,
                                     VideoStatus status, Instant publishedAt) {
        return new Video(id, userId, uploaderName, description, storageKey,
                skillCodes, hashtags, status, publishedAt);
    }

    public void delete() { this.status = VideoStatus.DELETED; }

    public VideoId getId() { return id; }
    public String getUserId() { return userId; }
    public String getUploaderName() { return uploaderName; }
    public String getDescription() { return description; }
    public String getStorageKey() { return storageKey; }
    public List<String> getSkillCodes() { return skillCodes; }
    public List<String> getHashtags() { return hashtags; }
    public VideoStatus getStatus() { return status; }
    public Instant getPublishedAt() { return publishedAt; }
}
