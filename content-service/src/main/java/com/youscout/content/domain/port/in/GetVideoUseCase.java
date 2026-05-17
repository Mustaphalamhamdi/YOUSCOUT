package com.youscout.content.domain.port.in;

import com.youscout.content.domain.model.Video;

public interface GetVideoUseCase {
    Video getVideo(String videoId);
    String getStreamUrl(String videoId);
}
