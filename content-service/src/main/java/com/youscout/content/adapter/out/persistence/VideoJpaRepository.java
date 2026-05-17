package com.youscout.content.adapter.out.persistence;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface VideoJpaRepository extends JpaRepository<VideoJpaEntity, UUID> {}
