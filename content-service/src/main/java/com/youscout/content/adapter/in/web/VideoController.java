package com.youscout.content.adapter.in.web;

import com.youscout.content.domain.port.in.DeleteVideoUseCase;
import com.youscout.content.domain.port.in.GetVideoUseCase;
import com.youscout.content.domain.port.in.ListSkillsUseCase;
import com.youscout.content.domain.port.in.PublishVideoUseCase;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;

// PATTERN: Adapter (in/web) — translates HTTP multipart ↔ domain use case commands
@Tag(name = "Videos")
@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class VideoController {

    private final PublishVideoUseCase publishVideoUseCase;
    private final GetVideoUseCase getVideoUseCase;
    private final DeleteVideoUseCase deleteVideoUseCase;
    private final ListSkillsUseCase listSkillsUseCase;

    @Operation(summary = "Upload a video", security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping(value = "/videos", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> publishVideo(
            @AuthenticationPrincipal String userId,
            @RequestPart("file") MultipartFile file,
            @RequestPart("description") String description,
            @RequestPart(value = "uploaderName", required = false) String uploaderName,
            @RequestPart(value = "skills", required = false) List<String> skills,
            @RequestPart(value = "hashtags", required = false) List<String> hashtags) throws IOException {

        var result = publishVideoUseCase.publish(new PublishVideoUseCase.PublishCommand(
                userId,
                uploaderName != null ? uploaderName : "Player",
                description,
                skills != null ? skills : List.of(),
                hashtags != null ? hashtags : List.of(),
                file.getBytes(),
                file.getOriginalFilename(),
                file.getContentType()));

        return ResponseEntity.ok(result);
    }

    @Operation(summary = "Get video metadata")
    @GetMapping("/videos/{videoId}")
    public ResponseEntity<?> getVideo(@PathVariable String videoId) {
        var video = getVideoUseCase.getVideo(videoId);
        return ResponseEntity.ok(Map.of(
                "videoId", video.getId().value().toString(),
                "description", video.getDescription(),
                "skills", video.getSkillCodes(),
                "status", video.getStatus().name()));
    }

    @Operation(summary = "Get presigned stream URL (5-min TTL)")
    @GetMapping("/videos/{videoId}/stream")
    public ResponseEntity<?> getStreamUrl(@PathVariable String videoId) {
        return ResponseEntity.ok(Map.of("presignedUrl", getVideoUseCase.getStreamUrl(videoId)));
    }

    @Operation(summary = "Delete a video", security = @SecurityRequirement(name = "bearerAuth"))
    @DeleteMapping("/videos/{videoId}")
    public ResponseEntity<Void> deleteVideo(@PathVariable String videoId,
                                             @AuthenticationPrincipal String userId) {
        deleteVideoUseCase.delete(videoId, userId);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "List all available skills")
    @GetMapping("/skills")
    public ResponseEntity<?> listSkills() {
        return ResponseEntity.ok(listSkillsUseCase.listAll());
    }
}
