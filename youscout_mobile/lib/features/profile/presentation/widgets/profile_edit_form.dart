import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youscout_mobile/core/l10n/strings.dart';
import 'package:youscout_mobile/features/profile/domain/entities/profile.dart';
import 'package:youscout_mobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:youscout_mobile/shared/widgets/primary_button.dart';

class ProfileEditForm extends ConsumerStatefulWidget {
  final Profile profile;
  const ProfileEditForm({super.key, required this.profile});

  @override
  ConsumerState<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends ConsumerState<ProfileEditForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _posCtrl;
  late final TextEditingController _footCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.profile.displayName);
    _bioCtrl = TextEditingController(text: widget.profile.bio ?? '');
    _posCtrl = TextEditingController(text: widget.profile.position ?? '');
    _footCtrl = TextEditingController(text: widget.profile.foot ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _posCtrl.dispose();
    _footCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(profileNotifierProvider.notifier).saveProfile(
            displayName: _nameCtrl.text.trim(),
            bio: _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim(),
            position: _posCtrl.text.trim().isEmpty ? null : _posCtrl.text.trim(),
            foot: _footCtrl.text.trim().isEmpty ? null : _footCtrl.text.trim(),
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppStrings.editProfile,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: AppStrings.displayName)),
          const SizedBox(height: 12),
          TextFormField(controller: _bioCtrl, maxLines: 2, decoration: const InputDecoration(labelText: AppStrings.bio)),
          const SizedBox(height: 12),
          TextFormField(controller: _posCtrl, decoration: const InputDecoration(labelText: AppStrings.position, hintText: 'e.g. Striker, Midfielder')),
          const SizedBox(height: 12),
          TextFormField(controller: _footCtrl, decoration: const InputDecoration(labelText: AppStrings.foot, hintText: 'Left / Right / Both')),
          const SizedBox(height: 24),
          PrimaryButton(label: AppStrings.saveChanges, onPressed: _save, isLoading: _saving),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
