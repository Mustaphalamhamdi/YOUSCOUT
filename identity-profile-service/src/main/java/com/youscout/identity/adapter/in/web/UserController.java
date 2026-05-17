package com.youscout.identity.adapter.in.web;

import com.youscout.identity.adapter.in.web.dto.*;
import com.youscout.identity.adapter.in.web.mapper.UserWebMapper;
import com.youscout.identity.domain.port.in.AuthenticateUserUseCase;
import com.youscout.identity.domain.port.in.GetProfileUseCase;
import com.youscout.identity.domain.port.in.RegisterUserUseCase;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

// PATTERN: Adapter (in/web) — translates HTTP requests into use case calls.
// No business logic here — only HTTP ↔ DTO ↔ use case port translation.
@Tag(name = "Auth & Profile", description = "Registration, login, and profile management")
@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class UserController {

    private final RegisterUserUseCase registerUserUseCase;
    private final AuthenticateUserUseCase authenticateUserUseCase;
    private final GetProfileUseCase getProfileUseCase;
    private final UserWebMapper mapper;

    @Operation(summary = "Register a new user — returns JWT")
    @PostMapping("/auth/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest req) {
        var result = registerUserUseCase.register(
                new RegisterUserUseCase.RegisterCommand(req.email(), req.password(), req.displayName()));
        return ResponseEntity.ok(new AuthResponse(result.userId(), result.email(), result.displayName(), result.token()));
    }

    @Operation(summary = "Login — returns JWT")
    @PostMapping("/auth/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest req) {
        var result = authenticateUserUseCase.authenticate(
                new AuthenticateUserUseCase.AuthCommand(req.email(), req.password()));
        return ResponseEntity.ok(new AuthResponse(result.userId(), result.email(), result.displayName(), result.token()));
    }

    @Operation(summary = "Get own profile", security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/profile/me")
    public ResponseEntity<UserDto> getMyProfile(@AuthenticationPrincipal String userId) {
        return ResponseEntity.ok(mapper.toDto(getProfileUseCase.getProfile(userId)));
    }

    @Operation(summary = "Update own profile", security = @SecurityRequirement(name = "bearerAuth"))
    @PutMapping("/profile/me")
    public ResponseEntity<UserDto> updateProfile(@AuthenticationPrincipal String userId,
                                                  @RequestBody UpdateProfileRequest req) {
        var user = getProfileUseCase.updateProfile(userId,
                new GetProfileUseCase.UpdateProfileCommand(req.displayName(), req.bio(), req.position(), req.foot()));
        return ResponseEntity.ok(mapper.toDto(user));
    }

    @Operation(summary = "Get any user's public profile")
    @GetMapping("/users/{userId}")
    public ResponseEntity<UserDto> getUser(@PathVariable String userId) {
        return ResponseEntity.ok(mapper.toDto(getProfileUseCase.getProfile(userId)));
    }
}
