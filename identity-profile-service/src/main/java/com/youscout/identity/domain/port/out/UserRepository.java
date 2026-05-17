package com.youscout.identity.domain.port.out;

import com.youscout.identity.domain.model.Email;
import com.youscout.identity.domain.model.User;
import com.youscout.identity.domain.model.UserId;

import java.util.Optional;

// PATTERN: Repository (Evans DDD) — outbound port, implemented by the persistence adapter
public interface UserRepository {
    void save(User user);
    void update(User user);
    Optional<User> findById(UserId id);
    Optional<User> findByEmail(Email email);
    boolean existsByEmail(Email email);
}
