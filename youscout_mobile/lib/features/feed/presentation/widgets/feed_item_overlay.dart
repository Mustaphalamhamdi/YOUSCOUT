import 'package:flutter/material.dart';
import 'package:youscout_mobile/core/theme/app_colors.dart';
import 'package:youscout_mobile/features/feed/domain/entities/feed_item.dart';

class FeedItemOverlay extends StatelessWidget {
  final FeedItem item;

  const FeedItemOverlay({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${item.uploaderName}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
          ),
          if (item.skills.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: item.skills
                  .map((s) => _SkillChip(skill: s))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String skill;
  const _SkillChip({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.footballGreen.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        skill,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
