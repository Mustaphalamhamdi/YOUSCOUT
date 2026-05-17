package com.youscout.content.domain.port.out;

import com.youscout.content.domain.model.Video;
import com.youscout.content.domain.model.VideoId;

import java.util.Optional;

// PATTERN: Repository (Evans)
public interface VideoRepository {
    void save(Video video);
    void update(Video video);
    Optional<Video> findById(VideoId id);
}
