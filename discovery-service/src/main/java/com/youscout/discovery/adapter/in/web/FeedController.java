package com.youscout.discovery.adapter.in.web;

import com.youscout.discovery.domain.model.FeedItem;
import com.youscout.discovery.domain.port.in.GetFeedUseCase;
import com.youscout.discovery.domain.port.in.ProjectEventUseCase;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

// PATTERN: Adapter (in/web)
@Tag(name = "Feed", description = "CQRS read model — served from Redis projection, never from Content DB")
@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class FeedController {

    private final GetFeedUseCase getFeedUseCase;
    private final ProjectEventUseCase projectEventUseCase;

    @Operation(summary = "Get personalized feed (CQRS read model from Redis)",
               security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/feed")
    public ResponseEntity<List<FeedItem>> getFeed(
            @AuthenticationPrincipal String userId,
            @RequestParam(name = "limit", defaultValue = "20") int limit) {
        return ResponseEntity.ok(getFeedUseCase.getFeed(userId, limit).items());
    }

    // Minimal follow endpoint — in production, Social service publishes UserFollowedEvent to Kafka
    @Operation(summary = "Follow a user (triggers UserFollowedEvent projection for demo)")
    @PostMapping("/internal/follow")
    public ResponseEntity<Void> follow(@RequestBody Map<String, String> body) {
        projectEventUseCase.onUserFollowed(body.get("followerId"), body.get("followeeId"));
        return ResponseEntity.ok().build();
    }
}
