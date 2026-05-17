package com.youscout.discovery.domain.service;

import com.youscout.discovery.domain.model.FeedTimeline;
import com.youscout.discovery.domain.model.UserId;
import com.youscout.discovery.domain.port.in.GetFeedUseCase;
import com.youscout.discovery.domain.port.out.FeedReadStore;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

// CQRS Read Side: serves the feed from Redis projection.
// NEVER queries Content DB or Engagement DB — reads only its own projection (AD-01).
@Service
@RequiredArgsConstructor
public class GetFeedService implements GetFeedUseCase {

    private final FeedReadStore feedReadStore;

    @Override
    public FeedTimeline getFeed(String userId, int limit) {
        var items = feedReadStore.getFeed(userId, limit);
        return new FeedTimeline(UserId.of(userId), items);
    }
}
