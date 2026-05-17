package com.youscout.content.adapter.out.persistence;

import com.youscout.content.domain.model.VideoStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "videos")
@Getter @Builder @NoArgsConstructor @AllArgsConstructor
public class VideoJpaEntity {
    @Id @Column(columnDefinition = "uuid")
    private UUID id;
    @Column(name = "user_id", nullable = false)
    private String userId;
    @Column(name = "uploader_name")
    private String uploaderName;
    @Column(columnDefinition = "text")
    private String description;
    @Column(name = "storage_key", nullable = false)
    private String storageKey;
    @ElementCollection @CollectionTable(name = "video_skills", joinColumns = @JoinColumn(name = "video_id"))
    @Column(name = "skill_code")
    private List<String> skillCodes;
    @ElementCollection @CollectionTable(name = "video_hashtags", joinColumns = @JoinColumn(name = "video_id"))
    @Column(name = "hashtag")
    private List<String> hashtags;
    @Enumerated(EnumType.STRING)
    private VideoStatus status;
    @Column(name = "published_at")
    private Instant publishedAt;
}
