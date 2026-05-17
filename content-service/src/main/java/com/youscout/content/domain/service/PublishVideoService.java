package com.youscout.content.domain.service;

import com.youscout.content.domain.model.Video;
import com.youscout.content.domain.port.in.PublishVideoUseCase;
import com.youscout.content.domain.port.out.EventPublisher;
import com.youscout.content.domain.port.out.MediaStore;
import com.youscout.content.domain.port.out.VideoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

// PATTERN: Application service — orchestrates domain + outbound ports (no business logic in adapters)
@Service
@RequiredArgsConstructor
public class PublishVideoService implements PublishVideoUseCase {

    private final VideoRepository videoRepository;
    private final MediaStore mediaStore;
    private final EventPublisher eventPublisher;

    @Transactional
    @Override
    public PublishResult publish(PublishCommand command) {
        var storageKey = "videos/" + UUID.randomUUID() + "/" + command.originalFilename();

        // Store blob via outbound port — domain doesn't know MinIO exists
        mediaStore.store(command.fileBytes(), storageKey, command.contentType());

        var video = Video.upload(
                command.userId(), command.uploaderName(), command.description(),
                storageKey, command.skillCodes(), command.hashtags());

        videoRepository.save(video);

        // PATTERN: Domain Event — publish after state is persisted
        eventPublisher.publishVideoPublished(
                video.getId().value().toString(), video.getUserId(), video.getUploaderName(),
                video.getDescription(), video.getSkillCodes(), video.getHashtags());

        return new PublishResult(
                video.getId().value().toString(), video.getDescription(), video.getSkillCodes());
    }
}
