import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lactocompanion/l10n/app_localizations.dart'; // ✅ Localization import
import '../Profile/profile.dart';
import '../video/videoplayerpage.dart';
import '../video/videopage.dart';
import '../Chat/chat_page.dart';
import '../booking/booking_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  String? userName;

  List<Map<String, dynamic>> videos = [];
  Map<int, Map<String, dynamic>> progressByVideo = {};
  bool isLoading = true;

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => isLoading = true);
    await _loadUser();
    await _fetchVideosAndProgress();
    setState(() => isLoading = false);
  }

  Future<void> _loadUser() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      try {
        final profile = await supabase
            .from("profiles")
            .select("name")
            .eq("id", user.id)
            .maybeSingle();

        setState(() {
          userName = profile?["name"] ?? "Guest";
        });
      } catch (e) {
        setState(() {
          userName = "Guest";
        });
      }
    } else {
      setState(() {
        userName = "Guest";
      });
    }
  }

  Future<void> _fetchVideosAndProgress() async {
    try {
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
          progressByVideo[row['video_id']] = Map<String, dynamic>.from(
            row as Map,
          );
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching: $e");
    }
  }

  Future<void> _openVideo(Map<String, dynamic> video) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerPage(
          title: getLocalizedTitle(video, context),
          videoUrl: video['video_url'],
          videoId: video['id'],
        ),
      ),
    );
    await _fetchVideosAndProgress();
    setState(() {});
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  // ✅ Helper Functions
  String getLocalizedTitle(Map<String, dynamic> video, BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == "ar") {
      return video["title_ar"]?.toString().trim().isNotEmpty == true
          ? video["title_ar"]
          : (video["title_en"] ?? video["title"] ?? "Untitled");
    }
    return video["title_en"]?.toString().trim().isNotEmpty == true
        ? video["title_en"]
        : (video["title"] ?? "Untitled");
  }

  String getLocalizedDescription(Map<String, dynamic> video, BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == "ar") {
      return video["description_ar"]?.toString().trim().isNotEmpty == true
          ? video["description_ar"]
          : (video["description_en"] ?? video["description"] ?? "");
    }
    return video["description_en"]?.toString().trim().isNotEmpty == true
        ? video["description_en"]
        : (video["description"] ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final helloName = userName ?? loc.guest;
    final filteredVideos = [...videos];
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      body: Directionality(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromRGBO(249, 182, 203, 1), Color(0xFFFDEFF4)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // 🔹 Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.hello,
                            textAlign: isRTL ? TextAlign.right : TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            helloName,
                            textAlign: isRTL ? TextAlign.right : TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            loc.findVideo,
                            textAlign: isRTL ? TextAlign.right : TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // 🔹 Search bar
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: TextField(
                              textAlign: isRTL ? TextAlign.right : TextAlign.left,
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: loc.searchVideos,
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                                prefixIcon: isRTL
                                    ? null
                                    : const Icon(Icons.search, color: Colors.grey),
                                suffixIcon: isRTL
                                    ? const Icon(Icons.search, color: Colors.grey)
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: isRTL ? null : 0,
                        left: isRTL ? 0 : null,
                        top: 0,
                        child: GestureDetector(
                          onTap: _openProfile,
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Colors.pink[400], size: 26),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔹 Videos
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 244, 249),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(34),
                        topRight: Radius.circular(34),
                      ),
                    ),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
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
                                          backgroundColor: const Color.fromARGB(255, 248, 200, 217),
                                          child: Icon(Icons.play_arrow, color: Colors.pink[400], size: 20),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            getLocalizedTitle(video, context),
                                            textAlign: isRTL ? TextAlign.right : TextAlign.left,
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
                                      text: getLocalizedDescription(video, context),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navIcon(Icons.home, isActive: true, onTap: () {}),
              _navIcon(Icons.play_circle_fill, onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VideoPage()),
                );
                await _fetchVideosAndProgress();
                setState(() {});
              }),
              _navIcon(Icons.event, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExpertConsultationPage()),
                );
              }),
              _navIcon(Icons.chat_bubble, onTap: () async {
                final user = supabase.auth.currentUser;
                if (user != null) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChatPage()),
                  );
                }
              }),
              _navIcon(Icons.person, onTap: _openProfile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(
    Map<String, dynamic> video,
    Map<String, dynamic>? prog,
    AppLocalizations loc,
  ) {
    if (prog == null) return _chip(loc.pending, Colors.orange);
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
      child: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _navIcon(IconData icon, {bool isActive = false, VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: isActive ? Colors.pink[400] : const Color(0xFFFDEFF4),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(
          icon,
          size: 24,
          color: isActive ? Colors.white : Colors.pink[400],
        ),
      ),
    );
  }
}

// 🔹 ExpandableText
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
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    final span = TextSpan(
      text: widget.text,
      style: GoogleFonts.poppins(color: Colors.black54, fontSize: 12),
    );

    final tp = TextPainter(
      text: span,
      maxLines: widget.maxLines,
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 40);

    final exceeded = tp.didExceedMaxLines;

    return Column(
      crossAxisAlignment:
          isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            widget.text,
            textAlign: isRTL ? TextAlign.right : TextAlign.left,
            maxLines: widget.maxLines,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(color: Colors.black54, fontSize: 12),
          ),
          secondChild: Text(
            widget.text,
            textAlign: isRTL ? TextAlign.right : TextAlign.left,
            style: GoogleFonts.poppins(color: Colors.black54, fontSize: 12),
          ),
          crossFadeState: expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
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
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
              ),
            ),
          ),
      ],
    );
  }
}
