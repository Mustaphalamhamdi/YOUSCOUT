package com.youscout.identity.adapter.in.web.dto;

public record AuthResponse(String userId, String email, String displayName, String token) {}
