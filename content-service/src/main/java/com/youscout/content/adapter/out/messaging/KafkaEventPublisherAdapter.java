package com.youscout.content.adapter.out.messaging;

import com.youscout.content.domain.port.out.EventPublisher;
import com.youscout.events.EventEnvelope;
import com.youscout.events.VideoDeletedEvent;
import com.youscout.events.VideoPublishedEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

// PATTERN: Adapter (out/messaging) — implements EventPublisher port using Kafka.
// Domain service calls eventPublisher.publishVideoPublished(...) without knowing Kafka exists.
@Slf4j
@Component
@RequiredArgsConstructor
public class KafkaEventPublisherAdapter implements EventPublisher {

    private static final String VIDEO_EVENTS_TOPIC = "youscout.video.events";

    private final KafkaTemplate<String, Object> kafkaTemplate;

    @Override
    public void publishVideoPublished(String videoId, String userId, String uploaderName,
                                      String description, List<String> skills, List<String> hashtags) {
        var event = EventEnvelope.<VideoPublishedEvent>builder()
                .correlationId(UUID.randomUUID().toString())
                .eventType("VideoPublished")
                .payload(VideoPublishedEvent.builder()
                        .videoId(videoId).userId(userId).uploaderName(uploaderName)
                        .description(description).skills(skills).hashtags(hashtags)
                        .publishedAt(Instant.now().toString())
                        .build())
                .build();
        // Partition key = videoId ensures ordering per video (AD-03)
        kafkaTemplate.send(VIDEO_EVENTS_TOPIC, videoId, event);
        log.info("Published VideoPublishedEvent for videoId={}", videoId);
    }

    @Override
    public void publishVideoDeleted(String videoId, String userId) {
        var event = EventEnvelope.<VideoDeletedEvent>builder()
                .correlationId(UUID.randomUUID().toString())
                .eventType("VideoDeleted")
                .payload(VideoDeletedEvent.builder().videoId(videoId).userId(userId).build())
                .build();
        kafkaTemplate.send(VIDEO_EVENTS_TOPIC, videoId, event);
        log.info("Published VideoDeletedEvent for videoId={}", videoId);
    }
}
