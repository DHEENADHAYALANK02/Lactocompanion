import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  String searchQuery = ""; // 🔹 search text

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
        debugPrint("❌ Error loading user: $e");
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
          title: video['title'],
          videoUrl: video['video_url'],
          videoId: video['id'],
        ),
      ),
    );

    // ✅ Back vandhathum progress DB la irundhu fetch pannudhu
    await _fetchVideosAndProgress();
    setState(() {});
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final helloName = userName ?? "There";

    // 🔹 Filter + Sort videos by searchQuery
    final filteredVideos = [...videos];
    if (searchQuery.isNotEmpty) {
      filteredVideos.sort((a, b) {
        final aTitle = (a['title'] ?? '').toString().toLowerCase();
        final aDesc = (a['description'] ?? '').toString().toLowerCase();
        final bTitle = (b['title'] ?? '').toString().toLowerCase();
        final bDesc = (b['description'] ?? '').toString().toLowerCase();

        final query = searchQuery.toLowerCase();

        final aMatch = (aTitle.contains(query) || aDesc.contains(query))
            ? 1
            : 0;
        final bMatch = (bTitle.contains(query) || bDesc.contains(query))
            ? 1
            : 0;

        return bMatch.compareTo(aMatch); // match aana video first
      });
    }

    return Scaffold(
      body: Container(
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
              // 🔹 Header Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello 👋",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          helloName,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Lets Find Your Video",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // 🔹 Search Bar
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
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Search videos",
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Profile Avatar top-right
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: _openProfile,
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Colors.pink[400],
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Videos Section
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
                            final badge = _buildStatusBadge(video, progress);

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
                                            color: Colors.black.withOpacity(
                                              0.08,
                                            ),
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
                                          video['title'] ?? "Untitled",
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
                                    text:
                                        video['description'] ??
                                        "No description available",
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

      // 🔹 Bottom Navigation
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
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
            _navIcon(
              Icons.play_circle_fill,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VideoPage()),
                );
                // ✅ Back vandhathum refresh pannudhu
                await _fetchVideosAndProgress();
                setState(() {});
              },
            ),
            _navIcon(Icons.event, onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const ExpertConsultationPage()),
  );
}),

            _navIcon(
              Icons.chat_bubble,
              onTap: () async {
                final user = supabase.auth.currentUser;
                if (user != null) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                      ),
                    ),
                  );
                }
              },
            ),

            _navIcon(Icons.person, onTap: _openProfile),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(
    Map<String, dynamic> video,
    Map<String, dynamic>? prog,
  ) {
    if (prog == null) {
      return _chip("Pending", Colors.orange);
    }
    if (prog['is_completed'] == true) {
      return _chip("Completed", Colors.green);
    }
    final watched = (prog['watched_seconds'] ?? 0) as int;
    return _chip("Watched ${watched ~/ 60}m", Colors.blue);
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
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
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
                expanded ? "Read less" : "Read more",
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
