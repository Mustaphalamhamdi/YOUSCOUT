package com.youscout.identity.domain.port.in;

import com.youscout.identity.domain.model.User;

public interface GetProfileUseCase {
    User getProfile(String userId);
    User updateProfile(String userId, UpdateProfileCommand command);

    record UpdateProfileCommand(String displayName, String bio, String position, String foot) {}
}
