package com.youscout.identity.adapter.out.persistence.mapper;

import com.youscout.identity.adapter.out.persistence.UserJpaEntity;
import com.youscout.identity.domain.model.User;
import org.mapstruct.Mapper;

// PATTERN: Adapter — decouples JPA entity from domain model
@Mapper(componentModel = "spring")
public interface UserPersistenceMapper {

    default UserJpaEntity toEntity(User user) {
        return UserJpaEntity.builder()
                .id(user.getId().value())
                .email(user.getEmail().value())
                .passwordHash(user.getPasswordHash().value())
                .displayName(user.getDisplayName())
                .bio(user.getBio())
                .position(user.getPosition())
                .foot(user.getFoot())
                .createdAt(user.getCreatedAt())
                .build();
    }

    default User toDomain(UserJpaEntity e) {
        return User.reconstitute(e.getId(), e.getEmail(), e.getPasswordHash(),
                e.getDisplayName(), e.getBio(), e.getPosition(), e.getFoot(), e.getCreatedAt());
    }
}
