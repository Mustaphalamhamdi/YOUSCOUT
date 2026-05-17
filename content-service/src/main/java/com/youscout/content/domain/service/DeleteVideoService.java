package com.youscout.content.domain.service;

import com.youscout.content.domain.model.VideoId;
import com.youscout.content.domain.port.in.DeleteVideoUseCase;
import com.youscout.content.domain.port.out.EventPublisher;
import com.youscout.content.domain.port.out.VideoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class DeleteVideoService implements DeleteVideoUseCase {

    private final VideoRepository videoRepository;
    private final EventPublisher eventPublisher;

    @Transactional
    @Override
    public void delete(String videoId, String requestingUserId) {
        var video = videoRepository.findById(VideoId.of(videoId))
                .orElseThrow(() -> new IllegalArgumentException("Video not found: " + videoId));
        if (!video.getUserId().equals(requestingUserId))
            throw new IllegalStateException("Forbidden");
        video.delete();
        videoRepository.update(video);
        eventPublisher.publishVideoDeleted(videoId, video.getUserId());
    }
}
