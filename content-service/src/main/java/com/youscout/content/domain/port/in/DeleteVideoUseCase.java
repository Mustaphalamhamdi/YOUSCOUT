package com.youscout.content.domain.port.in;

public interface DeleteVideoUseCase {
    void delete(String videoId, String requestingUserId);
}
