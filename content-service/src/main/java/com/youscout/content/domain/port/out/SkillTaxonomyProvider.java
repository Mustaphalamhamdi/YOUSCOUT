package com.youscout.content.domain.port.out;

import com.youscout.content.domain.model.Skill;

import java.util.List;

// OCP: new skills added in the adapter without touching domain logic
public interface SkillTaxonomyProvider {
    List<Skill> getAll();
}
