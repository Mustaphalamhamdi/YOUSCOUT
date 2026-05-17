package com.youscout.content.domain.service;

import com.youscout.content.domain.model.Video;
import com.youscout.content.domain.model.VideoId;
import com.youscout.content.domain.port.in.GetVideoUseCase;
import com.youscout.content.domain.port.out.MediaStore;
import com.youscout.content.domain.port.out.VideoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetVideoService implements GetVideoUseCase {

    private final VideoRepository videoRepository;
    private final MediaStore mediaStore;

    @Override
    public Video getVideo(String videoId) {
        return videoRepository.findById(VideoId.of(videoId))
                .orElseThrow(() -> new IllegalArgumentException("Video not found: " + videoId));
    }

    @Override
    public String getStreamUrl(String videoId) {
        var video = getVideo(videoId);
        return mediaStore.presignedUrl(video.getStorageKey(), 5);
    }
}
