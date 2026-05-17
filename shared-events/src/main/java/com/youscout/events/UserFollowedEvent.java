package com.youscout.events;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// Published when a user follows another.
// Consumed by discovery-service to update feed memberships.
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserFollowedEvent {
    private String followerId;
    private String followeeId;
}
