import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lactocompanion/l10n/app_localizations.dart';
import '../video/videoplayerpage.dart';

// 🔹 Enum for filter (language independent)
enum VideoFilter { all, pending, completed }

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> videos = [];
  Map<int, Map<String, dynamic>> progressByVideo = {};
  bool isLoading = true;
  VideoFilter selectedFilter = VideoFilter.all;

  @override
  void initState() {
    super.initState();
    _fetchVideosAndProgress();
  }

  // ✅ Multilingual text getter
  String _getLocalized(Map<String, dynamic> data, String key) {
    final lang = AppLocalizations.of(context)!.localeName;
    return data["${key}_$lang"] ?? data["${key}_en"] ?? "";
  }

  Future<void> _fetchVideosAndProgress() async {
    try {
      setState(() => isLoading = true);

      final vRes = await supabase.from("videos").select("*").order("id");
      videos = List<Map<String, dynamic>>.from(vRes);

      final user = supabase.auth.currentUser;
      if (user != null) {
        final pRes = await supabase
            .from("video_progress")
            .select("*")
            .eq("user_id", user.id);

        progressByVideo = {};
        for (final row in pRes) {
          progressByVideo[row['video_id']] =
              Map<String, dynamic>.from(row as Map);
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching videos: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 🔹 Filter videos
  List<Map<String, dynamic>> getFilteredVideos() {
    if (selectedFilter == VideoFilter.pending) {
      return videos.where((v) {
        final prog = progressByVideo[v['id']];
        return prog == null || prog['is_completed'] != true;
      }).toList();
    } else if (selectedFilter == VideoFilter.completed) {
      return videos.where((v) {
        final prog = progressByVideo[v['id']];
        return prog != null && prog['is_completed'] == true;
      }).toList();
    }
    return videos; // All
  }

  Future<void> _openVideo(Map<String, dynamic> video) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerPage(
          title: _getLocalized(video, "title"),
          videoUrl: video['video_url'],
          videoId: video['id'],
        ),
      ),
    );

    // ✅ Refresh after coming back
    await _fetchVideosAndProgress();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filteredVideos = getFilteredVideos();
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFDEFF4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        title: Text(
          loc.videos,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // 🔹 Filter Tabs (scrollable fixed version)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  _buildFilterChip(loc.videos, videos.length, VideoFilter.all),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    loc.pending,
                    videos.where((v) {
                      final prog = progressByVideo[v['id']];
                      return prog == null || prog['is_completed'] != true;
                    }).length,
                    VideoFilter.pending,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    loc.completed,
                    videos.where((v) {
                      final prog = progressByVideo[v['id']];
                      return prog != null && prog['is_completed'] == true;
                    }).length,
                    VideoFilter.completed,
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),

          // 🔹 Video List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredVideos.isEmpty
                    ? Center(
                        child: Text(
                          loc.noVideosFound,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredVideos.length,
                        itemBuilder: (context, index) {
                          final video = filteredVideos[index];
                          final progress = progressByVideo[video['id']];
                          final badge = _buildStatusBadge(video, progress, loc);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () => _openVideo(video),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(22),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 14,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Image.network(
                                        video['thumbnail'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        248,
                                        200,
                                        217,
                                      ),
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.pink[400],
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _getLocalized(video, "title"),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    badge,
                                  ],
                                ),
                                const SizedBox(height: 6),

                                ExpandableText(
                                  text: _getLocalized(video, "description"),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // 🔹 Status Badge
  Widget _buildStatusBadge(
    Map<String, dynamic> video,
    Map<String, dynamic>? prog,
    AppLocalizations loc,
  ) {
    if (prog == null) {
      return _chip(loc.pending, Colors.orange);
    }
    if (prog['is_completed'] == true) {
      return _chip(loc.completed, Colors.green);
    }
    final watched = (prog['watched_seconds'] ?? 0) as int;
    return _chip("${loc.watched} ${watched ~/ 60}m", Colors.blue);
  }

  Widget _chip(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // 🔹 Filter Chip Widget
  Widget _buildFilterChip(String label, int count, VideoFilter filter) {
    final isSelected = selectedFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = filter),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.pink[400] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.pink.shade400 : Colors.pink.shade200,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Text(
          "$label ($count)",
          style: GoogleFonts.poppins(
            color: isSelected
                ? Colors.white
                : const Color.fromARGB(255, 207, 165, 179),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// 🔹 ExpandableText Widget
class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({super.key, required this.text, this.maxLines = 3});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final span = TextSpan(
      text: widget.text,
      style: GoogleFonts.poppins(color: Colors.black54, fontSize: 12),
    );

    final tp = TextPainter(
      text: span,
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 40);

    final exceeded = tp.didExceedMaxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            widget.text,
            maxLines: widget.maxLines,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(color: Colors.black54, fontSize: 12),
          ),
          secondChild: Text(
            widget.text,
            style: GoogleFonts.poppins(color: Colors.black54, fontSize: 12),
          ),
          crossFadeState:
              expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        if (exceeded)
          InkWell(
            onTap: () => setState(() => expanded = !expanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                expanded ? loc.readLess : loc.readMore,
                style: GoogleFonts.poppins(
                  color: Colors.pink[400],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
