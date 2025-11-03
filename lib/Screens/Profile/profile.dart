import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import 'language.dart';
import 'terms&conditions.dart';
import 'privacyPolicy.dart';
import '../../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  String userName = '';
  String userEmail = '';
  String selectedLanguage = 'Language';
  bool isEditing = false;
  bool isSaving = false;

  int totalVideos = 0;
  int pendingVideos = 0;
  int completedVideos = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadVideoStats();
    _showFeedbackPopup();

    _authSub = supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.userUpdated) {
        _loadUserData();
        _loadVideoStats();
      }
      if (event == AuthChangeEvent.signedOut) {
        if (mounted) {
          setState(() {
            userName = '';
            userEmail = '';
            _nameController.text = '';
            _emailController.text = '';
            totalVideos = 0;
            pendingVideos = 0;
            completedVideos = 0;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // 🟣 FEEDBACK POPUP
  void _showFeedbackPopup() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;

      int selectedRating = 0;
      final TextEditingController feedbackController = TextEditingController();
      bool isSubmitting = false;

      final List<Map<String, dynamic>> emojiRatings = [
        {'emoji': '😕', 'label': loc.feedbackBad, 'color': const Color(0xFFFF9800)},
        {'emoji': '😐', 'label': loc.feedbackOkay, 'color': const Color(0xFFFFC107)},
        {'emoji': '😊', 'label': loc.feedbackGood, 'color': const Color(0xFF66BB6A)},
        {'emoji': '😍', 'label': loc.feedbackExcellent, 'color': const Color(0xFF4CAF50)},
      ];

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          final isSmallScreen = screenWidth < 600;

          return StatefulBuilder(
            builder: (context, setDialogState) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isSmallScreen ? screenWidth * 0.9 : 500,
                    maxHeight: screenHeight * 0.85,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF0F5), Color(0xFFFFE4E6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(dialogContext),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Color(0xFF880E4F), size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFAD1457)]),
                            ),
                            child: const Icon(Icons.feedback, color: Colors.white, size: 36),
                          ),
                          const SizedBox(height: 16),
                          Text(loc.feedbackTitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF880E4F),
                              )),
                          const SizedBox(height: 8),
                          Text(loc.feedbackSubtitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 20),

                          // Rating Emojis
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE91E63).withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(loc.feedbackQuestion,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF880E4F))),
                                const SizedBox(height: 16),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: List.generate(emojiRatings.length, (index) {
                                    final rating = emojiRatings[index];
                                    final isSelected = selectedRating == index + 1;
                                    return GestureDetector(
                                      onTap: () => setDialogState(() => selectedRating = index + 1),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? (rating['color'] as Color).withOpacity(0.15)
                                              : Colors.grey[100],
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? rating['color'] as Color
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: Text(
                                          rating['emoji'] as String,
                                          style: TextStyle(fontSize: isSelected ? 32 : 26),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                if (selectedRating > 0) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    emojiRatings[selectedRating - 1]['label'] as String,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: emojiRatings[selectedRating - 1]['color'] as Color,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Feedback Text Input
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(loc.feedbackShareThoughts,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF880E4F),
                                    )),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: feedbackController,
                                  maxLines: 3,
                                  maxLength: 300,
                                  decoration: InputDecoration(
                                    hintText: loc.feedbackHint,
                                    hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Color(0xFFE91E63), width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isSubmitting
                                  ? null
                                  : () async {
                                      if (selectedRating == 0) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(loc.feedbackPleaseSelect,
                                                style: GoogleFonts.poppins()),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                        return;
                                      }

                                      setDialogState(() => isSubmitting = true);

                                      try {
                                        final user = supabase.auth.currentUser;
                                        if (user != null) {
                                          String fetchedUserName = user.userMetadata?['name'] ??
                                              user.userMetadata?['full_name'] ??
                                              user.email?.split('@')[0] ??
                                              'Anonymous User';

                                          await supabase.from('profile_feedback').insert({
                                            'user_id': user.id,
                                            'user_name': fetchedUserName,
                                            'rating': selectedRating,
                                            'feedback_text': feedbackController.text.trim().isEmpty
                                                ? null
                                                : feedbackController.text.trim(),
                                            'created_at': DateTime.now().toIso8601String(),
                                          });

                                          if (mounted) {
                                            Navigator.pop(dialogContext);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(loc.feedbackThankYou,
                                                    style: GoogleFonts.poppins()),
                                                backgroundColor: const Color(0xFF4CAF50),
                                              ),
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        debugPrint('❌ Feedback error: $e');
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(loc.feedbackError,
                                                  style: GoogleFonts.poppins()),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } finally {
                                        if (mounted) setDialogState(() => isSubmitting = false);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE91E63),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: isSubmitting
                                  ? const CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2)
                                  : Text(loc.feedbackSubmit,
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }

  // 🔥 LOCALIZED "GIVE FEEDBACK" FIX HERE
  Widget _buildMenuItems(AppLocalizations loc) {
    return Column(
      children: [
        _buildMenuItem(loc.giveFeedback, Icons.feedback, onTap: _showFeedbackPopup),
        const SizedBox(height: 16),
        _buildMenuItem(loc.termsTitle, Icons.description, onTap: _navigateToTermsOfCondition),
        const SizedBox(height: 16),
        _buildMenuItem(loc.privacyTitle, Icons.privacy_tip, onTap: _navigateToPrivacyPolicy),
        const SizedBox(height: 16),
        _buildMenuItem(loc.logout, Icons.logout, isLogout: true, onTap: _handleLogout),
      ],
    );
  }



  
  Future<void> _loadUserData() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      try {
        final profile = await supabase
            .from("profiles")
            .select("name")
            .eq("id", user.id)
            .maybeSingle();

        final fetchedName = profile?["name"] as String?;
        final fetchedEmail = user.email;

        if (!mounted) return;
        setState(() {
          userName = fetchedName ?? (user.userMetadata?['name'] ?? '');
          userEmail = fetchedEmail ?? '';
          _nameController.text = userName;
          _emailController.text = userEmail;
        });
      } catch (e) {
        debugPrint("❌ Error loading user data: $e");
      }
    } else {
      if (mounted) {
        setState(() {
          userName = '';
          userEmail = '';
          _nameController.text = '';
          _emailController.text = '';
        });
      }
    }
  }

  Future<void> _loadVideoStats() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final vRes = await supabase.from("videos").select("id");
      final allVideos = vRes as List<dynamic>? ?? [];

      final pRes = await supabase
          .from("video_progress")
          .select("status")
          .eq("user_id", user.id);

      final progressList = pRes as List<dynamic>? ?? [];

      final completed = progressList.where((row) {
        final status = (row as Map<String, dynamic>)["status"];
        return status == "completed";
      }).length;

      final ongoing = progressList.where((row) {
        final status = (row as Map<String, dynamic>)["status"];
        return status == "on_going";
      }).length;

      final pending = allVideos.length - (completed + ongoing);

      if (!mounted) return;
      setState(() {
        totalVideos = allVideos.length;
        completedVideos = completed;
        pendingVideos = pending < 0 ? 0 : pending;
      });
    } catch (e) {
      debugPrint("❌ Error fetching stats: $e");
    }
  }

  Future<void> _saveProfile() async {
    setState(() => isSaving = true);
    try {
      final updatedName = _nameController.text.trim();
      final updatedEmail = _emailController.text.trim();
      final user = supabase.auth.currentUser;

      if (user == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("❌ No user signed in",
                  style: GoogleFonts.poppins())),
        );
        setState(() => isSaving = false);
        return;
      }

      await supabase.auth.updateUser(
        UserAttributes(
          email: updatedEmail.isEmpty ? null : updatedEmail,
          data: {
            if (updatedName.isNotEmpty) 'name': updatedName,
          },
        ),
      );

      await supabase.from("profiles").upsert({
        "id": user.id,
        "name": updatedName,
        "email": updatedEmail,
      });

      if (!mounted) return;
      setState(() {
        userName = updatedName;
        userEmail = updatedEmail;
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("✅ Profile updated successfully",
                style: GoogleFonts.poppins())),
      );
    } catch (e) {
      if (!mounted) return;
      debugPrint("❌ Profile save error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("❌ Failed to update: $e", style: GoogleFonts.poppins())),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  void _toggleEdit() {
    if (isEditing) {
      _saveProfile();
    } else {
      setState(() => isEditing = true);
    }
  }

  void _navigateToLanguageSelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LanguageSelectionPage(currentLanguage: selectedLanguage),
      ),
    );

    if (result != null && result is Locale) {
      setState(() {
        selectedLanguage = result.languageCode == 'ar' ? "عربي" : "English";
      });

      MyApp.setLocale(context, result);
    }
  }

  void _navigateToTermsOfCondition() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsOfConditionPage()),
    );
  }

  void _navigateToPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
    );
  }

  void _handleLogout() async {
    final loc = AppLocalizations.of(context)!;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.confirmLogout, style: GoogleFonts.poppins()),
        content: Text(loc.logoutMessage, style: GoogleFonts.poppins()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(loc.cancel, style: GoogleFonts.poppins())),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(loc.logout, style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await supabase.auth.signOut();
      } catch (e) {
        debugPrint("❌ Logout error: $e");
      }

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 182, 203, 1),
      body: Column(
        children: [
          _buildAppBar(loc),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 244, 249),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLanguageButton(),
                    const SizedBox(height: 24),
                    _buildProfileSection(loc),
                    const SizedBox(height: 32),
                    _buildStatsSection(loc),
                    const SizedBox(height: 32),
                    _buildMenuItems(loc),
                    const SizedBox(height: 32),
                    _buildAboutUsSection(loc),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 24),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 12),
          Text(
            loc.profile,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLanguageButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: _navigateToLanguageSelection,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, size: 16, color: Colors.black54),
                const SizedBox(width: 6),
                Text(
                  selectedLanguage,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(AppLocalizations loc) {
    return Row(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, color: Colors.pink[400], size: 45),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: isEditing
                        ? TextField(
                            controller: _nameController,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: loc.enterName,
                              hintStyle: GoogleFonts.poppins(),
                            ),
                          )
                        : Text(
                            userName.isNotEmpty ? userName : loc.noName,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                  IconButton(
                    icon: Icon(isEditing ? Icons.check : Icons.edit,
                        color: Colors.black),
                    onPressed: isSaving ? null : _toggleEdit,
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: isEditing
                        ? TextField(
                            controller: _emailController,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: loc.enterEmail,
                              hintStyle: GoogleFonts.poppins(),
                            ),
                          )
                        : Text(
                            userEmail.isNotEmpty ? userEmail : loc.noEmail,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(AppLocalizations loc) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                loc.totalVideos,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                loc.pendingVideos,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                loc.completedVideos,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildStatCard(totalVideos.toString()),
            const SizedBox(width: 12),
            _buildStatCard(pendingVideos.toString()),
            const SizedBox(width: 12),
            _buildStatCard(completedVideos.toString()),
          ],
        )
      ],
    );
  }

  Widget _buildStatCard(String value) {
    return Expanded(
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFFFF5A6B),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildMenuItem(String title, IconData icon,
      {bool isLogout = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isLogout ? Colors.red : const Color(0xFFFF5A6B)),
            const SizedBox(width: 12),
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isLogout ? Colors.red : Colors.black)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutUsSection(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        loc.aboutUsText,
        style: GoogleFonts.poppins(fontSize: 13, height: 1.5),
      ),
    );
  }
}