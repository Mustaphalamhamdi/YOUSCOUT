package com.youscout.content.adapter.out.storage;

import com.youscout.content.domain.port.out.MediaStore;
import io.minio.*;
import io.minio.http.Method;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.ByteArrayInputStream;
import java.util.concurrent.TimeUnit;

// PATTERN: Adapter (out/storage) — implements MediaStore port using MinIO SDK
@Slf4j
@Component
public class MinioMediaStoreAdapter implements MediaStore {

    private final MinioClient client;
    private final String bucket;

    public MinioMediaStoreAdapter(
            @Value("${minio.endpoint}") String endpoint,
            @Value("${minio.access-key}") String accessKey,
            @Value("${minio.secret-key}") String secretKey,
            @Value("${minio.bucket}") String bucket) {
        this.client = MinioClient.builder().endpoint(endpoint)
                .credentials(accessKey, secretKey).build();
        this.bucket = bucket;
    }

    @Override
    public String store(byte[] bytes, String key, String contentType) {
        try {
            client.putObject(PutObjectArgs.builder()
                    .bucket(bucket).object(key)
                    .stream(new ByteArrayInputStream(bytes), bytes.length, -1)
                    .contentType(contentType != null ? contentType : "video/mp4")
                    .build());
            return key;
        } catch (Exception e) {
            throw new RuntimeException("Failed to store file: " + key, e);
        }
    }

    @Override
    public String presignedUrl(String key, int expiryMinutes) {
        try {
            return client.getPresignedObjectUrl(GetPresignedObjectUrlArgs.builder()
                    .method(Method.GET).bucket(bucket).object(key)
                    .expiry(expiryMinutes, TimeUnit.MINUTES).build());
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate presigned URL for: " + key, e);
        }
    }

    @Override
    public void delete(String key) {
        try {
            client.removeObject(RemoveObjectArgs.builder().bucket(bucket).object(key).build());
        } catch (Exception e) {
            log.warn("Failed to delete object {}: {}", key, e.getMessage());
        }
    }
}
