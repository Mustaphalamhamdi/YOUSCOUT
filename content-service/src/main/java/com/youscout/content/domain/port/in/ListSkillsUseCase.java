package com.youscout.content.domain.port.in;

import com.youscout.content.domain.model.Skill;

import java.util.List;

public interface ListSkillsUseCase {
    List<Skill> listAll();
}
