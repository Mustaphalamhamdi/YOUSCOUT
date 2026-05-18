import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youscout_mobile/core/l10n/strings.dart';
import 'package:youscout_mobile/core/network/dio_provider.dart';
import 'package:youscout_mobile/features/feed/presentation/providers/feed_providers.dart';
import 'package:youscout_mobile/features/feed/presentation/widgets/video_player_card.dart';
import 'package:youscout_mobile/shared/widgets/error_view.dart';
import 'package:youscout_mobile/shared/widgets/loading_indicator.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  int _currentPage = 0;

  void _showFollowDialog() {
    final followerIdCtrl = TextEditingController();
    final followeeIdCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.followUser),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: followerIdCtrl,
              decoration: const InputDecoration(labelText: 'Your User ID'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: followeeIdCtrl,
              decoration: const InputDecoration(labelText: AppStrings.followeeIdHint),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final storage = ref.read(secureStorageProvider);
              final myId = await storage.readUserId() ?? followerIdCtrl.text;
              await ref
                  .read(feedNotifierProvider.notifier)
                  .followUser(myId, followeeIdCtrl.text.trim());
              if (ctx.mounted) Navigator.pop(ctx);
              ref.read(feedNotifierProvider.notifier).refresh();
            },
            child: const Text(AppStrings.followUser),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(feedNotifierProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          AppStrings.appName,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            tooltip: AppStrings.followUser,
            onPressed: _showFollowDialog,
          ),
        ],
      ),
      body: feedAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(
          message: e.toString().replaceFirst('Exception: ', ''),
          onRetry: () => ref.read(feedNotifierProvider.notifier).refresh(),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.videocam_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(AppStrings.feedEmpty, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => ref.read(feedNotifierProvider.notifier).refresh(),
                    child: const Text(AppStrings.retry),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(feedNotifierProvider.notifier).refresh(),
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: items.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) => VideoPlayerCard(
                item: items[i],
                isActive: i == _currentPage,
              ),
            ),
          );
        },
      ),
    );
  }
}
