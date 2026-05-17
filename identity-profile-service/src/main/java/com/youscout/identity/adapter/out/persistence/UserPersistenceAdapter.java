package com.youscout.identity.adapter.out.persistence;

import com.youscout.identity.adapter.out.persistence.mapper.UserPersistenceMapper;
import com.youscout.identity.domain.model.Email;
import com.youscout.identity.domain.model.User;
import com.youscout.identity.domain.model.UserId;
import com.youscout.identity.domain.port.out.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Optional;

// PATTERN: Adapter (out/persistence) — implements domain port, hides JPA from domain
@Component
@RequiredArgsConstructor
public class UserPersistenceAdapter implements UserRepository {

    private final UserJpaRepository jpaRepository;
    private final UserPersistenceMapper mapper;

    @Override
    public void save(User user) {
        jpaRepository.save(mapper.toEntity(user));
    }

    @Override
    public void update(User user) {
        jpaRepository.save(mapper.toEntity(user));
    }

    @Override
    public Optional<User> findById(UserId id) {
        return jpaRepository.findById(id.value()).map(mapper::toDomain);
    }

    @Override
    public Optional<User> findByEmail(Email email) {
        return jpaRepository.findByEmail(email.value()).map(mapper::toDomain);
    }

    @Override
    public boolean existsByEmail(Email email) {
        return jpaRepository.existsByEmail(email.value());
    }
}
