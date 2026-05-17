package com.youscout.content.domain.port.in;

import java.util.List;

public interface PublishVideoUseCase {
    PublishResult publish(PublishCommand command);

    record PublishCommand(
            String userId, String uploaderName, String description,
            List<String> skillCodes, List<String> hashtags,
            byte[] fileBytes, String originalFilename, String contentType) {}

    record PublishResult(String videoId, String description, List<String> skills) {}
}
