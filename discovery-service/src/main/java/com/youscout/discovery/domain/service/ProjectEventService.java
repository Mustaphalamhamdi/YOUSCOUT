package com.youscout.discovery.domain.service;

import com.youscout.discovery.domain.model.FeedItem;
import com.youscout.discovery.domain.port.in.ProjectEventUseCase;
import com.youscout.discovery.domain.port.out.FeedReadStore;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

// CQRS Projection Service: translates domain events into the Redis read model.
// This is the architectural heart of the CQRS pattern — all projection logic lives here.
// Idempotent: projecting the same event twice produces the same result (AD-03).
@Slf4j
@Service
@RequiredArgsConstructor
public class ProjectEventService implements ProjectEventUseCase {

    private final FeedReadStore feedReadStore;

    @Override
    public void onVideoPublished(FeedItem item, List<String> followerIds) {
        // Fan-out: push to every follower's feed in Redis
        for (var followerId : followerIds) {
            feedReadStore.addToFeed(followerId, item);
        }
        log.info("Projected VideoPublished videoId={} to {} followers", item.videoId(), followerIds.size());
    }

    @Override
    public void onVideoDeleted(String videoId, List<String> affectedUserIds) {
        for (var userId : affectedUserIds) {
            feedReadStore.removeFromFeed(userId, videoId);
        }
    }

    @Override
    public void onUserFollowed(String followerId, String followeeId) {
        feedReadStore.recordFollow(followerId, followeeId);
        log.info("Recorded follow: follower={} followee={}", followerId, followeeId);
    }
}
