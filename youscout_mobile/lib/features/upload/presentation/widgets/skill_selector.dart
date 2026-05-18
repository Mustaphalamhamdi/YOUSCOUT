import 'package:flutter/material.dart';
import 'package:youscout_mobile/core/theme/app_colors.dart';

class SkillSelector extends StatelessWidget {
  final List<String> available;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const SkillSelector({
    super.key,
    required this.available,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: available.map((skill) {
        final isSelected = selected.contains(skill);
        return FilterChip(
          label: Text(skill),
          selected: isSelected,
          selectedColor: AppColors.footballGreen.withValues(alpha: 0.2),
          checkmarkColor: AppColors.footballGreen,
          onSelected: (v) {
            final updated = [...selected];
            v ? updated.add(skill) : updated.remove(skill);
            onChanged(updated);
          },
        );
      }).toList(),
    );
  }
}
