import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import '../../main.dart';
import 'conform.dart';

class LanguageSelectionPage extends StatefulWidget {
  final String? currentLanguage;

  const LanguageSelectionPage({super.key, this.currentLanguage});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage>
    with SingleTickerProviderStateMixin {
  String selectedLanguage = '';
  bool isFirstTime = false; // ✅ Added to check first time
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Map<String, Map<String, String>> languageOptions = {
    'ar': {'title': 'United Arab Emirates', 'subtitle': '(عربي)', 'flag': '🇦🇪'},
    'en': {'title': 'United Arab Emirates', 'subtitle': 'English', 'flag': '🇦🇪'},
  };

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();

    _checkFirstTime(); // ✅ Check whether it's the first time

    if (widget.currentLanguage != null) {
      for (String key in languageOptions.keys) {
        if (languageOptions[key]!['subtitle'] == widget.currentLanguage) {
          selectedLanguage = key;
          break;
        }
      }
    }
  }

  // ✅ Function to check if this is the first time user opens app
  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    bool? chosen = prefs.getBool("language_chosen");
    setState(() {
      isFirstTime = !(chosen ?? false); // true if not chosen before
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isSmall = size.height < 700;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF3F6),
              Color(0xFFFFE1E8),
              Color(0xFFFFD6DE),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 🔹 Header
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black87),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        loc.selectLanguage,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 26 : 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  // 🔹 Center Section
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),
                        Icon(Icons.language_rounded,
                            size: isSmall ? 48 : 60, color: const Color(0xFFD81B60)),
                        const SizedBox(height: 24),
                        Text(
                          "Choose Your Language",
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 26 : 22,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFAD1457),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Select your preferred language",
                          style: GoogleFonts.poppins(
                            fontSize: isSmall ? 14 : 15,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // 🌐 Language Options
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: languageOptions.keys.map((key) {
                              final lang = languageOptions[key]!;
                              return _buildLanguageOption(
                                title: lang['title']!,
                                subtitle: lang['subtitle']!,
                                flag: lang['flag']!,
                                value: key,
                                isSmallDevice: isSmall,
                                isTablet: isTablet,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔹 Buttons Section
                  Padding(
                    padding: EdgeInsets.only(bottom: isSmall ? 20 : 30),
                    child: Row(
                      children: [
                        // ✅ Confirm Button (always visible)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: selectedLanguage.isEmpty
                                ? null
                                : () async {
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.setString("app_lang", selectedLanguage);
                                    await prefs.setBool("language_chosen", true);

                                    Locale newLocale = Locale(selectedLanguage);
                                    MyApp.setLocale(context, newLocale);

                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 500),
                                        pageBuilder: (_, __, ___) => BookingSuccessPage(
                                          selectedLanguage: selectedLanguage == "ar"
                                              ? "Arabic"
                                              : "English",
                                        ),
                                        transitionsBuilder:
                                            (_, animation, __, child) => FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedLanguage.isEmpty
                                  ? Colors.grey.shade400
                                  : const Color(0xFF00C851),
                              padding: EdgeInsets.symmetric(vertical: isSmall ? 14 : 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              loc.confirm,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: isSmall ? 14 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        // ✅ Cancel Button (hide if first time)
                        if (!isFirstTime) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF4444),
                                padding:
                                    EdgeInsets.symmetric(vertical: isSmall ? 14 : 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                loc.cancel,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: isSmall ? 14 : 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String subtitle,
    required String flag,
    required String value,
    required bool isSmallDevice,
    required bool isTablet,
  }) {
    final bool isSelected = selectedLanguage == value;

    return GestureDetector(
      onTap: () => setState(() => selectedLanguage = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF0F3) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFFE91E63) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFFE91E63).withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: isTablet ? 30 : 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: isSmallDevice ? 15 : 17,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF880E4F) : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF00C851)),
          ],
        ),
      ),
    );
  }
}
