package com.youscout.identity.adapter.in.web.mapper;

import com.youscout.identity.adapter.in.web.dto.UserDto;
import com.youscout.identity.domain.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

// PATTERN: Adapter — translates domain model ↔ HTTP DTO (MapStruct generates impl at compile time)
@Mapper(componentModel = "spring")
public interface UserWebMapper {
    @Mapping(source = "id.value", target = "userId")
    @Mapping(source = "email.value", target = "email")
    UserDto toDto(User user);
}
