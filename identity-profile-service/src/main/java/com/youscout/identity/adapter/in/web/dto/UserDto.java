package com.youscout.identity.adapter.in.web.dto;

public record UserDto(
        String userId,
        String email,
        String displayName,
        String bio,
        String position,
        String foot
) {}
