package com.youscout.identity.domain.port.out;

// Outbound port — domain needs a token but doesn't know JWT exists
public interface TokenIssuer {
    String issue(String userId, String email);
}
