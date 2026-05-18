import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youscout_mobile/features/feed/domain/entities/feed_item.dart';
import 'package:youscout_mobile/features/feed/presentation/widgets/feed_item_overlay.dart';

class VideoPlayerCard extends StatefulWidget {
  final FeedItem item;
  final bool isActive;

  const VideoPlayerCard({super.key, required this.item, required this.isActive});

  @override
  State<VideoPlayerCard> createState() => _VideoPlayerCardState();
}

class _VideoPlayerCardState extends State<VideoPlayerCard> {
  VideoPlayerController? _vpController;
  ChewieController? _chewieController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final url = widget.item.streamUrl;
    if (url == null || url.isEmpty) return;

    _vpController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _vpController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _vpController!,
      autoPlay: widget.isActive,
      looping: true,
      showControls: false,
      aspectRatio: _vpController!.value.aspectRatio,
    );

    if (mounted) setState(() => _initialized = true);
  }

  @override
  void didUpdateWidget(VideoPlayerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _vpController?.play();
      } else {
        _vpController?.pause();
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _vpController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_vpController == null) return;
        _vpController!.value.isPlaying
            ? _vpController!.pause()
            : _vpController!.play();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black),
          if (_initialized && _chewieController != null)
            Chewie(controller: _chewieController!)
          else if (widget.item.streamUrl == null)
            const Center(
              child: Icon(Icons.video_library, color: Colors.white54, size: 64),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          // Gradient overlay for readability
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: FeedItemOverlay(item: widget.item),
          ),
        ],
      ),
    );
  }
}
