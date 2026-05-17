package com.youscout.events;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

// Published by content-service, consumed by discovery-service.
// Partition key: videoId (ensures ordering per video).
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VideoPublishedEvent {
    private String videoId;
    private String userId;
    private String uploaderName;
    private String description;
    private List<String> skills;
    private List<String> hashtags;
    private String publishedAt;
}
