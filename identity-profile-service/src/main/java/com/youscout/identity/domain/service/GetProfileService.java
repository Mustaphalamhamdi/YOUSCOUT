package com.youscout.identity.domain.service;

import com.youscout.identity.domain.model.User;
import com.youscout.identity.domain.model.UserId;
import com.youscout.identity.domain.port.in.GetProfileUseCase;
import com.youscout.identity.domain.port.out.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class GetProfileService implements GetProfileUseCase {

    private final UserRepository userRepository;

    @Override
    public User getProfile(String userId) {
        return userRepository.findById(UserId.of(userId))
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + userId));
    }

    @Transactional
    @Override
    public User updateProfile(String userId, UpdateProfileCommand command) {
        var user = getProfile(userId);
        user.updateProfile(command.displayName(), command.bio(), command.position(), command.foot());
        userRepository.update(user);
        return user;
    }
}
