package com.youscout.discovery.adapter.in.messaging;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.youscout.discovery.domain.model.FeedItem;
import com.youscout.discovery.domain.port.in.ProjectEventUseCase;
import com.youscout.discovery.domain.port.out.FeedReadStore;
import com.youscout.events.EventEnvelope;
import com.youscout.events.VideoPublishedEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import java.util.Map;

// PATTERN: Adapter (in/messaging) — translates Kafka messages into use case calls.
// Consumer is idempotent: projecting the same video twice is safe (AD-03).
@Slf4j
@Component
@RequiredArgsConstructor
public class VideoPublishedConsumer {

    private final ProjectEventUseCase projectEventUseCase;
    private final FeedReadStore feedReadStore;
    private final ObjectMapper objectMapper;

    @KafkaListener(topics = "youscout.video.events", groupId = "discovery-service",
            filter = "videoPublishedFilter")
    public void consume(Map<String, Object> rawEnvelope) {
        try {
            var envelope = objectMapper.convertValue(rawEnvelope,
                    objectMapper.getTypeFactory().constructParametricType(EventEnvelope.class, Map.class));

            if (!"VideoPublished".equals(envelope.getEventType())) return;

            var payloadMap = (Map<?, ?>) envelope.getPayload();
            var event = objectMapper.convertValue(payloadMap, VideoPublishedEvent.class);

            var feedItem = new FeedItem(
                    event.getVideoId(), event.getUserId(), event.getUploaderName(),
                    event.getDescription(), event.getSkills(), event.getPublishedAt());

            // Fan-out to all followers
            var followers = feedReadStore.getFollowers(event.getUserId());
            projectEventUseCase.onVideoPublished(feedItem, followers);

        } catch (Exception e) {
            log.error("Error processing VideoPublished event: {}", e.getMessage(), e);
        }
    }
}
