package com.youscout.content.domain.service;

import com.youscout.content.domain.model.Skill;
import com.youscout.content.domain.port.in.ListSkillsUseCase;
import com.youscout.content.domain.port.out.SkillTaxonomyProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ListSkillsService implements ListSkillsUseCase {

    private final SkillTaxonomyProvider taxonomyProvider;

    @Override
    public List<Skill> listAll() {
        return taxonomyProvider.getAll();
    }
}
