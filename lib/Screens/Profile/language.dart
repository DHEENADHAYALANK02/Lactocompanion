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
  bool isFirstTime = false;
  late final AnimationController _controller;
  late final Animation<double> _fade;

  final Map<String, Map<String, String>> langs = {
    'ar': {'flag': '🇦🇪', 'label': '(عربي)'},
    'en': {'flag': '🇦🇪', 'label': 'English'},
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward(from: 0.0);
    });

    _initPrefs();
  }

  Future<void> _initPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final chosen = prefs.getBool('language_chosen') ?? false;
    if (mounted) {
      setState(() => isFirstTime = !chosen);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    final isSmall = size.height < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header Section
                Row(
                  children: [
                    if (!isFirstTime)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black87),
                        onPressed: () => Navigator.pop(context),
                      ),
                    if (!isFirstTime) const SizedBox(width: 8),
                    Text(
                      loc?.selectLanguage ?? 'Select Language',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // 🔹 Title & Icon Section
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.language, color: Colors.pink, size: 60),
                      const SizedBox(height: 12),
                      Text(
                        'Choose Your Language',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.pink.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select your preferred language',
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 🔹 Language Selection Options
                Expanded(
                  child: ListView(
                    children: langs.keys.map((code) {
                      final isSel = selectedLanguage == code;
                      final data = langs[code]!;
                      return GestureDetector(
                        onTap: () => setState(() => selectedLanguage = code),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSel
                                ? const Color(0xFFFFF0F3)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSel ? Colors.pink : Colors.transparent,
                              width: 1.3,
                            ),
                            boxShadow: [
                              if (isSel)
                                BoxShadow(
                                  color: Colors.pink.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(data['flag']!,
                                  style: const TextStyle(fontSize: 26)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  data['label']!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: isSel
                                        ? Colors.pink.shade900
                                        : Colors.black87,
                                    fontWeight: isSel
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (isSel)
                                const Icon(Icons.check_circle,
                                    color: Colors.green),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // 🔹 Action Buttons
                Padding(
                  padding: EdgeInsets.only(bottom: isSmall ? 16 : 24, top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedLanguage.isEmpty
                              ? null
                              : () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      'app_lang', selectedLanguage);
                                  await prefs.setBool(
                                      'language_chosen', true);
                                  
                                  final locale = Locale(selectedLanguage);
                                  
                                  if (mounted) {
                                    MyApp.setLocale(context, locale);

                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 400),
                                        pageBuilder: (_, __, ___) =>
                                            BookingSuccessPage(
                                          selectedLanguage:
                                              selectedLanguage == 'ar'
                                                  ? 'Arabic'
                                                  : 'English',
                                          isFirstTimeUser: isFirstTime, // ✅ FIX: Add this parameter
                                        ),
                                        transitionsBuilder:
                                            (_, animation, __, child) =>
                                                FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedLanguage.isEmpty
                                ? Colors.grey.shade400
                                : Colors.green,
                            padding: EdgeInsets.symmetric(
                                vertical: isSmall ? 12 : 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            loc?.confirm ?? 'Confirm',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (!isFirstTime) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(
                                  vertical: isSmall ? 12 : 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              loc?.cancel ?? 'Cancel',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15,
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
    );
  }
}