package com.youscout.discovery.adapter.in.messaging;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.youscout.discovery.domain.port.in.ProjectEventUseCase;
import com.youscout.events.EventEnvelope;
import com.youscout.events.UserFollowedEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import java.util.Map;

// PATTERN: Adapter (in/messaging) — receives UserFollowedEvent and delegates to projection use case
@Slf4j
@Component
@RequiredArgsConstructor
public class UserFollowedConsumer {

    private final ProjectEventUseCase projectEventUseCase;
    private final ObjectMapper objectMapper;

    @KafkaListener(topics = "youscout.user.events", groupId = "discovery-service")
    public void consume(Map<String, Object> rawEnvelope) {
        try {
            var payloadMap = (Map<?, ?>) ((Map<?, ?>) rawEnvelope).get("payload");
            if (payloadMap == null) return;
            var event = objectMapper.convertValue(payloadMap, UserFollowedEvent.class);
            projectEventUseCase.onUserFollowed(event.getFollowerId(), event.getFolloweeId());
        } catch (Exception e) {
            log.error("Error processing UserFollowed event: {}", e.getMessage(), e);
        }
    }
}
