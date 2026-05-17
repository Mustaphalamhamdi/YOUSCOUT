package com.youscout.content.domain.port.out;

// PATTERN: Repository-like port for blob storage
// ISP: only the methods the domain needs — store, presign-url, delete
public interface MediaStore {
    String store(byte[] bytes, String key, String contentType);
    String presignedUrl(String key, int expiryMinutes);
    void delete(String key);
}
