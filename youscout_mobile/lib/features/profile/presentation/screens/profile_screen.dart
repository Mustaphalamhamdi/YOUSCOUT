import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youscout_mobile/core/l10n/strings.dart';
import 'package:youscout_mobile/core/theme/app_colors.dart';
import 'package:youscout_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:youscout_mobile/features/profile/domain/entities/profile.dart';
import 'package:youscout_mobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:youscout_mobile/features/profile/presentation/widgets/profile_edit_form.dart';
import 'package:youscout_mobile/shared/widgets/error_view.dart';
import 'package:youscout_mobile/shared/widgets/loading_indicator.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showEditSheet(BuildContext context, Profile profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ProfileEditForm(profile: profile),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: AppStrings.logout,
            onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(
          message: e.toString().replaceFirst('Exception: ', ''),
          onRetry: () => ref.invalidate(profileNotifierProvider),
        ),
        data: (profile) => _ProfileBody(
          profile: profile,
          onEdit: () => _showEditSheet(context, profile),
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final Profile profile;
  final VoidCallback onEdit;

  const _ProfileBody({required this.profile, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final initials = profile.displayName.isNotEmpty
        ? profile.displayName[0].toUpperCase()
        : '?';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.primaryNavy,
            child: Text(initials,
                style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 16),
          Text(profile.displayName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(profile.email, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
            label: const Text(AppStrings.editProfile),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primaryNavy),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          if (profile.bio != null && profile.bio!.isNotEmpty)
            _InfoRow(label: AppStrings.bio, value: profile.bio!),
          if (profile.position != null && profile.position!.isNotEmpty)
            _InfoRow(label: AppStrings.position, value: profile.position!),
          if (profile.foot != null && profile.foot!.isNotEmpty)
            _InfoRow(label: AppStrings.foot, value: profile.foot!),
          const SizedBox(height: 8),
          Text('User ID: ${profile.userId}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          const Text('(Copy to use in Follow dialog)',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
