package com.youscout.content.adapter.out.persistence;

import com.youscout.content.domain.model.Video;
import com.youscout.content.domain.model.VideoId;
import com.youscout.content.domain.port.out.VideoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Optional;

// PATTERN: Adapter (out/persistence)
@Component
@RequiredArgsConstructor
public class VideoPersistenceAdapter implements VideoRepository {

    private final VideoJpaRepository jpaRepository;

    @Override
    public void save(Video video) {
        jpaRepository.save(toEntity(video));
    }

    @Override
    public void update(Video video) {
        jpaRepository.save(toEntity(video));
    }

    @Override
    public Optional<Video> findById(VideoId id) {
        return jpaRepository.findById(id.value()).map(this::toDomain);
    }

    private VideoJpaEntity toEntity(Video v) {
        return VideoJpaEntity.builder()
                .id(v.getId().value()).userId(v.getUserId()).uploaderName(v.getUploaderName())
                .description(v.getDescription()).storageKey(v.getStorageKey())
                .skillCodes(v.getSkillCodes()).hashtags(v.getHashtags())
                .status(v.getStatus()).publishedAt(v.getPublishedAt())
                .build();
    }

    private Video toDomain(VideoJpaEntity e) {
        return Video.reconstitute(new VideoId(e.getId()), e.getUserId(), e.getUploaderName(),
                e.getDescription(), e.getStorageKey(), e.getSkillCodes(), e.getHashtags(),
                e.getStatus(), e.getPublishedAt());
    }
}
