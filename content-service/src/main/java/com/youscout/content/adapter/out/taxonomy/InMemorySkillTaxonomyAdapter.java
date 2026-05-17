package com.youscout.content.adapter.out.taxonomy;

import com.youscout.content.domain.model.Skill;
import com.youscout.content.domain.port.out.SkillTaxonomyProvider;
import org.springframework.stereotype.Component;

import java.util.List;

// PATTERN: Adapter (out/taxonomy) — static taxonomy for MVP.
// OCP: new skills added here without touching domain services.
// In production: replace with a database-backed or API-backed adapter.
@Component
public class InMemorySkillTaxonomyAdapter implements SkillTaxonomyProvider {

    private static final List<Skill> SKILLS = List.of(
            Skill.of("DRIBBLING", "Dribbling"),
            Skill.of("WEAK_FOOT_FINISHING", "Weak Foot Finishing"),
            Skill.of("VISION", "Vision & Passing"),
            Skill.of("POSITIONING", "Positioning"),
            Skill.of("FIRST_TOUCH", "First Touch"),
            Skill.of("PACE", "Pace"),
            Skill.of("HEADING", "Heading"),
            Skill.of("FREE_KICK", "Free Kick"),
            Skill.of("TACKLING", "Tackling"),
            Skill.of("LONG_PASS", "Long Pass")
    );

    @Override
    public List<Skill> getAll() {
        return SKILLS;
    }
}
