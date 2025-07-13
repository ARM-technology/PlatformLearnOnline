import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:web_learn/SecurtVide.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerPage({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  String? _error;
  final VideoProtectionManager _videoProtectionManager = VideoProtectionManager();

  @override
  void initState() {
    super.initState();
    _videoProtectionManager.initializeProtection(context);
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _videoPlayerController.initialize();
      _createChewieController();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print("❌ Error initializing video player: $e");
      if (mounted) {
        setState(() {
          _error = "فشل في تهيئة الفيديو. تأكد من صلاحية الرابط.";
        });
      }
    }
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowedScreenSleep: false,
      allowFullScreen: true, // Enabled fullscreen
      showControls: true,
      showControlsOnInitialize: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.blueAccent,
        handleColor: Colors.blueAccent,
        bufferedColor: Colors.grey.shade700,
        backgroundColor: Colors.grey.shade800,
      ),
      placeholder: Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_circle_outline, color: Colors.white, size: 64),
              SizedBox(height: 16),
              Text("جاري تحميل الفيديو...", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showPlaybackSpeedDialog() async {
    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
    final selectedSpeed = await showModalBottomSheet<double>(
      context: context,
      backgroundColor: const Color(0xFF2D3748),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'سرعة التشغيل',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...speeds.map((speed) => ListTile(
            leading: Icon(
              Icons.speed,
              color: _videoPlayerController.value.playbackSpeed == speed
                  ? Colors.blueAccent
                  : Colors.grey,
            ),
            title: Text(
              '${speed}x',
              style: TextStyle(
                color: _videoPlayerController.value.playbackSpeed == speed
                    ? Colors.blueAccent
                    : Colors.white,
                fontWeight: _videoPlayerController.value.playbackSpeed == speed
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            onTap: () => Navigator.of(context).pop(speed),
          )),
        ],
      ),
    );

    if (selectedSpeed != null) {
      _videoPlayerController.setPlaybackSpeed(selectedSpeed);
    }
  }

  @override
  void dispose() {
    _videoProtectionManager.disposeProtection();
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "مشغل الفيديو",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.speed, color: Colors.white),
            onPressed: _showPlaybackSpeedDialog,
          ),
        ],
      ),
      body: Center(
        child: _chewieController != null &&
            _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : _error != null
            ? _buildErrorWidget()
            : _buildLoadingWidget(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(
            _error!,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _error = null;
              });
              initializePlayer();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.black,
            ),
            child: const Text("إعادة المحاولة"),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: Colors.blueAccent),
        SizedBox(height: 20),
        Text(
          "جاري تحميل الفيديو...",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}


