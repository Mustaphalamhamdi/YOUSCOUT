package com.youscout.identity.domain.port.in;

public interface AuthenticateUserUseCase {
    AuthResult authenticate(AuthCommand command);

    record AuthCommand(String email, String password) {}
    record AuthResult(String userId, String email, String displayName, String token) {}
}
