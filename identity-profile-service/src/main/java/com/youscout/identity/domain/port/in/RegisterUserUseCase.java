package com.youscout.identity.domain.port.in;

// PATTERN: Use Case interface (inbound port)
// Controllers depend on this interface, never on the service implementation (DIP)
public interface RegisterUserUseCase {
    RegisterResult register(RegisterCommand command);

    record RegisterCommand(String email, String password, String displayName) {}
    record RegisterResult(String userId, String email, String displayName, String token) {}
}
