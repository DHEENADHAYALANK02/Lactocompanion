import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lactocompanion/l10n/app_localizations.dart';

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

  bool hasStarted = false;
  bool _isExpanded = false;

  // 🌍 Multi-language descriptions
  String description = "";
  String descriptionEn = "";
  String descriptionAr = "";

  @override
  void initState() {
    super.initState();
    _initVideo();
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
        playedColor: const Color(0xFFE91E63),
        handleColor: const Color(0xFFFF4081),
        bufferedColor: Colors.grey.shade300,
        backgroundColor: Colors.grey.shade200,
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

  // 🌍 Fetch all language descriptions
  Future<void> _fetchDescription() async {
    try {
      final res = await supabase
          .from("videos")
          .select("description, description_en, description_ar")
          .eq("id", widget.videoId)
          .maybeSingle();

      if (res != null) {
        setState(() {
          description = res["description"] ?? "";
          descriptionEn = res["description_en"] ?? "";
          descriptionAr = res["description_ar"] ?? "";
        });
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
    final loc = AppLocalizations.of(context)!;
    final currentLang = Localizations.localeOf(context).languageCode;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final isMediumScreen = size.width >= 360 && size.width < 600;

    // 🌍 Choose correct description dynamically
    String descToShow = "";
    if (currentLang == "en") {
      descToShow = descriptionEn.isNotEmpty
          ? descriptionEn
          : (description.isNotEmpty ? description : loc.noDescription);
    } else if (currentLang == "ar") {
      descToShow = descriptionAr.isNotEmpty
          ? descriptionAr
          : (description.isNotEmpty ? description : loc.noDescription);
    } else {
      descToShow = description.isNotEmpty ? description : loc.noDescription;
    }

    // Responsive padding
    final horizontalPadding = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);
    final verticalSpacing = isSmallScreen ? 16.0 : 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          // 🎨 Modern App Bar with gradient
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, size: 20, color: Colors.black87),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: isSmallScreen ? 16 : 18,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

          ),

          // 🎥 Video Player Section
          SliverToBoxAdapter(
            child: _ready
                ? Container(
                    color: Colors.black,
                    child: AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: Chewie(controller: _chewieController!),
                    ),
                  )
                : Container(
                    height: size.height * 0.3,
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                      ),
                    ),
                  ),
          ),

          // 📱 Content Section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: verticalSpacing),

                  // 🏷 Title Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  ),

                  SizedBox(height: verticalSpacing / 2),

                  // 📊 Progress Indicator (if started)
                  if (hasStarted)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.play_circle_filled, color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              loc.watchNow,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  SizedBox(height: verticalSpacing),

                  // 👤 Author Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Row(
                      children: [
                        Container(
                          width: isSmallScreen ? 40 : 48,
                          height: isSmallScreen ? 40 : 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFE91E63).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.uploadedByAdmin,
                                style: GoogleFonts.poppins(
                                  fontSize: isSmallScreen ? 14 : 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Educational Content",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: verticalSpacing),

                  // ▶️ Watch Button (if not started)
                  if (!hasStarted)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE91E63).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _videoController.play(),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 14 : 16,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.play_circle_filled, color: Colors.white, size: 28),
                                  const SizedBox(width: 12),
                                  Text(
                                    loc.watchNow,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: isSmallScreen ? 15 : 16,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: verticalSpacing * 1.5),
                ],
              ),
            ),
          ),

          // 📜 Description Section
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(horizontalPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: currentLang == "ar"
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(horizontalPadding),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE91E63).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.description_outlined,
                            color: Color(0xFFE91E63),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          loc.videoDescription,
                          style: GoogleFonts.poppins(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                  Padding(
                    padding: EdgeInsets.all(horizontalPadding),
                    child: AnimatedCrossFade(
                      firstChild: Text(
                        descToShow.length > 150 ? '${descToShow.substring(0, 150)}...' : descToShow,
                        textAlign: currentLang == "ar" ? TextAlign.right : TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 13 : 14,
                          color: Colors.grey.shade700,
                          height: 1.7,
                        ),
                      ),
                      secondChild: Text(
                        descToShow,
                        textAlign: currentLang == "ar" ? TextAlign.right : TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 13 : 14,
                          color: Colors.grey.shade700,
                          height: 1.7,
                        ),
                      ),
                      crossFadeState: _isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ),
                  if (descToShow.length > 150)
                    InkWell(
                      onTap: () => setState(() => _isExpanded = !_isExpanded),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: horizontalPadding,
                          right: horizontalPadding,
                          bottom: horizontalPadding,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isExpanded ? "Show less" : "Show more",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFE91E63),
                              ),
                            ),
                            Icon(
                              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: const Color(0xFFE91E63),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}