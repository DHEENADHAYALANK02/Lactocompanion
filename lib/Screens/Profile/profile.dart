import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'language.dart';
import 'terms&conditions.dart';
import 'privacyPolicy.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;

  String userName = '';
  String userEmail = '';
  String selectedLanguage = 'English';
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

    _authSub = supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.userUpdated) {
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
          SnackBar(content: Text("❌ No user signed in", style: GoogleFonts.poppins())),
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
        SnackBar(content: Text("✅ Profile updated successfully", style: GoogleFonts.poppins())),
      );
    } catch (e) {
      if (!mounted) return;
      debugPrint("❌ Profile save error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to update: $e", style: GoogleFonts.poppins())),
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

    if (result != null && result is Map<String, String>) {
      setState(() {
        selectedLanguage = result['language'] ?? selectedLanguage;
      });
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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Logout", style: GoogleFonts.poppins()),
        content: Text("Are you sure you want to logout?", style: GoogleFonts.poppins()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel", style: GoogleFonts.poppins())),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text("Logout", style: GoogleFonts.poppins()),
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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 182, 203, 1),
      body: Column(
        children: [
          _buildAppBar(),
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
                    _buildProfileSection(),
                    const SizedBox(height: 32),
                    _buildStatsSection(),
                    const SizedBox(height: 32),
                    _buildMenuItems(),
                    const SizedBox(height: 32),
                    _buildAboutUsSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
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
            "Profile",
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

  Widget _buildProfileSection() {
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
                              hintText: "Enter name",
                              hintStyle: GoogleFonts.poppins(),
                            ),
                          )
                        : Text(
                            userName.isNotEmpty ? userName : 'No name',
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
                              hintText: "Enter email",
                              hintStyle: GoogleFonts.poppins(),
                            ),
                          )
                        : Text(
                            userEmail.isNotEmpty ? userEmail : 'No email',
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

  Widget _buildStatsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Total Videos',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                'Pending Videos',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                'Completed Videos',
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

  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildMenuItem("Terms Of Condition", Icons.description,
            onTap: _navigateToTermsOfCondition),
        const SizedBox(height: 16),
        _buildMenuItem("Privacy Policy", Icons.privacy_tip,
            onTap: _navigateToPrivacyPolicy),
        const SizedBox(height: 16),
        _buildMenuItem("Log Out", Icons.logout,
            isLogout: true, onTap: _handleLogout),
      ],
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

  Widget _buildAboutUsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "At Otake, we believe healthcare should be simple, accessible, "
        "and reliable. Our platform connects patients with the best specialists "
        "at the right time.",
        style: GoogleFonts.poppins(fontSize: 13, height: 1.5),
      ),
    );
  }
}
