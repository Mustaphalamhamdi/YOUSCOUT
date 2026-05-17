package com.youscout.discovery.domain.port.in;

import com.youscout.discovery.domain.model.FeedTimeline;

public interface GetFeedUseCase {
    FeedTimeline getFeed(String userId, int limit);
}
