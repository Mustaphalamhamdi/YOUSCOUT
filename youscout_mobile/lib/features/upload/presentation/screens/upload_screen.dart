import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youscout_mobile/core/l10n/strings.dart';
import 'package:youscout_mobile/core/theme/app_colors.dart';
import 'package:youscout_mobile/features/upload/domain/entities/upload_request.dart';
import 'package:youscout_mobile/features/upload/presentation/providers/upload_providers.dart';
import 'package:youscout_mobile/features/upload/presentation/widgets/skill_selector.dart';
import 'package:youscout_mobile/features/upload/presentation/widgets/video_preview.dart';
import 'package:youscout_mobile/shared/widgets/primary_button.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  String? _filePath;
  final _descCtrl = TextEditingController();
  final _hashtagsCtrl = TextEditingController();
  List<String> _selectedSkills = [];

  @override
  void dispose() {
    _descCtrl.dispose();
    _hashtagsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final xFile = await picker.pickVideo(source: ImageSource.gallery);
    if (xFile != null) setState(() => _filePath = xFile.path);
  }

  void _publish() {
    if (_filePath == null || _descCtrl.text.trim().isEmpty) return;
    final hashtags = _hashtagsCtrl.text
        .split(',')
        .map((h) => h.trim())
        .where((h) => h.isNotEmpty)
        .toList();
    ref.read(uploadNotifierProvider.notifier).upload(
          UploadRequest(
            filePath: _filePath!,
            description: _descCtrl.text.trim(),
            skillCodes: _selectedSkills,
            hashtags: hashtags,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadNotifierProvider);
    final skillsAsync = ref.watch(skillsProvider);
    final isUploading = uploadState.status == UploadStatus.uploading;

    ref.listen(uploadNotifierProvider, (_, next) {
      if (next.status == UploadStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.uploadSuccess), backgroundColor: AppColors.footballGreen),
        );
        setState(() {
          _filePath = null;
          _descCtrl.clear();
          _hashtagsCtrl.clear();
          _selectedSkills = [];
        });
        ref.read(uploadNotifierProvider.notifier).reset();
      } else if (next.status == UploadStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? AppStrings.uploadError),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(uploadNotifierProvider.notifier).reset();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Video')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_filePath == null)
              GestureDetector(
                onTap: _pickVideo,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryNavy.withValues(alpha: 0.3)),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_library, size: 48, color: AppColors.primaryNavy),
                      SizedBox(height: 12),
                      Text(AppStrings.pickVideo,
                          style: TextStyle(color: AppColors.primaryNavy, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              )
            else ...[
              VideoPreview(filePath: _filePath!),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _pickVideo,
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Change video'),
              ),
            ],
            const SizedBox(height: 20),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: AppStrings.description),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hashtagsCtrl,
              decoration: const InputDecoration(
                labelText: AppStrings.hashtags,
                hintText: 'dribbling, pace, goals',
              ),
            ),
            const SizedBox(height: 16),
            Text('Skills', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            skillsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text('Could not load skills'),
              data: (skills) => SkillSelector(
                available: skills,
                selected: _selectedSkills,
                onChanged: (s) => setState(() => _selectedSkills = s),
              ),
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              label: AppStrings.publish,
              onPressed: (_filePath != null && !isUploading) ? _publish : null,
              isLoading: isUploading,
            ),
          ],
        ),
      ),
    );
  }
}
