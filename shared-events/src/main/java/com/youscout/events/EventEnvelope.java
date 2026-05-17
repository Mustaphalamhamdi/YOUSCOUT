package com.youscout.events;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.UUID;

// PATTERN: Domain Event envelope — every inter-service event is wrapped here.
// Contains correlation ID for distributed tracing (AD-03).
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EventEnvelope<T> {
    @Builder.Default
    private String eventId = UUID.randomUUID().toString();
    private String correlationId;
    private String eventType;
    @Builder.Default
    private String version = "1.0.0";
    @Builder.Default
    private String occurredAt = Instant.now().toString();
    private T payload;
}
