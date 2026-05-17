package com.youscout.identity.adapter.out.security;

import com.youscout.identity.domain.port.out.TokenIssuer;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

// PATTERN: Adapter (out/security) — implements TokenIssuer port using JJWT.
// Domain service has no idea JWT exists; it just calls tokenIssuer.issue(...)
@Component
public class JwtTokenProvider implements TokenIssuer {

    private final SecretKey key;
    private final long expiryMs;

    public JwtTokenProvider(
            @Value("${jwt.secret}") String secret,
            @Value("${jwt.expiry-hours:1}") long expiryHours) {
        this.key = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.expiryMs = expiryHours * 3600 * 1000;
    }

    @Override
    public String issue(String userId, String email) {
        return Jwts.builder()
                .subject(userId)
                .claim("email", email)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + expiryMs))
                .signWith(key)
                .compact();
    }

    public String extractUserId(String token) {
        return parseClaims(token).getSubject();
    }

    public boolean isValid(String token) {
        try {
            parseClaims(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private Claims parseClaims(String token) {
        return Jwts.parser().verifyWith(key).build().parseSignedClaims(token).getPayload();
    }
}
