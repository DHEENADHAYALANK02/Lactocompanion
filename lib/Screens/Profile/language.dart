import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class LanguageSelectionPage extends StatefulWidget {
  final String? currentLanguage; // ✅ From profile

  const LanguageSelectionPage({super.key, this.currentLanguage});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String selectedLanguage = '';

  final Map<String, Map<String, String>> languageOptions = {
    'ar': {
      'title': 'United Arab Emirates',
      'subtitle': '(عربي)',
      'display': 'عربي',
    },
    'en': {
      'title': 'United Arab Emirates',
      'subtitle': 'English',
      'display': 'English',
    },
    'ta': {
      'title': 'India',
      'subtitle': 'தமிழ்',
      'display': 'தமிழ்',
    },
  };

  @override
  void initState() {
    super.initState();
    // ✅ Load already selected language
    if (widget.currentLanguage != null) {
      for (String key in languageOptions.keys) {
        if (languageOptions[key]!['display'] == widget.currentLanguage) {
          selectedLanguage = key;
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
   final loc = AppLocalizations.of(context)!;


    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 182, 203, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(249, 182, 203, 1),
        toolbarHeight: kToolbarHeight + 15,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          loc.selectLanguage, // ✅ from l10n
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildOptionBox(),
            const Spacer(),
            _buildActionButtons(context, loc),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: languageOptions.keys.map((key) {
          final lang = languageOptions[key]!;
          return Column(
            children: [
              _buildLanguageOption(
                title: lang['title']!,
                subtitle: lang['subtitle']!,
                value: key,
              ),
              if (key != languageOptions.keys.last)
                Divider(height: 1, color: Colors.grey.shade300),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AppLocalizations loc) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.3)), // ✅ Fixed
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            loc.changeLanguage,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: selectedLanguage.isNotEmpty
                      ? () {
                          Navigator.pop(
                            context,
                            Locale(selectedLanguage),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C851),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 3,
                  ),
                  child: Text(
                    loc.confirm,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4444),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 3,
                  ),
                  child: Text(
                    loc.cancel,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String subtitle,
    required String value,
  }) {
    final bool isSelected = selectedLanguage == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF5F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.language, size: 28, color: Colors.pink),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                  Text(subtitle,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFF4CAF50)
                    : Colors.grey.shade300,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
