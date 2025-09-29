import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoPlayerPage extends StatefulWidget {
  final String title;
  final String videoUrl;
  final int videoId;

  const VideoPlayerPage({
    super.key,
    required this.title,
    required this.videoUrl,
    required this.videoId,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _ready = false;

  final supabase = Supabase.instance.client;
  Timer? _progressTimer;

  static const int _interval = 5;
  static const double _completionThreshold = 0.9;

  int likeCount = 0;
  bool isLiked = false;
  bool hasStarted = false;
  String description = "";

  @override
  void initState() {
    super.initState();
    _initVideo();
    _fetchLikes();
    _checkProgress();
    _fetchDescription();
  }

  Future<void> _initVideo() async {
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await _videoController.initialize();
    setState(() {
      _ready = true;
      _initChewie();
    });

    _videoController.addListener(_checkVideoEnd);
    _progressTimer =
        Timer.periodic(const Duration(seconds: _interval), (_) => _saveProgress());
  }

  void _initChewie() {
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      allowPlaybackSpeedChanging: true,
      showOptions: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.pink,
        handleColor: Colors.pinkAccent,
        bufferedColor: Colors.grey.shade400,
        backgroundColor: Colors.grey.shade300,
      ),
    );
  }

  void _checkVideoEnd() {
    if (!_ready) return;
    final value = _videoController.value;
    if (value.position >= value.duration && value.duration.inSeconds > 0) {
      _markVideoCompleted();
      _progressTimer?.cancel();
    }
  }

  Future<void> _saveProgress({bool forceComplete = false}) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null || !_ready) return;

      final pos = _videoController.value.position.inSeconds;
      final total = _videoController.value.duration.inSeconds;
      String status = "pending";
      bool completed = forceComplete;

      if (total > 0) {
        final percent = pos / total;
        if (completed || percent >= _completionThreshold) {
          completed = true;
          status = "completed";
        } else if (pos > 0) {
          status = "on_going";
        }
      }

      final existing = await supabase
          .from('video_progress')
          .select("is_completed")
          .eq("user_id", user.id)
          .eq("video_id", widget.videoId)
          .maybeSingle();

      if (existing != null && existing["is_completed"] == true) {
        return;
      }

      await supabase.from('video_progress').upsert({
        'user_id': user.id,
        'video_id': widget.videoId,
        'watched_seconds': pos,
        'is_completed': completed,
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint("❌ Error saving progress: $e");
    }
  }

  Future<void> _markVideoCompleted() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        await supabase.from("video_progress").upsert({
          "user_id": user.id,
          "video_id": widget.videoId,
          "is_completed": true,
          "status": "completed",
          "watched_seconds": _videoController.value.duration.inSeconds,
          "updated_at": DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      debugPrint("❌ Error marking complete: $e");
    }
  }

  Future<void> _fetchLikes() async {
    try {
      final res = await supabase
          .from("video_likes")
          .select()
          .eq("video_id", widget.videoId);

      setState(() => likeCount = res.length);

      final user = supabase.auth.currentUser;
      if (user != null) {
        final userLike = res.any((r) => r['user_id'] == user.id);
        setState(() => isLiked = userLike);
      }
    } catch (e) {
      debugPrint("❌ Error fetching likes: $e");
    }
  }

  Future<void> _toggleLike() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      if (isLiked) {
        await supabase
            .from("video_likes")
            .delete()
            .eq("video_id", widget.videoId)
            .eq("user_id", user.id);
      } else {
        await supabase.from("video_likes").insert({
          "video_id": widget.videoId,
          "user_id": user.id,
        });
      }
      _fetchLikes();
    } catch (e) {
      debugPrint("❌ Error toggling like: $e");
    }
  }

  Future<void> _checkProgress() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    final res = await supabase
        .from("video_progress")
        .select("status")
        .eq("user_id", user.id)
        .eq("video_id", widget.videoId)
        .maybeSingle();

    if (res != null && res["status"] != "pending") {
      setState(() => hasStarted = true);
    }
  }

  Future<void> _fetchDescription() async {
    try {
      final res = await supabase
          .from("videos")
          .select("description")
          .eq("id", widget.videoId)
          .maybeSingle();

      if (res != null) {
        setState(() => description = res["description"] ?? "");
      }
    } catch (e) {
      debugPrint("❌ Error fetching description: $e");
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _videoController.removeListener(_checkVideoEnd);
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: _ready
          ? ListView(
              padding: const EdgeInsets.all(12),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: Chewie(controller: _chewieController!),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.pink[100],
                      child: const Icon(Icons.person, color: Colors.black54),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Uploaded by Admin",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _action(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                      "$likeCount Likes",
                      _toggleLike,
                    ),
                    _action(Icons.comment_outlined, "Comment", () {
                      _openComments(context);
                    }),
                    _action(Icons.share, "Share", () {
                      Share.share("Watch this video: ${widget.videoUrl}");
                    }),
                  ],
                ),
                const Divider(height: 32),

                if (!hasStarted)
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _videoController.play(),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink),
                      child: Text(
                        "Watch Now",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    "Video Description",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        description.isEmpty
                            ? "No description available"
                            : description,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _action(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.pink[400], size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.pink[400],
            ),
          ),
        ],
      ),
    );
  }

  void _openComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CommentSheet(videoId: widget.videoId),
    );
  }
}

class CommentSheet extends StatefulWidget {
  final int videoId;
  const CommentSheet({super.key, required this.videoId});

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final supabase = Supabase.instance.client;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final res = await supabase
          .from("video_comments")
          .select("comment_text, profiles(name)")
          .eq("video_id", widget.videoId)
          .order("created_at", ascending: false);

      if (!mounted) return;
      setState(() {
        comments = List<Map<String, dynamic>>.from(res);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Error loading comments: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> _addComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.from("video_comments").insert({
        "video_id": widget.videoId,
        "user_id": user.id,
        "comment_text": text,
      });
      _controller.clear();
      _fetchComments();
    } catch (e) {
      debugPrint("❌ Error adding comment: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, controller) => Column(
          children: [
            Container(
              width: 50,
              height: 6,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Text(
              "Comments",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : comments.isEmpty
                      ? Text(
                          "No comments yet.",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        )
                      : ListView.builder(
                          controller: controller,
                          itemCount: comments.length,
                          itemBuilder: (_, i) {
                            final c = comments[i];
                            final name = c["profiles"]?["name"] ?? "Unknown";
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.pink[100],
                                child: const Icon(Icons.person,
                                    color: Colors.black54),
                              ),
                              title: Text(
                                c["comment_text"],
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                name,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Add a comment...",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.pink[400]),
                    onPressed: _addComment,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
